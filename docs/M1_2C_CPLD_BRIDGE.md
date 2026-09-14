# M1.2c — CPLD bridge design

## Decision

The reference design uses a small CPLD between the C64 User Port and the W5500.

```text
C64 6502
  |
  | PB0..PB7 + control
  v
+----------------+
| CPLD            |
| User Port FSM   |
| + SPI master    |
+--------+-------+
         |
         | MOSI/MISO/SCLK/CS
         | RESET/INT
         v
+----------------+
| W5500          |
+----------------+
```

## Why CPLD

- Converts the C64's parallel User Port transfers into deterministic W5500 SPI transactions.
- Avoids adding an application MCU and a second firmware stack to the first revision.
- Gives deterministic timing and simple reset behavior.
- Leaves the W5500 responsible for Ethernet and TCP/IP functions.
- Provides a clean boundary for later FPGA or MCU variants.

## Proposed logical interface

The CPLD exposes a byte-oriented register window to the C64-side driver. The exact handshake and timing are intentionally specified before pin-level implementation.

Minimum operations:

- controller status read
- W5500 register/data transfer
- reset request
- interrupt/status indication
- controller identification/version read

## Electrical boundary

The C64 User Port is a 5 V-era interface. The CPLD implementation must therefore use an appropriate 5 V-tolerant/input-compatible strategy or explicit level translation. The W5500 side remains 3.3 V.

No assumption is made that a generic modern CPLD I/O bank can be connected directly to the C64 User Port.

## M1.2c exit criteria

- CPLD family selected.
- I/O voltage strategy documented.
- User Port signal directions frozen.
- W5500 SPI/control signals frozen.
- Timing/handshake specification written.
- Native KiCad schematic can then be captured with real symbols and nets.

## Status

Architecture decision complete. Part selection, level-translation implementation, native KiCad schematic and ERC remain open.
