# M1.2f — CPLD pin assignment

## Reference device

Lattice **LC4032V-5TN48C**, 48-pin TQFP, 32 macrocells / 32 user I/O. The physical mapping below follows the published 48-pin TQFP device table.

## Physical assignment baseline

| Package pin | CPLD pad | C64Ethernet signal | Direction | Notes |
|---:|---|---|---|---|
| 2 | A5 | DATA0 / PB0 | bidirectional | C64 User Port |
| 3 | A6 | DATA1 / PB1 | bidirectional | C64 User Port |
| 4 | A7 | DATA2 / PB2 | bidirectional | C64 User Port |
| 7 | A8 | DATA3 / PB3 | bidirectional | C64 User Port |
| 8 | A9 | DATA4 / PB4 | bidirectional | C64 User Port |
| 9 | A10 | DATA5 / PB5 | bidirectional | C64 User Port |
| 10 | A11 | DATA6 / PB6 | bidirectional | C64 User Port |
| 13 | A12 | DATA7 / PB7 | bidirectional | C64 User Port |
| 14 | A13 | HOST_STROBE / PA2 | input | C64 → CPLD |
| 15 | A14 | DEVICE_IRQ / FLAG2 | output | CPLD → C64 |
| 16 | A15 / CLK1/I | CPLD_RESET_N | input | reset input |
| 19 | B1 | W5500_SCLK | output | SPI clock |
| 20 | B2 | W5500_MOSI | output | SPI MOSI |
| 21 | B3 | W5500_MISO | input | SPI MISO |
| 22 | B4 | W5500_SCSN | output | active-low chip select |
| 24 | B5 | W5500_INTN | input | active-low interrupt |
| 28 | B7 | W5500_RSTN | output | active-low reset |

## Reserved / required pins

| Package pin | Function | Handling |
|---:|---|---|
| 1 | TDI | JTAG/programming |
| 11 | TCK | JTAG/programming |
| 25 | TMS | JTAG/programming |
| 35 | TDO | JTAG/programming |
| 5, 12, 29, 37 | GND | common ground |
| 6, 30 | VCCO | 3.3 V I/O supply |
| 36 | VCC | 3.3 V device supply |

All four JTAG pins remain reserved. No external functional signal is assigned to them.

## Remaining spare I/O

The following user I/O remain available for diagnostics/future revisions: B0, B6, B8–B15 and A0–A4, subject to their documented special-function constraints.

## Electrical notes

- PB0–PB7 are a bidirectional bus and require explicit tri-state control in the CPLD HDL.
- CPLD outputs toward the C64 are 3.3 V logic; the CPLD must not drive 5 V onto the User Port.
- W5500-side signals remain in the 3.3 V domain.
- W5500 is specified for 3.3 V operation with 5 V-tolerant digital inputs. citeturn2search12turn2search1
- This is a pin-assignment baseline, not an ERC or timing qualification.

## Status

**M1.2f — physical pin assignment baseline PASS.**

Remaining M1.2b work:

- Native KiCad symbol/net capture
- Package/footprint verification in KiCad
- ERC
- PCB placement and routing
