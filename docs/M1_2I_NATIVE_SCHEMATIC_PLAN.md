# M1.2i — Native KiCad schematic plan

## Status

Engineering baseline complete; native schematic implementation is the next hardware deliverable.

## Components

- J1: C64 User Port edge connector/header
- U1: LC4032V-5TN48C, 48-pin TQFP CPLD
- U2: W5500, LQFP-48
- Y1: 25 MHz crystal
- R: W5500 reference/termination resistors
- C: local bypass and crystal capacitors
- FB1: digital/analog supply isolation
- U3: 3.3 V regulator from C64 +5 V
- J2: RJ45 with integrated magnetics, selected against WIZnet reference requirements
- ESD protection at external Ethernet connector

## Signal groups

### User Port → CPLD

- PB0..PB7: 8-bit bidirectional data bus
- PA2: host strobe
- FLAG2: device IRQ/ready
- RESET: controller reset

### CPLD → W5500

- SPI_SCLK
- SPI_MOSI
- SPI_MISO
- SPI_CS_N
- W5500_RST_N
- W5500_INT_N

## Power

- C64 +5 V is the board input.
- A regulated 3.3 V rail powers the CPLD and W5500 digital/analog domains as required.
- W5500 analog supply isolation follows the vendor reference design.
- Decoupling is placed at each IC power pin group.

## W5500 reference requirements

The native schematic must preserve the vendor reference values and topology, including:

- EXRES1: 12.4 kΩ, 1% to AGND
- 25 MHz crystal network
- required Ethernet termination components
- reset and interrupt signals
- correct RJ45/magnetics topology

## Package-pin policy

Physical package pin numbers must be taken from the exact KiCad symbol/footprint and verified against the current vendor datasheets before committing the final PCB. Logical signal names are frozen; physical package assignment remains an engineering verification step.

## Exit criteria

M1.2i is complete only when:

1. A native `.kicad_sch` opens in KiCad.
2. Every electrical connection is represented by a real symbol/net.
3. Power symbols and no-connect markers are explicit.
4. ERC can run without unresolved design errors.
5. The exact CPLD package and W5500 package are documented.
6. The schematic is ready for PCB assignment.
