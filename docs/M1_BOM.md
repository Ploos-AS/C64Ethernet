# M1 Preliminary BOM

This is an architecture-level BOM. Exact manufacturer part numbers are deliberately deferred until the W5500 reference circuit, availability, and PCB constraints are reviewed.

| Area | Part | Status |
|---|---|---|
| Ethernet controller | W5500 | Selected |
| Ethernet connector | RJ45 with integrated magnetics | Target |
| User Port | C64 User Port edge connector / mating connector | Target |
| 3.3 V regulator | Low-noise/high-efficiency regulator sized for W5500 | To select |
| Level/interface protection | Appropriate 5 V/3.3 V interface/buffer parts | To select |
| Ethernet ESD | Low-capacitance Ethernet TVS array | To select |
| Power protection | Fuse/current limiting + reverse-polarity protection as appropriate | To select |
| Decoupling | 100 nF local capacitors | Required |
| Bulk decoupling | 10–100 uF class, final value by load analysis | To select |
| Status | Link/activity LEDs | Optional/target |
| Test | Test points / headers | Required |

## Selection rules

1. Prefer parts with long-term availability and multiple second sources.
2. Prefer through-hole for mechanically stressed connectors.
3. Use the W5500 vendor reference design as the electrical starting point rather than inventing the Ethernet analog section.
4. Do not freeze regulator or protection part numbers until the complete current and voltage budget is known.
5. Keep the first revision easy to hand-assemble and probe.
