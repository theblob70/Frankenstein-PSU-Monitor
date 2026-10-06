# Frankenstein PSU Monitor

**RP Console Repairs — live bench PSU voltage, current and power in OBS**

Frankenstein ("Frank") is an inline low-voltage DC monitor built around an **M5Stack AtomS3** and **M5Stack INA226-10A** module. It sits between a bench PSU and the load, sends live readings to a Windows PC over USB, and lets **OBS Studio** record voltage, current and calculated power alongside microscope, overhead-camera and multimeter views.

The project started as a way to avoid trying to keep the bench PSU display inside the camera frame during PS5 fault-finding and voltage-injection work.

## Project status

**Working bench build.** The assembled unit has been continuity-checked and tested with a current-limited **0.50 V** supply and a **10 Ω / 10 W** dummy load.

Typical first-load readings were:

| Instrument | Voltage | Current | Power |
|---|---:|---:|---:|
| OWON at Frank output | ~0.496 V | — | — |
| Bench PSU display | 0.50 V | ~0.042–0.043 A | rounded to 0.0 W |
| Frank / OBS | ~0.492–0.495 V | ~0.047–0.048 A | ~0.023–0.024 W |

This demonstrates useful display resolution at low power; it is **not a claim that Frank is a calibrated laboratory instrument**.

## What Frank does

1. Bench PSU positive passes through the INA226 shunt.
2. AtomS3 reads INA226 bus and shunt voltage over I²C.
3. Firmware sends serial data such as `V: 0.494  A: 0.048  W: 0.024`.
4. PowerShell reads the serial stream and rewrites `RP_PSU_DISPLAY.txt`.
5. OBS Text (GDI+) reads that file and displays the values live.
6. The optional **Resurrection Button** launcher starts the PowerShell monitor and OBS together.

## Electrical path

### Positive

`PSU + → INA226 INPUT + → internal shunt → INA226 OUTPUT + → red output banana socket → load`

### Negative / common

`PSU − + INA226 OUTPUT − + black output banana socket → WAGO 221-413 common`

On the INA226-10A module used for this build, **INPUT − is intentionally unused / NC**.

Read [docs/WIRING.md](docs/WIRING.md) before building or connecting a load.

## Repository layout

```text
firmware/
  RP_INA226_Connection_Test/
    RP_INA226_Connection_Test.ino
  RP_INA226_Live_Monitor/
    RP_INA226_Live_Monitor.ino

windows/
  RP_PSU_LIVE.ps1
  RP_Frankenstein_Launch.cmd

docs/
  START_HERE.txt
  TROUBLESHOOTING_ROB2.txt
  MANIFEST_AND_TEST_SCOPE.txt
  WIRING.md
  PARTS.md

assets/
  Frankenstein_Resurrection.ico
```

## Quick software setup

### 1. Firmware

Use Arduino IDE with M5Stack board support.

For this build:

- Board: **M5AtomS3**
- SDA: **GPIO2**
- SCL: **GPIO1**
- INA226 address: **0x41**
- Serial: **115200 baud**

Run the connection-test sketch first. It should report `INA226 FOUND!`.

Then upload `RP_INA226_Live_Monitor.ino`.

### 2. PowerShell

Copy `windows/RP_PSU_LIVE.ps1` to your Windows user folder and edit:

```powershell
$portName = 'COM10'
```

Change `COM10` to the actual AtomS3 COM port on your PC.

The script writes:

```text
%USERPROFILE%\RP_PSU_DISPLAY.txt
```

### 3. OBS

Add a **Text (GDI+)** source, enable **Read from file**, and point it to:

```text
%USERPROFILE%\RP_PSU_DISPLAY.txt
```

The PowerShell monitor must remain running while OBS uses the live values.

### 4. Resurrection Button

`RP_Frankenstein_Launch.cmd` is the launcher used on Rob's finished setup. It starts the monitor and OBS; **it does not turn on the bench PSU output and it does not start OBS recording**.

The tested launcher currently looks for:

```text
%USERPROFILE%\RP_PSU_ROB2_TEST.ps1
```

The V3 monitor supplied here is named `RP_PSU_LIVE.ps1`. To use the launcher exactly as supplied, either copy/rename the tested V3 script locally to `RP_PSU_ROB2_TEST.ps1`, or edit the launcher's `MONITOR` line to match your local filename.

## Important safety notes

- This project is for **low-voltage DC bench work**, not mains wiring.
- Verify polarity and continuity before first power-up.
- Start with a current-limited, low-voltage resistive load.
- The maker's **10 A module rating is not automatically the rating of the complete assembled wiring path**. The lowest-rated connector, wire, terminal, insulation and thermal condition sets the practical limit.
- Calculated power is `bus voltage × shunt-derived current`; compare readings against a trusted meter before relying on them.
- Do not assume the USB connection is isolated. Treat PC/USB ground as potentially referenced to the wider bench setup unless you have verified otherwise.
- The PSU earth/chassis terminal is not used as the DC negative return in this build.

## Development story

The project was documented as a three-part build on the Electronics Repair Skool community:

- [Project Frankenstein — Part 1](https://www.skool.com/electronicsrepair/project-frankenstein-part-1-building-my-own-bench-psu-live-monitor-for-obs?p=1f8be64f)
- [Project Frankenstein — Part 2](https://www.skool.com/electronicsrepair/frankenstein-part-2-enclosure-construction-skools-10-attachment-limit-strikes-again?p=3157bdbd)
- Part 3 covers final wiring, checks, first live-load test, OBS integration and the Resurrection Button.

## Official hardware references

- [M5Stack AtomS3](https://docs.m5stack.com/en/core/AtomS3)
- [M5Stack INA226-10A](https://docs.m5stack.com/en/unit/Unit_INA226-10A)

Built by **RP Console Repairs**.
