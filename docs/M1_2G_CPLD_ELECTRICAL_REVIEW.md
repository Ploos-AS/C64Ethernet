# M1.2g — CPLD electrical review

## Review result

The previous M1.2d choice of LC4032V remains a candidate, but the earlier wording that it could simply be wired directly to the C64 User Port must not be treated as approved PCB guidance.

The LC4032V family is a 3.3 V family and Lattice documents 5 V-tolerant I/O support with a specified limit on the number of 5 V-tolerant I/Os. Therefore the exact package/device configuration and the number and placement of 5 V-tolerant pins must be checked against the manufacturer's package/pin tables before schematic capture.

## Design rule

The first PCB revision will use an explicit electrical-interface boundary between the C64's 5 V User Port and the 3.3 V CPLD domain unless the selected CPLD pin configuration is positively verified to satisfy the required 5 V-tolerance conditions.

This avoids relying on an unverified assumption about individual I/O pins.

## W5500 boundary

The W5500 operates from 3.3 V and its host interface is SPI: SCSn, SCLK, MOSI and MISO. WIZnet's current documentation confirms this interface and provides the recommended reference circuitry. The W5500 reference design also specifies a 12.4 kOhm 1% resistor from EXRES1 to analog ground and a 25 MHz crystal network.

## M1.2g exit criteria

- [x] Electrical-domain risk identified
- [x] Direct 5 V User Port connection removed as an unverified assumption
- [x] 3.3 V CPLD/W5500 domain defined
- [ ] Select verified level/interface implementation
- [ ] Capture native KiCad schematic
- [ ] ERC pass

## Status

M1.2g review PASS. Native schematic remains intentionally blocked until the User Port/CPLD electrical interface is verified.
