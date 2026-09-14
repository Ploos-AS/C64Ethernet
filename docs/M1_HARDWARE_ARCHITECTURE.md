# M1 Hardware Architecture

## Status

M1 establishes the electrical and mechanical reference architecture. Exact component values and PCB routing remain subject to schematic review and ERC/DRC.

## Reference topology

```text
C64 User Port
     |
     +-- protection / buffering
     |
     +-- controller interface
             |
             +-- W5500
             |     |
             |     +-- SPI
             |     +-- RESET
             |     +-- INT
             |     +-- LINK
             |
             +-- 5 V / 3.3 V power domains

W5500 --> Ethernet magnetics --> RJ45
```

## Electrical principles

- Do not connect the W5500 directly to C64 I/O without a defined level/interface boundary.
- Keep the C64 User Port protected against accidental shorts and external transients.
- Treat 3.3 V as the Ethernet/controller logic domain.
- Provide local decoupling at every digital IC and a dedicated bulk capacitor near the board power entry.
- Provide a hardware reset path for the Ethernet controller.
- Keep the Ethernet analog section physically separated from noisy digital/User Port routing.

## Power architecture

The first PCB is expected to be powered from the C64 expansion connection rather than requiring a separate wall adapter.

Target domains:

- C64-side supply: 5 V
- Ethernet/controller logic: regulated 3.3 V
- Ethernet analog requirements: follow the selected W5500 reference design

The regulator must be sized for the W5500, RJ45 magnetics/LED load, controller logic, and transient margin. Final regulator selection is deferred until the complete W5500 reference circuit and current budget are captured.

## W5500 interface

The W5500 is the first target because it provides an integrated TCP/IP stack and a straightforward host interface. The C64-side controller boundary should expose only the signals needed by the selected transport.

Initial control signals to account for:

- serial clock/data interface
- chip select
- controller reset
- controller interrupt
- optional link/status indication

Exact C64 User Port pin allocation will be frozen in the KiCad schematic after cross-checking against authoritative C64 schematics and the selected bus-transfer strategy.

## Ethernet physical interface

Use a standard Ethernet magnetics/RJ45 solution compatible with the W5500 reference design. The RJ45 should preferably integrate the magnetics to simplify the first PCB and reduce routing risk.

Required signals include:

- TX differential pair
- RX differential pair
- center-tap/bias connections as required by the chosen magnetics
- link/activity LEDs where supported

Keep differential pairs short, matched, and away from the User Port and switching-regulator area.

## Protection

M1 should provide:

- User Port input/output protection appropriate to the selected interface logic
- supply decoupling
- reverse-polarity protection where applicable
- Ethernet ESD protection at the external RJ45 boundary
- controlled reset behavior

Protection components must not compromise the timing of the selected User Port transfer mechanism.

## Mechanical target

- Edge connector mating directly with the C64 User Port
- RJ45 accessible at the rear/side edge of the PCB
- Through-hole connector preferred for the User Port mechanical interface
- Test points for 5 V, 3.3 V, reset, SPI/control signals, and ground
- Mounting holes where enclosure constraints permit

## M1 exit criteria

M1 is complete when the following exist and have been reviewed:

1. Electrical architecture document.
2. W5500 reference schematic.
3. Power/current budget.
4. User Port signal allocation.
5. RJ45/magnetics choice.
6. Protection strategy.
7. KiCad schematic ready for ERC.

PCB routing, DRC, Gerbers, and physical C64 qualification remain subsequent M1 work items.
