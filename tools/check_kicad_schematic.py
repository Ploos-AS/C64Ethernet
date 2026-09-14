#!/usr/bin/env python3
"""Guard the C64Ethernet KiCad schematic milestone.

This is intentionally a structural gate, not an ERC replacement.  It prevents
an empty/placeholder .kicad_sch from being mistaken for a captured schematic.
"""
from pathlib import Path
import re
import sys

SCHEMATIC = Path("hardware/kicad/C64Ethernet.kicad_sch")
REQUIRED = (
    "LC4032V",
    "W5500",
    "PB0",
    "PB7",
    "HOST_STROBE",
    "DEVICE_IRQ",
    "W5500_SCLK",
    "W5500_MOSI",
    "W5500_MISO",
    "W5500_SCSN",
    "W5500_INTN",
    "W5500_RSTN",
    "3.3V",
    "EXRES1",
)


def main() -> int:
    if not SCHEMATIC.exists():
        print(f"FAIL: missing {SCHEMATIC}")
        return 1

    text = SCHEMATIC.read_text(encoding="utf-8")
    if not text.lstrip().startswith("(kicad_sch"):
        print("FAIL: file is not a KiCad S-expression schematic")
        return 1

    if "(lib_symbols)" in text and not re.search(r"\(lib_symbols\s+\(", text):
        print("FAIL: schematic has an empty lib_symbols block")
        return 1

    missing = [item for item in REQUIRED if item not in text]
    if missing:
        print("FAIL: missing required schematic identifiers:")
        for item in missing:
            print(f"  - {item}")
        return 1

    if "connectivity baseline" in text.lower() and "real symbols" not in text.lower():
        print("FAIL: placeholder/connectivity-only schematic is not acceptable")
        return 1

    print("PASS: KiCad schematic structure gate")
    print(f"  file: {SCHEMATIC}")
    print(f"  required identifiers: {len(REQUIRED)}")
    print("  ERC: NOT RUN")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
