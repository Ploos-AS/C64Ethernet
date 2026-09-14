# M1.2j — Native KiCad schematic status

## Status

The native KiCad schematic remains **not yet complete**. This milestone deliberately records the verified electrical baseline rather than claiming that a generated `.kicad_sch` is electrically valid.

## Verified W5500 baseline

The W5500 reference design requires:

- SPI: SCSn, SCLK, MOSI and MISO.
- 12.4 kΩ, 1% from EXRES1 to analog ground.
- 25 MHz crystal network at XI/CLKIN and XO.
- 3.3 V analog and digital supplies with local decoupling.
- RSTn and INTn brought to the controller interface.

These requirements are taken from the WIZnet W5500 datasheet/reference material.

## C64 interface baseline

The design continues to use the C64 User Port as the host-side parallel interface, with the CPLD providing the deterministic bridge to W5500 SPI.

## Exit criteria

M1.2j is complete only when all of the following exist in the repository:

1. A native `.kicad_sch` that opens in KiCad.
2. Real library symbols for the User Port, CPLD, W5500, regulator, protection and Ethernet connector.
3. Explicit nets for all required signals and power rails.
4. Footprints assigned to every PCB component.
5. ERC performed with all intentional exceptions documented.
6. No placeholder text file is presented as the finished schematic.

Until then the project must not claim schematic qualification or PCB readiness.
