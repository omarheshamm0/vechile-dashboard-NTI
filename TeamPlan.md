# Dashboard Team Execution Plan
**Software Architecture & File Assignment (Excluding Basic MCAL Drivers)**

---

## Timeline & Daily Submissions (Sep 14 – Sep 17)

| Date | Phase / Focus | Individual Work & Daily Submissions |
| :--- | :--- | :--- |
| **Sun 14 Sep ✅** | **HAL Drivers & Sensor Acquisition** | • **Omar Hesham:** Implement `speedo.c/.h` and `tacho.c/.h`. Submit initial unit tests for Timer1 ICU & INT0.<br>• **Ahmed Khaled:** Implement `lamps595.c/.h`, `bodysw.c/.h`, and `lcd_i2c.c/.h`. Submit SPI/I2C driver initializations.<br>• **Omar Abdelaziz:** Implement `gauges.c/.h` and `chime.c/.h`. Submit ADC channel scaling & PWM chime tests.<br>• **Abdelrahman Hesham:** Setup `dashboard.sim1` in SimulIDE and implement UART `console.c/.h` baseline. |
| **Mon 15 Sep ✅** | **Application Logic & Safety Modules** | • **Omar Hesham:** Integrate speed/RPM calculations into scheduler tasks.<br>• **Ahmed Khaled:** Implement LCD display page rendering and SPI bus arbitration.<br>• **Omar Abdelaziz:** Implement `cluster_fsm.c/.h`, `warnings.c/.h`, and atomic `odometer.c/.h`.<br>• **Abdelrahman Hesham:** Implement console command parser and telemetry frame generation. |
| **Tue 16 Sep** | **System Integration & Testing** | • **All Members:** Integrate APP and HAL layers into main super-loop scheduler.<br>• **Omar Hesham & Ahmed Khaled:** Validate SPI bus arbitration between 74HC595 and 74HC165.<br>• **Omar Abdelaziz & Abdelrahman Hesham:** Execute safety test cases (Limp-home, over-speed, atomic reads). Submit `test_report.md`. |
| **Wed 17 Sep** | **Final Submission & Demo** | • **All Members:** Final bug fixes and code review (NFR compliance, zero gcc warnings).<br>• **Abdelrahman Hesham:** Complete `timing_derivation.md`, `state_machine.png`, record demo video, and submit final project package. |

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

---

## Full List of Added Drivers & Modules

### MCAL Layer
* `MCAL/dio` (`dio.h`, `dio.c`) — General Purpose Input/Output driver.
* `MCAL/adc` (`adc.h`, `adc.c`) — Analog-to-Digital Converter driver.
* `MCAL/timer` (`timer.h`, `timer.c`) — Timer0 (10ms tick system), Timer1, Timer2 driver.
* `MCAL/icu` (`icu.h`, `icu.c`) — Timer1 Input Capture Unit driver.
* `MCAL/exti` (`exti.h`, `exti.c`) — External Interrupts driver (INT0, INT1).
* `MCAL/usart` (`usart.h`, `usart.c`) — USART communication driver.
* `MCAL/spi` (`spi.h`, `spi.c`) — Hardware SPI driver with acquire/release arbitration.
* `MCAL/i2c` (`i2c.h`, `i2c.c`) — TWI / I2C Master driver.

### HAL Layer
* `HAL/speedo` (`speedo.h`, `speedo.c`) — Wheel speed measurement & overflow extension driver.
* `HAL/tacho` (`tacho.h`, `tacho.c`) — Engine RPM pulse counter driver.
* `HAL/lamps595` (`lamps595.h`, `lamps595.c`) — 74HC595 shift register warning lamp driver.
* `HAL/bodysw` (`bodysw.h`, `bodysw.c`) — 74HC165 shift register body switch reader driver.
* `HAL/lcd_i2c` (`lcd_i2c.h`, `lcd_i2c.c`) — PCF8574 I2C 16x2 LCD display driver.
* `HAL/gauges` (`gauges.h`, `gauges.c`) — Analog sensor acquisition & filtering driver.
* `HAL/chime` (`chime.h`, `chime.c`) — Timer2 Fast PWM chime & buzzer driver.

### APP & LIB Layer
* `APP/cluster_fsm` (`cluster_fsm.h`, `cluster_fsm.c`) — Dashboard ignition state machine.
* `APP/warnings` (`warnings.h`, `warnings.c`) — Warning priority & latching manager.
* `APP/odometer` (`odometer.h`, `odometer.c`) — 32-bit atomic distance & trip meter module.
* `APP/console` (`console.h`, `console.c`) — USART CLI parser & diagnostic telemetry module.
* `LIB/STD_TYPES.h` — Standard type definitions.
* `LIB/BIT_MATH.h` — Bit manipulation macros.
* `LIB/ring_buffer` (`ring_buffer.h`, `ring_buffer.c`) — Ring buffer implementation for serial communication.