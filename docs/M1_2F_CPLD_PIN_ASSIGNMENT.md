# M1.2f — CPLD pin assignment

## Reference device

Lattice LC4032V-5TN48C, 48-pin TQFP, 32 macrocells / 32 I/O. The device is a 3.3 V part; the ispMACH 4000V family supports 5 V-tolerant inputs when configured for 3.3 V operation. The exact package pin numbers must be verified against the final vendor package data before PCB capture.

## Logical assignment

| CPLD function | External signal | Direction | Domain |
|---|---|---:|---|
| D0..D7 | C64 PB0..PB7 | bidirectional | C64 User Port |
| HOST_STROBE | C64 PA2 | input | C64 User Port |
| DEVICE_IRQ | C64 FLAG2 | output | C64 User Port |
| CPLD_RESET | C64 reset / local reset supervisor | input | reset |
| W5500_SCLK | W5500 SCLK | output | 3.3 V |
| W5500_MOSI | W5500 MOSI | output | 3.3 V |
| W5500_MISO | W5500 MISO | input | 3.3 V |
| W5500_SCSN | W5500 SCSn | output | 3.3 V |
| W5500_INTN | W5500 INTn | input | 3.3 V |
| W5500_RSTN | W5500 RSTn | output | 3.3 V |

## Design rule

Do not connect the C64 User Port directly to W5500 pins. The CPLD is the voltage/timing boundary. User Port input/output behavior must be explicitly controlled to avoid bus contention.

## Pin-number status

This document freezes the **logical assignment**, not the final physical package pin numbers. Physical pin numbers will be assigned only after the exact LC4032V-5TN48C package symbol/footprint and power/JTAG requirements have been imported into KiCad.

## Exit criteria

- Logical signals frozen: PASS
- CPLD device frozen: PASS
- Voltage-domain strategy documented: PASS
- Physical package pin numbers: PENDING KiCad capture
- ERC: PENDING
- PCB: PENDING
