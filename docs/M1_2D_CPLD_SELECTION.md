# M1.2d — CPLD selection

## Selected device

**Lattice LC4032V-5TN48C** is the reference CPLD for the first hardware revision.

The ispMACH 4000V family is a 3.3 V CPLD family with 5 V-tolerant I/O. The LC4032V provides 32 macrocells and, in the 48-pin TQFP package, 32 user I/O. The -5 speed grade specifies a 5 ns tPD grade. This gives enough I/O for the C64 parallel interface, W5500 SPI/control signals, JTAG/programming and status while keeping the package hand-solderable. The Lattice family data sheet lists the LC4032V 48-pin TQFP variants and 3.3 V operation; Lattice documentation identifies ispMACH 4000V as 5 V-tolerant. 

## Why this device

- 3.3 V operation matches the W5500-side logic domain.
- 5 V-tolerant I/O avoids placing a level translator on every C64 User Port signal.
- 48-pin TQFP is practical for a prototype PCB.
- 32 macrocells are sufficient for the initial parallel-to-SPI bridge and handshake FSM.
- JTAG programming is available for development and manufacturing.

## Important electrical rule

5 V tolerance does **not** mean the CPLD should drive 5 V logic into the C64. CPLD outputs connected to the C64 must be configured so their output-high voltage is compatible with the C64 input thresholds and the interface must be reviewed for direction and bus contention. Series resistors and explicit tri-state control should be used where appropriate.

## Bridge allocation

The initial allocation reserves:

- 8 pins: C64 User Port data bus PB0..PB7
- 3–4 pins: User Port handshake/control
- 4 pins: W5500 MOSI/MISO/SCLK/CS
- 2 pins: W5500 INTn/RSTn
- JTAG/programming pins
- spare GPIO for diagnostics and future revisions

The exact physical pin assignment will be frozen during native KiCad schematic capture and package pinout review.

## Alternatives considered

### MachXO2

Not selected for the first revision because its standard I/O supply options are low-voltage and the available family documentation does not make it the simplest direct 5 V User Port interface. MachXO2 remains a good candidate for a later design with explicit level translation.

### XC2C64A CoolRunner-II

Technically attractive, but its documented multi-voltage I/O range is 1.5–3.3 V rather than a direct 5 V-tolerant User Port solution. It therefore does not simplify the C64 interface as much as LC4032V.

## Status

**M1.2d — PASS: reference CPLD selected.**

Native KiCad schematic, exact package pin assignment, timing constraints and electrical ERC remain next.
