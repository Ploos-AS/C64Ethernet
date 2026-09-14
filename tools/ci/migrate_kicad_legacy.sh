#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
LEGACY="$ROOT/hardware/kicad/C64Ethernet_M1_2N_legacy_capture.sch"
NATIVE="$ROOT/hardware/kicad/C64Ethernet.kicad_sch"
LOG="$ROOT/build/kicad/migration.log"
mkdir -p "$ROOT/build/kicad"

if [[ ! -f "$LEGACY" ]]; then
  echo "missing legacy schematic: $LEGACY" >&2
  exit 1
fi

# KiCad performs legacy-to-native conversion when a legacy schematic is opened
# in Eeschema and saved. Run the GUI under Xvfb and automate the save operation.
export DISPLAY=:99
Xvfb :99 -screen 0 1280x900x24 >/tmp/c64ethernet-xvfb.log 2>&1 &
XVFB_PID=$!
trap 'kill "$XVFB_PID" 2>/dev/null || true' EXIT
sleep 2

rm -f "$NATIVE"
rm -f "$ROOT/hardware/kicad/C64Ethernet_M1_2N_legacy_capture.kicad_sch"

eeschema "$LEGACY" >"$LOG" 2>&1 &
EESCHEMA_PID=$!
trap 'kill "$EESCHEMA_PID" 2>/dev/null || true; kill "$XVFB_PID" 2>/dev/null || true' EXIT

for _ in $(seq 1 60); do
  if xdotool search --onlyvisible --class Eeschema >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

WINDOW="$(xdotool search --onlyvisible --class Eeschema | head -n1 || true)"
if [[ -z "$WINDOW" ]]; then
  echo "Eeschema window did not appear" >&2
  cat "$LOG" >&2 || true
  exit 1
fi

# Ctrl+S triggers KiCad's legacy conversion/save path.
xdotool windowactivate "$WINDOW"
xdotool key --window "$WINDOW" ctrl+s
sleep 5
xdotool key --window "$WINDOW" alt+F4 || true
sleep 3

if [[ ! -f "$NATIVE" ]]; then
  # Depending on KiCad version, the converted file may initially use the
  # legacy basename. Accept it and normalize to the project schematic name.
  ALT="$ROOT/hardware/kicad/C64Ethernet_M1_2N_legacy_capture.kicad_sch"
  if [[ -f "$ALT" ]]; then
    mv "$ALT" "$NATIVE"
  fi
fi

if [[ ! -f "$NATIVE" ]]; then
  echo "legacy migration did not produce $NATIVE" >&2
  cat "$LOG" >&2 || true
  exit 1
fi

echo "KiCad legacy migration produced: $NATIVE"
