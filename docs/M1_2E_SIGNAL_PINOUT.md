# M1.2e — Frozen C64 User Port / CPLD signal interface

## Status

**M1.2e — PASS (logical interface frozen).**

This document freezes the external C64 User Port signal allocation for the first hardware revision. It does not yet freeze physical CPLD package pin numbers; those are assigned during native KiCad capture and placement.

## C64 User Port allocation

The C64 User Port exposes PB0–PB7 as an independently programmable 8-bit parallel port. PA2 and FLAG2 provide the two handshake directions needed for a deterministic byte transport. The standard C64 User Port pinout is documented in Commodore documentation. 

| C64 User Port | Signal | C64Ethernet direction | Function |
|---|---|---|---|
| C | PB0 | bidirectional | DATA0 |
| D | PB1 | bidirectional | DATA1 |
| E | PB2 | bidirectional | DATA2 |
| F | PB3 | bidirectional | DATA3 |
| H | PB4 | bidirectional | DATA4 |
| J | PB5 | bidirectional | DATA5 |
| K | PB6 | bidirectional | DATA6 |
| L | PB7 | bidirectional | DATA7 |
| M | PA2 | C64 → CPLD | HOST_STROBE |
| B | FLAG2 | CPLD → C64 | DEVICE_IRQ / READY |
| 3 | RESET | C64 → board | C64 reset input to controller logic |
| 2 | +5V | power | Board input supply |
| 1, 12, A, N | GND | power | Common ground |

Pins 10 and 11 (9 VAC) are **not connected** to C64Ethernet. Pins 4–9 are also intentionally unused in the first revision.

## Handshake model

`PB0..PB7` form a bidirectional byte lane. `PA2` is the host-side strobe and `FLAG2` is the device-side service/ready indication.

The CPLD must never actively drive the PB bus while the C64 is writing a byte. The C64 driver changes the CIA port direction before a read or write transaction, and the CPLD follows the transaction phase.

Recommended logical transaction sequence:

```text
C64                         CPLD
 |                            |
 | put command/data on PB ---→|
 | pulse HOST_STROBE --------→|
 |                            | capture byte
 |                            | perform operation
 |<--------- FLAG2 -----------|
 | read response from PB ←----|
```

The exact edge polarity and minimum pulse widths are implementation details to be frozen with the CPLD HDL and timing verification.

## CPLD ↔ W5500 interface

| CPLD signal | W5500 | Direction | Function |
|---|---|---|---|
| W5500_SCLK | SCLK | CPLD → W5500 | SPI clock |
| W5500_MOSI | MOSI | CPLD → W5500 | SPI transmit |
| W5500_MISO | MISO | W5500 → CPLD | SPI receive |
| W5500_CSN | SCSn | CPLD → W5500 | SPI chip select, active low |
| W5500_INTN | INTn | W5500 → CPLD | Ethernet/socket interrupt, active low |
| W5500_RSTN | RSTn | CPLD → W5500 | Hardware reset, active low |

WIZnet specifies W5500 operation at 3.3 V, with SPI SCLK/MISO/MOSI/SCSn plus active-low INTn and RSTn. RSTn must be held low for at least 500 µs for reset. citeturn2search12turn2search15

## Power

The C64 User Port provides +5 V with a documented 100 mA maximum for pin 2. The board therefore requires a local 3.3 V regulator sized for the W5500 and CPLD load; the design must not assume that the User Port can provide arbitrary peripheral current. citeturn1search12

The W5500 itself can draw approximately 132 mA in normal operation according to its datasheet, so the regulator and power budget must be designed accordingly. citeturn2search12

## Electrical safety rules

- Never connect the 9 VAC User Port pins to the circuit.
- Do not connect 5 V directly to W5500 3.3 V supply pins.
- Keep all W5500 analog/power decoupling and reference components according to the WIZnet reference design.
- Treat FLAG2 as a controller-owned handshake output; the exact open-drain/push-pull implementation is to be validated against CIA electrical characteristics before PCB release.
- Do not claim physical qualification until a prototype has been tested on real C64 hardware.

## Exit criteria

- [x] User Port data lane frozen.
- [x] Host/device handshake signals frozen.
- [x] Reset policy frozen.
- [x] W5500 SPI/control signals frozen.
- [x] Unused and hazardous User Port pins explicitly excluded.
- [ ] Physical CPLD package pin numbers assigned.
- [ ] Native KiCad schematic captured.
- [ ] ERC pass.
