# M1.2p — Schematic connectivity gate

The source-level schematic gate requires the complete set of C64 User Port, CPLD, W5500, power, clock, and Ethernet signal identifiers to be present in the captured schematic.

This gate is intentionally separate from KiCad ERC. A source-level PASS confirms that the planned connectivity vocabulary is represented; it does not prove electrical correctness.

Required groups:

- PB0-PB7 data bus
- PA2 / HOST_STROBE
- FLAG2 / DEVICE_IRQ
- W5500 SCLK, MOSI, MISO, SCSn, RSTn, INTn
- 3V3 power
- EXRES1
- 25 MHz clock
- RJ45 Ethernet interface

## Status

- Source connectivity gate: implemented
- Native KiCad ERC: pending
- PCB: pending
