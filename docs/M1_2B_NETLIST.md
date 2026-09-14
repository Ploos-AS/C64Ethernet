# M1.2b — Electrical Netlist Baseline

This document freezes the logical nets for the first C64Ethernet hardware revision. It is the source-of-truth for the native KiCad schematic implementation.

## C64 User Port

The first revision uses the User Port as a parallel host interface:

| User Port signal | Direction at C64 | Project net |
|---|---|---|
| PB0–PB7 | bidirectional | C64_D0–C64_D7 |
| PA2 | output/control | C64_CTRL |
| +5V | power | +5V_IN |
| GND | power | GND |

The exact bus transaction protocol remains a software/firmware concern and is not implied by the electrical allocation.

## Controller boundary

The controller boundary exposes:

- C64_D0–C64_D7
- C64_CTRL
- W5500_SCSn
- W5500_SCLK
- W5500_MOSI
- W5500_MISO
- W5500_RSTn
- W5500_INTn
- +3V3
- GND

A controller/bridge device is required between the C64 parallel User Port and the W5500 SPI host interface. The bridge implementation is intentionally not frozen at M1.2b; it will be selected before PCB layout.

## W5500 core nets

The W5500 implementation shall include the vendor-required support circuitry:

- +3V3 digital and analog supplies
- AGND/DGND according to the reference design
- EXRES1 → 12.4 kΩ, 1% → AGND
- 25 MHz crystal network
- RESETn
- INTn
- SPI: SCSn, SCLK, MOSI, MISO
- MDI differential pairs to Ethernet magnetics
- required local decoupling

WIZnet's current reference documentation must be followed for the PHY/magnetics section. In particular, the connected-center-tap MagJack variant has additional requirements and is not interchangeable with the simpler reference circuit.

## Power

```text
C64 +5V
  |
  +-- input protection
  |
  +-- 3.3V regulator
        |
        +-- W5500 VDD / AVDD
        +-- controller/bridge logic as required
```

The final regulator and protection parts are not frozen until the bridge device and current budget are selected.

## PCB constraints

- Keep the W5500 and magnetics close together.
- Keep MDI differential pairs short and matched according to WIZnet's layout guidance.
- Keep crystal traces short and isolated from noisy signals.
- Place W5500 decoupling at the device pins.
- Keep the Ethernet connector at the board edge.
- Keep the C64 User Port and its 5 V input away from the Ethernet analog section.

## Exit criteria

M1.2b can only be marked complete when:

1. All electrical nets are represented by real KiCad symbols.
2. The bridge device is selected.
3. The W5500 support circuit matches the current reference design.
4. ERC runs cleanly or every intentional ERC exception is documented.
5. The resulting `.kicad_sch` opens successfully in the target KiCad release.
