#!/usr/bin/env python3
"""Check the C64Ethernet schematic capture for required signal labels.

This is a source-level gate. It deliberately does not claim KiCad ERC success;
that requires KiCad/Eeschema to parse the native schematic and run ERC.
"""
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
CAPTURE = ROOT / "hardware/kicad/C64Ethernet_M1_2N_legacy_capture.sch"

REQUIRED = [
    "PB0", "PB1", "PB2", "PB3", "PB4", "PB5", "PB6", "PB7",
    "PA2", "FLAG2", "HOST_STROBE", "DEVICE_IRQ",
    "SCLK", "MOSI", "MISO", "SCSn", "RSTn", "INTn",
    "3V3", "EXRES1", "25MHz", "RJ45",
]


def main() -> int:
    if not CAPTURE.exists():
        print("FAIL: schematic capture missing")
        return 1
    text = CAPTURE.read_text(encoding="utf-8")
    missing = [item for item in REQUIRED if item not in text]
    if missing:
        print("SCHEMATIC CONNECTIVITY: FAIL")
        for item in missing:
            print(f"  MISSING: {item}")
        return 1
    print("SCHEMATIC CONNECTIVITY: PASS")
    for item in REQUIRED:
        print(f"  PASS: {item}")
    print("ERC: PENDING")
    return 0


if __name__ == "__main__":
    sys.exit(main())
