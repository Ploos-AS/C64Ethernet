# C64Ethernet

Ethernet expansion for the Commodore 64 using the User Port.

## Project goal

C64Ethernet is a complete hardware and software project for giving a Commodore 64 practical Ethernet connectivity through the User Port. The project includes the interface PCB, controller firmware, C64-side driver/software, documentation, tests, and reproducible hardware release files.

## M0 architecture baseline

The initial hardware target is a **W5500-based Ethernet controller** connected to a small User Port interface/controller. The W5500 is preferred for the first implementation because it provides an integrated TCP/IP stack while keeping the C64-side software lightweight.

Planned data path:

```text
Commodore 64
    |
    | User Port
    v
C64Ethernet interface/controller
    |
    | SPI / controller bus
    v
W5500 Ethernet controller
    |
    v
RJ45 Ethernet
```

The controller boundary is intentionally kept modular so later revisions can evaluate alternatives such as ENC28J60, an MCU-assisted design, or FPGA-based Ethernet.

## M0 scope

- Define User Port electrical and logical interface.
- Establish the W5500-based reference architecture.
- Define the controller register/command protocol between the C64 and Ethernet hardware.
- Create the KiCad hardware project structure.
- Define the C64 software/driver architecture.
- Establish host-side protocol tests and documentation requirements.
- Define future TCP/IP, UDP, DHCP, DNS, and application-layer milestones.

## Status

**M0 — Foundation: in progress / architecture baseline established.**

No claim of working hardware or C64 runtime qualification is made at M0.

## Manufacturing

For fabrication files, release-package conventions, manufacturer choices, and funding/affiliate disclosure, see [MANUFACTURING.md](MANUFACTURING.md). Released hardware remains vendor-neutral and may be manufactured by any suitable PCB manufacturer. For project-specific PCB ordering options, see [ORDERING.md](ORDERING.md).

## License

Hardware design materials — including schematics, PCB layouts, manufacturing files, and HDL/RTL that describes hardware — are licensed under the **CERN Open Hardware Licence Version 2 - Permissive (CERN-OHL-P-2.0)**. See [LICENSE-HARDWARE](LICENSE-HARDWARE).

Software — including firmware, drivers, host tools, emulators, assemblers, compilers, utilities, and other executable code unless explicitly stated otherwise — is licensed under the **MIT License**. See [LICENSE-SOFTWARE](LICENSE-SOFTWARE).

Files that incorporate third-party material remain subject to their respective licences and notices.
