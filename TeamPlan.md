# Dashboard Team Execution Plan
**Software Architecture & File Assignment (Excluding Basic MCAL Drivers)**

---

## Member 1 - Omar Hesham Elsayed
**Role:** Speed & RPM Engineer
**Folders to Create:** `HAL/`, `APP/`, `LIB/`

| DRIVERS & CODE FILES | DESCRIPTION |
| :--- | :--- |
| `HAL/speedo.h`, `HAL/speedo.c` | Wheel speed capture & 32-bit period calculation |
| `HAL/tacho.h`, `HAL/tacho.c` | Engine RPM counting module |

---

## Member 2 - Ahmed Khaled Mohamed
**Role:** Communication Bus & Lamps Engineer
**Folders to Create:** `HAL/`

| DRIVERS & CODE FILES | DESCRIPTION |
| :--- | :--- |
| `HAL/lamps595.h`, `HAL/lamps595.c` | 74HC595 shift register output driver for warning lamps |
| `HAL/bodysw.h`, `HAL/bodysw.c` | 74HC165 shift register input driver for body switches |
| `HAL/lcd_i2c.h`, `HAL/lcd_i2c.c` | PCF8574 I2C LCD driver & UI display pages |

---

## Member 3 - Omar Abdelaziz Elsaid Elaraby
**Role:** Application Logic & Safety Engineer
**Folders to Create:** `HAL/`, `APP/`

| DRIVERS & CODE FILES | DESCRIPTION |
| :--- | :--- |
| `HAL/gauges.h`, `HAL/gauges.c` | Sensor acquisition & signal filtering/damping |
| `HAL/chime.h`, `HAL/chime.c` | Buzzer PWM tone generator via Timer2 |
| `APP/cluster_fsm.h`, `APP/cluster_fsm.c` | Ignition state machine & cranking handler |
| `APP/warnings.h`, `APP/warnings.c` | Warning priority evaluation & latching |
| `APP/odometer.h`, `APP/odometer.c` | Atomic 32-bit distance integration & trip meter |

---

## Member 4 - Abdelrahman Hesham Abdullah
**Role:** Communication, Testing & Hardware Engineer
**Folders to Create:** `APP/`, `Simulation/`, `Docs/`

| DRIVERS & CODE FILES | DESCRIPTION |
| :--- | :--- |
| `APP/console.h`, `APP/console.c` | Serial CLI parser & telemetry frame generator |
| `Simulation/dashboard.sim1` | SimulIDE circuit design file |
| `Docs/test_report.md` | Test execution logs |
| `Docs/timing_derivation.md` | Timing derivation documentation |
| `Docs/state_machine.png` | State machine visual diagram |
