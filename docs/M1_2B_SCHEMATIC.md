# M1.2b — W5500 Schematic Engineering Draft

## Status

**Engineering draft — not ERC-qualified.**

The repository now contains `hardware/kicad/C64Ethernet_M1_2b.sch`, a schematic-level capture of the intended C64Ethernet topology.

## Reference design basis

The W5500 section is to follow WIZnet's official reference schematic. WIZnet documents both external-transformer and RJ45-with-integrated-transformer variants and explicitly calls out the special capacitor requirement when using a connected transformer center tap. The first C64Ethernet PCB should therefore use a WIZnet-compatible MagJack configuration with its exact center-tap arrangement verified before PCB release.

The W5500 provides the Ethernet PHY and hardwired TCP/IP stack and exposes an SPI host interface. The reference design uses the controller's 3.3 V domain and requires the appropriate crystal/clock, decoupling, PHY bias and Ethernet magnetics network.

## C64 side

The proposed User Port interface uses:

- PB0-PB7 for the primary 8-bit transfer path.
- PA2 for a control/handshake function.
- User Port +5 V and ground for board power.

The actual transfer protocol and timing are deliberately not frozen by this document; they belong to M2 after the hardware signal path is reviewed.

## Power

The board starts with the C64 +5 V supply and creates a regulated 3.3 V rail for the W5500 and associated logic. Protection, current limiting and final regulator selection remain part of the PCB review.

## Ethernet

The PHY-side differential pairs must follow the W5500 reference routing and magnetics requirements. RJ45 ESD protection belongs at the external connector boundary.

## Exit criteria for M1.2b

- [x] Engineering schematic topology committed.
- [x] User Port signal groups documented.
- [x] W5500 host interface documented.
- [x] Ethernet physical interface documented.
- [ ] Native modern KiCad symbol-level schematic.
- [ ] ERC clean.
- [ ] Component values frozen.
- [ ] PCB placement/routing started.

No hardware qualification is claimed by this milestone.

## Reference

WIZnet's current W5500 documentation provides the official reference schematics and identifies the recommended RJ45/magnetics configurations.
