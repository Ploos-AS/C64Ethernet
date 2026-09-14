# M0 Architecture

## Goal

Provide practical Ethernet connectivity to a Commodore 64 through the User Port.

## Reference design

The first implementation uses a W5500 Ethernet controller. The W5500 contains the Ethernet MAC/PHY interface and an integrated TCP/IP stack, allowing the C64 software to remain small and focused on the User Port transport and socket-facing API.

```text
+------------------+
| Commodore 64     |
| 6502             |
+--------+---------+
         |
         | User Port
         v
+------------------+
| C64Ethernet      |
| interface logic  |
+--------+---------+
         |
         | controller interface
         v
+------------------+
| W5500            |
| Ethernet + TCP/IP|
+--------+---------+
         |
         v
      RJ45/LAN
```

## Design principles

1. Keep the C64-facing protocol deterministic and simple.
2. Protect the C64 User Port electrically.
3. Make the Ethernet controller replaceable in later revisions.
4. Keep host-side protocol tests independent of physical hardware where possible.
5. Do not claim runtime or hardware qualification before testing on physical C64 hardware.

## Software layers

```text
C64 application
      |
network/socket API
      |
C64Ethernet driver
      |
User Port transport
      |
C64Ethernet controller
      |
W5500
```

## Future options

The architecture leaves room for an MCU-assisted controller, ENC28J60, or FPGA implementation if later testing shows that the initial W5500 design is limiting performance or compatibility.
