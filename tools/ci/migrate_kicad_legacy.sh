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
      "Open Schematic"|"Open File"|"Open") DIALOG="$id"; break ;;
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

for _ in $(seq 1 120); do
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
        if ! xdotool search --onlyvisible --name '^Remap Symbols$' >/dev/null 2>&1; then break; fi
      done
    fi
  fi

  RESCUE="$(xdotool search --onlyvisible --name '^Project Rescue Helper$' 2>/dev/null | tail -n1 || true)"
  if [[ -n "$RESCUE" ]]; then
    echo "Project Rescue Helper: $RESCUE" | tee -a "$LOG"
    xdotool windowfocus --sync "$RESCUE" 2>/dev/null || true
    xdotool key --clearmodifiers Return 2>/dev/null || true
    sleep 2
    if xdotool search --onlyvisible --name '^Project Rescue Helper$' >/dev/null 2>&1; then
      for _tab in $(seq 1 16); do
        xdotool key --clearmodifiers Tab 2>/dev/null || true
        xdotool key --clearmodifiers Return 2>/dev/null || true
        sleep 1
        if ! xdotool search --onlyvisible --name '^Project Rescue Helper$' >/dev/null 2>&1; then break; fi
      done
    fi
  fi

  if xdotool search --onlyvisible --name '.*C64Ethernet_M1_2N_legacy_capture.*' >/dev/null 2>&1; then break; fi
  sleep 1
done

WINDOW=""
for _ in $(seq 1 90); do
  while read -r id; do
    [[ -n "$id" ]] || continue
    name="$(xdotool getwindowname "$id" 2>/dev/null || true)"
    if [[ "$name" == *"C64Ethernet_M1_2N_legacy_capture"* ]]; then WINDOW="$id"; break; fi
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

# KiCad 9 may leave Remap Symbols mapped even after the legacy schematic is
# visible.  A mapped modal steals Ctrl+Shift+S from the editor, so explicitly
# dismiss any stale migration dialogs and prove the editor owns focus before
# attempting Save As.
for _ in $(seq 1 20); do
  STALE="$(xdotool search --onlyvisible --name '^(Remap Symbols|Project Rescue Helper)$' 2>/dev/null | tail -n1 || true)"
  [[ -n "$STALE" ]] || break
  echo "Dismissing stale migration dialog: $STALE ($(xdotool getwindowname "$STALE" 2>/dev/null || true))" | tee -a "$LOG"
  xdotool windowfocus --sync "$STALE" 2>/dev/null || true
  xdotool key --clearmodifiers Escape 2>/dev/null || true
  sleep 1
  if xdotool search --onlyvisible --name '^(Remap Symbols|Project Rescue Helper)$' >/dev/null 2>&1; then
    xdotool key --clearmodifiers alt+F4 2>/dev/null || true
    sleep 1
  fi
done

if xdotool search --onlyvisible --name '^(Remap Symbols|Project Rescue Helper)$' >/dev/null 2>&1; then
  echo "migration modal still visible before Save As" >&2
  exit 1
fi

xdotool windowfocus --sync "$WINDOW"
sleep 1
FOCUSED="$(xdotool getwindowfocus 2>/dev/null || true)"
if [[ "$FOCUSED" != "$WINDOW" ]]; then
  echo "editor did not acquire focus before Save As: wanted $WINDOW got $FOCUSED" >&2
  exit 1
fi

echo "Editor focused for Save As: $WINDOW" | tee -a "$LOG"
xdotool key --window "$WINDOW" --clearmodifiers ctrl+shift+s
sleep 2

# KiCad 9 converts a legacy .sch through Save As.  Drive the native chooser
# explicitly instead of relying on Ctrl+S, which can leave the converted file
# under an implicit legacy-derived name or wait on an unseen chooser.
SAVE=""
for _ in $(seq 1 30); do
  while read -r id; do
    [[ -n "$id" ]] || continue
    name="$(xdotool getwindowname "$id" 2>/dev/null || true)"
    case "$name" in
      "Save Schematic As"|"Save As"|"Save File"|"Save") SAVE="$id"; break ;;
    esac
  done < <(xdotool search --onlyvisible --name '.*' 2>/dev/null || true)
  [[ -n "$SAVE" ]] && break
  sleep 1
done

if [[ -n "$SAVE" ]]; then
  echo "Save dialog: $SAVE ($(xdotool getwindowname "$SAVE" 2>/dev/null || true))" | tee -a "$LOG"
  xdotool windowfocus --sync "$SAVE" 2>/dev/null || true
  xdotool key --clearmodifiers slash 2>/dev/null || true
  sleep 1
  xdotool type --clearmodifiers --delay 1 "$NATIVE"
  xdotool key --clearmodifiers Return
  sleep 2
  if xdotool search --onlyvisible --name '^(Save Schematic As|Save As|Save File|Save)$' >/dev/null 2>&1; then
    xdotool key --clearmodifiers Return 2>/dev/null || true
  fi
else
  echo "Save As dialog did not appear; falling back to Ctrl+S" | tee -a "$LOG"
  xdotool windowfocus --sync "$WINDOW" 2>/dev/null || true
  xdotool key --clearmodifiers ctrl+s
fi

for _ in $(seq 1 20); do
  if [[ -f "$NATIVE" || -f "$ALT" ]]; then break; fi
  CONFIRM="$(xdotool search --onlyvisible --name '^(Confirm Save As|Confirm|Warning)$' 2>/dev/null | tail -n1 || true)"
  if [[ -n "$CONFIRM" ]]; then
    echo "Save confirmation: $CONFIRM ($(xdotool getwindowname "$CONFIRM" 2>/dev/null || true))" | tee -a "$LOG"
    xdotool windowfocus --sync "$CONFIRM" 2>/dev/null || true
    xdotool key --clearmodifiers Return 2>/dev/null || true
  fi
  sleep 1
done

xdotool key --clearmodifiers alt+F4 2>/dev/null || true
sleep 2

if [[ ! -f "$NATIVE" && -f "$ALT" ]]; then mv "$ALT" "$NATIVE"; fi

if [[ ! -f "$NATIVE" ]]; then
  echo "legacy migration did not produce $NATIVE" >&2
  echo "visible windows at save failure:" >&2
  xdotool search --onlyvisible --name '.*' 2>/dev/null | while read -r id; do
    echo "  $id: $(xdotool getwindowname "$id" 2>/dev/null || true)" >&2
  done
  cat "$LOG" >&2 || true
  cat /tmp/c64ethernet-xvfb.log >&2 || true
  exit 1
fi

grep -q '^(kicad_sch ' "$NATIVE" || { echo "output is not a native KiCad schematic" >&2; exit 1; }
grep -q '(lib_symbols' "$NATIVE" || { echo "native schematic has no embedded symbol library" >&2; exit 1; }

cp "$NATIVE" "$ROOT/build/kicad/C64Ethernet-migrated.kicad_sch"
echo "KiCad legacy migration produced: $NATIVE"
