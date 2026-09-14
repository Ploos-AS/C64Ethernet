# M1.2h — User Port voltage-interface decision

## Decision

Use the LC4032V-5TN48C as the 3.3 V CPLD and retain its documented 5 V-tolerant I/O capability for the User Port side, subject to the selected I/O standards and final pin-level review. Do not add an unnecessary 16-bit level-shifter bank in the first revision.

Lattice's current family documentation identifies LC4032V as a 3.3 V device with 5 V-tolerant I/O. The exact package and I/O assignment must still be checked against the final datasheet/pin table before PCB release.

The W5500 itself operates from 3.3 V and its documented inputs are 5 V tolerant, so the CPLD-to-W5500 SPI/control connection does not require a separate voltage translator when the CPLD operates at 3.3 V.

## User Port protection

The C64 User Port remains an external connector and should receive practical protection appropriate to a retro expansion card. Series resistors are preferred where they improve contention/current limiting without compromising the timing budget. ESD protection may be added at the connector where it does not introduce excessive capacitance.

## Directionality

- PB0-PB7 are bidirectional and must never be driven simultaneously by the C64 and CPLD.
- PA2 is an input to the controller side for the host strobe.
- FLAG2 is driven by the controller as the interrupt/ready indication.
- Reset is treated as an active-low controller reset.

## Exit criteria

- Final LC4032V package pinout checked against the manufacturer datasheet.
- KiCad symbol and footprint match the selected device.
- All User Port signals have explicit direction and electrical type.
- No unverified 5 V assumption remains in the release schematic.
- ERC passes before PCB layout is declared ready.

## Status

M1.2h — architecture decision documented. Final electrical qualification remains pending native KiCad ERC.
