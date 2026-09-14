# M1.2c Controller Decision

## Decision

The reference design will use a **small CPLD/programmable-logic bridge**, not a general-purpose MCU, between the C64 User Port and the W5500.

## Rationale

The W5500 already contains the Ethernet MAC, PHY and hardwired TCP/IP stack and exposes a high-speed SPI host interface. A general-purpose MCU would add firmware, boot, update and reset complexity without being required for the first design. WIZnet documents SPI operation up to 80 MHz and supports SPI modes 0 and 3. The C64 User Port is a parallel interface, so programmable logic is a natural impedance-matching and protocol-translation boundary.

The CPLD bridge will:

- present a deterministic parallel register/FIFO interface to the C64;
- serialize accesses to W5500 SPI;
- provide clean CSn framing;
- synchronize W5500 INTn into the C64-visible status path;
- provide reset control;
- isolate the C64 bus from Ethernet-side timing;
- leave room for later protocol revisions without changing the W5500 side.

## Important constraint

The CPLD is **not** intended to implement TCP/IP. TCP/IP remains in the W5500.

## Initial host protocol concept

The C64 sees a small memory-mapped command/status interface exposed through the User Port handshake signals. The exact register map is an M2 software milestone and is deliberately not frozen here.

Candidate operations:

- controller reset
- status/link query
- W5500 register read/write
- socket command/data transfer
- interrupt/status acknowledgement
- bulk FIFO transfer

## Alternatives considered

### Direct bit-banged SPI

Rejected as the primary design. It minimizes hardware but wastes the User Port's parallel capability and puts timing-sensitive SPI framing into 6502 software.

### MCU bridge

Deferred. An MCU could simplify complex buffering or future firmware features, but it adds another processor and firmware lifecycle. It remains a possible later variant.

### FPGA bridge

Deferred. An FPGA offers more resources than required for the first board and would increase cost and board complexity.

## Exit criteria

M1.2c controller architecture is complete when:

- CPLD role is documented;
- User Port handshake allocation is frozen;
- W5500 SPI signals are frozen;
- reset/interrupt behavior is defined;
- the design can be translated into a native KiCad schematic without an MCU dependency.
