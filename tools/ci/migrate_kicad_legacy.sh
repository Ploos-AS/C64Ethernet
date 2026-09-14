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

# KiCad shows its first-run settings wizard when the versioned settings
# directory does not contain kicad_common.json. In CI, give KiCad a disposable
# configuration root and seed a valid common settings file so Eeschema opens
# the requested schematic directly instead of blocking on the wizard.
export KICAD_CONFIG_HOME="$ROOT/build/kicad/config"
KICAD_SETTINGS_DIR="$KICAD_CONFIG_HOME/7.0"
mkdir -p "$KICAD_SETTINGS_DIR"
cat >"$KICAD_SETTINGS_DIR/kicad_common.json" <<'JSON'
{
  "meta": {
    "version": 3
  },
  "do_not_show_again": {
    "data_collection_prompt": true,
    "env_var_overwrite_warning": true,
    "scaled_3d_models_warning": true,
    "zone_fill_warning": true
  }
}
JSON

# KiCad performs legacy-to-native conversion when a legacy schematic is opened
# in Eeschema and saved. Run Eeschema under Xvfb. Do not use windowactivate:
# Xvfb has no EWMH-capable window manager and xdotool windowactivate therefore
# fails with _NET_ACTIVE_WINDOW. xdotool can send keys directly to the window.
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

eeschema "$LEGACY" >"$LOG" 2>&1 &
EESCHEMA_PID=$!

WINDOW=""
for _ in $(seq 1 60); do
  # Ignore auxiliary first-run/dialog windows: wait for the actual schematic
  # editor title containing the legacy file name.
  for id in $(xdotool search --onlyvisible --class Eeschema 2>/dev/null || true); do
    name="$(xdotool getwindowname "$id" 2>/dev/null || true)"
    if [[ "$name" == *"C64Ethernet_M1_2N_legacy_capture"* ]]; then
      WINDOW="$id"
      break 2
    fi
  done
  if ! kill -0 "$EESCHEMA_PID" 2>/dev/null; then
    echo "Eeschema exited before the schematic editor appeared" >&2
    cat "$LOG" >&2 || true
    exit 1
  fi
  sleep 1
done

if [[ -z "$WINDOW" ]]; then
  echo "Eeschema schematic editor did not appear" >&2
  echo "visible Eeschema windows:" >&2
  for id in $(xdotool search --onlyvisible --class Eeschema 2>/dev/null || true); do
    echo "  $id: $(xdotool getwindowname "$id" 2>/dev/null || true)" >&2
  done
  cat "$LOG" >&2 || true
  exit 1
fi

echo "Eeschema schematic window: $WINDOW ($(xdotool getwindowname "$WINDOW" 2>/dev/null || echo unknown))" | tee -a "$LOG"

# Send Ctrl+S directly to the actual schematic editor window. This works under
# bare Xvfb and avoids the _NET_ACTIVE_WINDOW dependency.
xdotool key --window "$WINDOW" --clearmodifiers ctrl+s

# Give KiCad time to convert and write the native schematic. Some versions
# create the native file under the legacy basename first.
for _ in $(seq 1 30); do
  if [[ -f "$NATIVE" || -f "$ALT" ]]; then
    break
  fi
  sleep 1
done

# Close the window directly; failure here is non-fatal once the file exists.
xdotool key --window "$WINDOW" --clearmodifiers alt+F4 2>/dev/null || true
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

# A migrated native schematic must contain the native root and an embedded
# symbol library section. The project validation script performs deeper checks.
grep -q '^(kicad_sch ' "$NATIVE" || {
  echo "output is not a native KiCad schematic" >&2
  exit 1
}
grep -q '(lib_symbols' "$NATIVE" || {
  echo "native schematic has no embedded symbol library" >&2
  exit 1
}

echo "KiCad legacy migration produced: $NATIVE"
