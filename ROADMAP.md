# C64Ethernet Roadmap

## M0 — Foundation

- [x] Establish project and repository baseline
- [x] Select W5500 as the initial Ethernet controller target
- [x] Define high-level User Port → controller → Ethernet architecture
- [x] Define hardware/software project boundaries
- [x] Define future protocol milestones

## M1 — Hardware architecture

### M1.1 Architecture baseline

- [x] Define hardware block architecture
- [x] Define 5 V / 3.3 V power domains
- [x] Define protection requirements
- [x] Define Ethernet physical-interface requirements
- [x] Define mechanical requirements
- [x] Add preliminary BOM

### M1.2 Schematic and PCB

#### M1.2a Engineering schematic draft

- [x] Record C64 User Port electrical allocation
- [x] Record 5 V input and 3.3 V controller power boundary
- [x] Record W5500 SPI/control interface boundary
- [x] Record Ethernet PHY/magnetics/RJ45 topology
- [x] Add initial KiCad-compatible engineering schematic draft
- [x] Document hardware-design exit criteria

#### M1.2b Native KiCad schematic

- [ ] Freeze C64 User Port signal allocation
- [ ] W5500 reference schematic with explicit symbols and nets
- [ ] Power regulation and protection schematic
- [ ] RJ45/magnetics selection
- [ ] Native KiCad `.kicad_sch`
- [ ] ERC pass

#### M1.2c PCB

- [ ] KiCad PCB layout
- [ ] DRC pass
- [ ] Manufacturing outputs

## M2 — C64 bus/controller protocol

- [ ] Define command/register protocol
- [ ] Implement controller-side protocol
- [ ] Implement C64-side low-level driver
- [ ] Host-side protocol tests
- [ ] Error and reset handling

## M3 — Ethernet bring-up

- [ ] W5500 initialization
- [ ] Link detection
- [ ] MAC configuration
- [ ] TX/RX packet path
- [ ] C64-visible diagnostics

## M4 — TCP/IP services

- [ ] TCP
- [ ] UDP
- [ ] DHCP
- [ ] DNS
- [ ] Socket API

## M5 — C64 applications

- [ ] HTTP client example
- [ ] Telnet client
- [ ] FTP client
- [ ] IRC client integration/example
- [ ] Network diagnostics tools

## M6 — Advanced compatibility

- [ ] Evaluate GEOS networking support
- [ ] Evaluate alternate Ethernet controllers
- [ ] Optional MCU-assisted design
- [ ] Optional FPGA/controller variant

## Qualification

Final hardware qualification should include real C64 hardware, Ethernet link negotiation, packet TX/RX, TCP and UDP operation, reset/reconnect behavior, and long-running stability.
