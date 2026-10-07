# Parts and Build Notes

These are the parts used in the completed Frankenstein PSU Monitor build.

## Electronics

- M5Stack AtomS3
- M5Stack INA226-10A module
- 0.005 Ω shunt version
- HY2.0 4-pin connection lead
- USB-C data cable
- USB-C panel-mount extension for the enclosure

A straight-back USB-C panel extension is preferable in this enclosure because the first right-angle version sent the cable in the wrong direction internally.

## Enclosure

- Black ABS/plastic enclosure, approximately 80 mm deep
- Two red/black 4 mm panel banana sockets
- Two M8 × 1.25 cable glands
- Glands used: approximately 2–4 mm cable clamping range
- Small panel screws/nuts for the USB extension
- CANOPUS / Dual-Lock-style mounting strips for the AtomS3 and INA226

## Wiring

- 18 AWG red wire
- 18 AWG black wire
- Red 4 mm banana plug for PSU positive input
- Black 4 mm banana plug for PSU negative input
- 4.8 × 0.5 mm fully insulated female spade connectors
- WAGO 221-413 3-port connector for the negative common
- Heat-shrink tubing as required

## Test equipment used

- Bench DC PSU
- OWON multimeter
- 10 Ω / 10 W aluminium resistor as the first controlled dummy load

## PC / software

- Arduino IDE with M5Stack board support
- Windows PowerShell
- OBS Studio
- Text (GDI+) source reading `RP_PSU_DISPLAY.txt`
- `RP_Frankenstein_Launch.cmd` optional one-click launcher

## Enclosure hole sizes used on this build

- Front cable-gland holes: **8 mm**
- Rear USB-C clearance opening: **13 mm**

Those sizes suit the actual parts used in Rob's build. Measure your own sockets, glands and panel extension before drilling because supplier dimensions can vary.

## Optional finishing touches

- Custom Frankenstein desktop `.ico` icon for the Resurrection Button
- Labels for input/output polarity
- Additional strain relief
- Alternative enclosure or clear-display version

## Practical rating note

Do not treat "INA226 10A" as permission to run the whole finished box at 10 A automatically. The assembled system is limited by its lowest-rated wire, connector, banana socket, terminal, joint, insulation and thermal condition.
