# M1.2l — KiCad symbol capture source

## Status

**M1.2l — capture source added; native ERC-qualified schematic still pending.**

`hardware/kicad/C64Ethernet_M1_2l_capture.sch` is an Eeschema capture-source file containing the intended component topology and signal naming for the first board revision.

## Captured blocks

- C64 User Port connector
- LC4032V-5TN48C CPLD
- W5500 Ethernet controller
- RJ45/magnetics interface
- 3.3 V regulator
- W5500 `EXRES1` resistor
- 25 MHz crystal
- C64/W5500 signal labels

## Important limitation

This file is deliberately treated as an engineering capture source rather than an ERC-qualified production schematic. The current repository's native `.kicad_sch` file still contains the connectivity-baseline representation. Before PCB layout, the design must be opened in KiCad, mapped to the exact installed symbol libraries/footprints, wired, and ERC-checked.

## Exit criteria for M1.2l

- [x] Component topology captured
- [x] Signal names captured
- [x] User Port / CPLD / W5500 / Ethernet blocks represented
- [ ] Native `.kicad_sch` populated with real embedded symbols
- [ ] Exact package pin mapping verified in KiCad
- [ ] ERC pass
- [ ] Footprints assigned

No hardware qualification is claimed at this stage.
