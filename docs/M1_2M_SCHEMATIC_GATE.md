# M1.2m — Native schematic gate

The repository now contains a structural validation gate for `hardware/kicad/C64Ethernet.kicad_sch`.

## Purpose

A KiCad `.kicad_sch` file can be syntactically valid while still containing no real symbols or electrical nets. This gate prevents a placeholder/connectivity-only file from being reported as a completed schematic.

## Required identifiers

The gate checks for the selected LC4032V CPLD, W5500, C64 User Port data/control signals, W5500 SPI/control signals, 3.3 V, and EXRES1.

## Status

**M1.2m — gate added.**

The current schematic remains **not ERC-qualified** and still requires actual KiCad symbol instances, pins, wires/nets, power symbols, footprints, and ERC execution. The gate intentionally fails until those real schematic elements are present.
