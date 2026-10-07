# Wiring

This page documents the wiring actually used for the completed Frankenstein PSU Monitor build.

## INA226 terminal order

On the M5Stack INA226-10A module used in this build, with the orange terminal block in the same orientation as the project photos:

```text
INPUT +   INPUT -   OUTPUT -   OUTPUT +
```

**INPUT − is intentionally left unused / NC in this build.**

## Positive path

```text
Bench PSU +
   │
   ▼
INA226 INPUT +
   │
   ▼
internal 0.005 Ω shunt
   │
   ▼
INA226 OUTPUT +
   │
   ▼
red panel banana socket
   │
   ▼
load / injection lead
```

Do **not** connect the red output socket directly to PSU+ or INA226 INPUT+. That would bypass the shunt and defeat current measurement.

## Negative / common path

Three negative conductors are joined in one WAGO 221-413:

```text
Bench PSU − ─────┐
                 ├── WAGO 221-413 common negative
INA226 OUTPUT − ─┤
                 │
black output ────┘
banana socket
```

The WAGO is required because PSU negative, INA226 OUTPUT− and the external black output socket all need the same common return.

## AtomS3 to INA226

HY2.0 / I²C connection used:

- GND
- 5 V
- SDA = GPIO2
- SCL = GPIO1
- INA226 address = 0x41

The AtomS3 is powered from USB.

## Earth / chassis

The bench PSU's green earth/chassis terminal is **not** used as the DC negative return in this build.

Do not assume USB isolation. The AtomS3 is connected to the PC by USB, so treat USB/PC ground as potentially referenced to the wider bench until you have verified your own equipment.

## Continuity checks performed before first power-up

On Rob's assembled unit:

- PSU negative banana → black output banana: continuity
- INA226 OUTPUT− → black output banana: continuity
- INA226 OUTPUT+ → red output banana: continuity
- PSU positive banana → INA226 INPUT+: continuity
- INPUT−: unused / NC
- measured positive-to-negative resistance before power-up: approximately 883 Ω

The 883 Ω figure is a record of this build at that moment, **not a universal pass/fail specification**.

## First controlled powered test

The first live-load test used:

- bench PSU set to approximately 0.50 V
- 10 Ω / 10 W aluminium resistor across the output
- current limiting enabled

Ideal Ohm's-law expectation at 0.50 V into 10 Ω:

```text
I = V / R = 0.50 / 10 = 0.05 A
P = V × I = 0.50 × 0.05 = 0.025 W
```

Observed:

- OWON output voltage: ~0.496 V
- bench PSU: 0.50 V, ~0.042–0.043 A, power display rounded to 0.0 W
- Frank / OBS: ~0.492–0.495 V, ~0.047–0.048 A, ~0.023–0.024 W

That test proved the assembled measurement path and live OBS chain were functioning. It did **not** constitute precision calibration.

## Before connecting valuable hardware

1. Re-check polarity.
2. Re-check positive-path continuity through the shunt.
3. Re-check the common-negative WAGO.
4. Verify there is no direct positive-to-negative short.
5. Start at low voltage with a conservative current limit.
6. Test into a known resistor.
7. Compare against a trusted meter.
8. Only then move to diagnostic work on a board.
