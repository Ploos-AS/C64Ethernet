#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
LEGACY="$ROOT/hardware/kicad/C64Ethernet_M1_2N_legacy_capture.sch"
NATIVE="$ROOT/hardware/kicad/C64Ethernet.kicad_sch"
ALT="$ROOT/hardware/kicad/C64Ethernet_M1_2N_legacy_capture.kicad_sch"
LOG="$ROOT/build/kicad/migration.log"
mkdir -p "$ROOT/build/kicad"

if [[ ! -f "$LEGACY" ]]; then
  echo "missing legacy schematic: $LEGACY" >&2
  exit 1
fi

export KICAD_CONFIG_HOME="$ROOT/build/kicad/config"
KICAD_MAJOR="$(kicad-cli version | sed -E 's/^([0-9]+).*/\1/')"
KICAD_SETTINGS_DIR="$KICAD_CONFIG_HOME/${KICAD_MAJOR}.0"
mkdir -p "$KICAD_SETTINGS_DIR"
cat >"$KICAD_SETTINGS_DIR/kicad_common.json" <<'JSON'
{
  "meta": { "version": 3 },
  "do_not_show_again": {
    "data_collection_prompt": true,
    "env_var_overwrite_warning": true,
    "scaled_3d_models_warning": true,
    "zone_fill_warning": true
  }
}
JSON
cat >"$KICAD_SETTINGS_DIR/sym-lib-table" <<'EOF'
(sym_lib_table
  (version 7)
)
EOF

export DISPLAY=:99
Xvfb :99 -screen 0 1280x900x24 >/tmp/c64ethernet-xvfb.log 2>&1 &
XVFB_PID=$!
EESCHEMA_PID=""
cleanup() {
  if [[ -n "$EESCHEMA_PID" ]]; then
    kill "$EESCHEMA_PID" 2>/dev/null || true
  fi
  kill "$XVFB_PID" 2>/dev/null || true
}
trap cleanup EXIT
sleep 2

rm -f "$NATIVE" "$ALT"

eeschema >"$LOG" 2>&1 &
EESCHEMA_PID=$!

# KiCad releases have changed the X11 WM_CLASS used by eeschema.  Detect the
# editor primarily by its title and only use the class as a compatibility hint.
EDITOR=""
for _ in $(seq 1 60); do
  while read -r id; do
    [[ -n "$id" ]] || continue
    name="$(xdotool getwindowname "$id" 2>/dev/null || true)"
    class="$(xprop -id "$id" WM_CLASS 2>/dev/null || true)"
    if [[ "$name" == *"Schematic Editor"* || "$class" == *"eeschema"* || "$class" == *"Eeschema"* ]]; then
      EDITOR="$id"
      break
    fi
  done < <(xdotool search --onlyvisible --name '.*' 2>/dev/null || true)
  [[ -n "$EDITOR" ]] && break
  if ! kill -0 "$EESCHEMA_PID" 2>/dev/null; then
    echo "Eeschema exited before editor appeared" >&2
    cat "$LOG" >&2 || true
    exit 1
  fi
  sleep 1
done

if [[ -z "$EDITOR" ]]; then
  echo "Eeschema editor did not appear" >&2
  echo "visible windows:" >&2
  xdotool search --onlyvisible --name '.*' 2>/dev/null | while read -r id; do
    echo "  $id: $(xdotool getwindowname "$id" 2>/dev/null || true) / $(xprop -id "$id" WM_CLASS 2>/dev/null || true)" >&2
  done
  cat "$LOG" >&2 || true
  exit 1
fi

echo "Eeschema editor: $EDITOR ($(xdotool getwindowname "$EDITOR" 2>/dev/null || true))" | tee -a "$LOG"
xdotool key --window "$EDITOR" --clearmodifiers ctrl+o
sleep 2

DIALOG=""
for _ in $(seq 1 30); do
  while read -r id; do
    [[ -n "$id" ]] || continue
    [[ "$id" != "$EDITOR" ]] || continue
    name="$(xdotool getwindowname "$id" 2>/dev/null || true)"
    case "$name" in
      "Open Schematic"|"Open File"|"Open")
        DIALOG="$id"
        break
        ;;
    esac
  done < <(xdotool search --onlyvisible --name '.*' 2>/dev/null || true)
  [[ -n "$DIALOG" ]] && break
  sleep 1
done

if [[ -z "$DIALOG" ]]; then
  echo "open-file dialog did not appear" >&2
  exit 1
fi

echo "Open dialog: $DIALOG ($(xdotool getwindowname "$DIALOG" 2>/dev/null || true))" | tee -a "$LOG"
xdotool windowfocus --sync "$DIALOG"
xdotool key --clearmodifiers ctrl+a
xdotool type --clearmodifiers --delay 1 "$LEGACY"
xdotool key --clearmodifiers Return
sleep 3

if xdotool search --onlyvisible --name '^Open Schematic$' >/dev/null 2>&1; then
  xdotool windowfocus --sync "$DIALOG" 2>/dev/null || true
  xdotool key --clearmodifiers slash
  sleep 1
  xdotool type --clearmodifiers --delay 1 "${LEGACY#/}"
  xdotool key --clearmodifiers Return
fi

for _ in $(seq 1 60); do
  REMAP="$(xdotool search --onlyvisible --name '^Remap Symbols$' 2>/dev/null | tail -n1 || true)"
  if [[ -n "$REMAP" ]]; then
    echo "Remap dialog: $REMAP" | tee -a "$LOG"
    xdotool windowfocus --sync "$REMAP" 2>/dev/null || true
    xdotool key --clearmodifiers Return 2>/dev/null || true
    sleep 2
    if xdotool search --onlyvisible --name '^Remap Symbols$' >/dev/null 2>&1; then
      for _tab in $(seq 1 12); do
        xdotool key --clearmodifiers Tab
        xdotool key --clearmodifiers Return
        sleep 1
        if ! xdotool search --onlyvisible --name '^Remap Symbols$' >/dev/null 2>&1; then
          break
        fi
      done
    fi
    break
  fi
  if xdotool search --onlyvisible --name '.*C64Ethernet_M1_2N_legacy_capture.*' >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

WINDOW=""
for _ in $(seq 1 90); do
  while read -r id; do
    [[ -n "$id" ]] || continue
    name="$(xdotool getwindowname "$id" 2>/dev/null || true)"
    if [[ "$name" == *"C64Ethernet_M1_2N_legacy_capture"* ]]; then
      WINDOW="$id"
      break
    fi
  done < <(xdotool search --onlyvisible --name '.*' 2>/dev/null || true)
  [[ -n "$WINDOW" ]] && break
  sleep 1
done

if [[ -z "$WINDOW" ]]; then
  echo "legacy schematic did not load" >&2
  echo "visible windows:" >&2
  xdotool search --onlyvisible --name '.*' 2>/dev/null | while read -r id; do
    echo "  $id: $(xdotool getwindowname "$id" 2>/dev/null || true) / $(xprop -id "$id" WM_CLASS 2>/dev/null || true)" >&2
  done
  cat "$LOG" >&2 || true
  exit 1
fi

echo "Loaded legacy schematic: $WINDOW ($(xdotool getwindowname "$WINDOW" 2>/dev/null || true))" | tee -a "$LOG"
xdotool windowfocus --sync "$WINDOW"
xdotool key --clearmodifiers ctrl+s

for _ in $(seq 1 30); do
  if [[ -f "$NATIVE" || -f "$ALT" ]]; then
    break
  fi
  sleep 1
done

xdotool key --clearmodifiers alt+F4 2>/dev/null || true
sleep 2

if [[ ! -f "$NATIVE" && -f "$ALT" ]]; then
  mv "$ALT" "$NATIVE"
fi

if [[ ! -f "$NATIVE" ]]; then
  echo "legacy migration did not produce $NATIVE" >&2
  cat "$LOG" >&2 || true
  cat /tmp/c64ethernet-xvfb.log >&2 || true
  exit 1
fi

grep -q '^(kicad_sch ' "$NATIVE" || { echo "output is not a native KiCad schematic" >&2; exit 1; }
grep -q '(lib_symbols' "$NATIVE" || { echo "native schematic has no embedded symbol library" >&2; exit 1; }

cp "$NATIVE" "$ROOT/build/kicad/C64Ethernet-migrated.kicad_sch"
echo "KiCad legacy migration produced: $NATIVE"
