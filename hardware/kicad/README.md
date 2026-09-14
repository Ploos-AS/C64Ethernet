# C64Ethernet KiCad hardware

This directory contains the hardware design for the C64 User Port Ethernet adapter.

## Current status

`C64Ethernet.sch` is the **M1.2a engineering schematic draft**. It records the electrical topology, User Port allocation, power-domain boundary, W5500 interface, and Ethernet physical-interface requirements.

It is intentionally not marked as ERC-qualified yet. The next hardware step is to convert/finalize the draft as a native KiCad schematic with explicit symbols, nets, footprints, protection components, and the selected W5500 reference circuit.

## User Port reference

The C64 User Port exposes +5 V on pin 2, ground on pins 1/12/A/N, RESET on pin 3, FLAG2 on B, PB0-PB7 on C-L, and PA2 on M. The board must respect the +5 V current limit of the User Port.

## Planned files

- `C64Ethernet.kicad_pro` — KiCad project
- `C64Ethernet.kicad_sch` — native KiCad schematic
- `C64Ethernet.kicad_pcb` — PCB
- `gerbers/` — manufacturing output
- `bom/` — manufacturing BOM
