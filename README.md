# Project 04 — Vehicle Dashboard

> Part of the **Embedded Systems Projects Book** — see the
> [book README](../README.md) for the shared platform baseline, layer rules and
> common rubric. Everything in this file is *in addition to* those rules.

---

## 1. Project Identity

| Field | Value |
|-------|-------|
| **Project code** | `PRJ-04-DASHBOARD` |
| **Team names** | Omar Hesham Elsayed, Ahmed Khaled Mohamed, Omar Abdelaziz Elsaid Elaraby, Abdelrahman Hesham Abdullah |
| **GitHub repository** | https://github.com/omarheshamm0/vechile-dashboard-NTI.git |
| **Team size** | 4 students |
| **Build window** | Days 11 – 15 (Sep 13 – Sep 17, 2026) |
| **Demo & submission** | Sep 17, 2026 |
| **Dominant skill** | Timer1 input capture, bidirectional shared SPI bus, atomic 32-bit counters |
| **MCU** | ATmega32A @ 8 MHz |
| **Simulator** | SimulIDE 1.x / Proteus |

---

## 2. Description

### In one sentence

**You are building the instrument cluster of a car — the speedometer, the rev
counter, the fuel gauge and the warning lamps.**

### What the circuit looks like

![Vehicle Dashboard Circuit Schematic](Docs/circuit_schematic.jpg)

| Input | Stands for | How it arrives |
|-------|-----------|----------------|
| Pulse source 1 | Wheel-speed sensor | A stream of pulses on `ICP1` |
| Pulse source 2 | Ignition pulses | A stream of pulses on `INT0` |
| Potentiometer 1 | Fuel level | Analog |
| Potentiometer 2 | Coolant temperature | Analog |
| Potentiometer 3 | Battery voltage | Analog |
| Potentiometer 4 | Oil pressure | Analog |

Outputs: an LCD for the numbers, a row of warning lamps driven through a shift
register, and a 74HC165 that reads the body switches back **in** over the same
bus.

### The first thing you have to get right: two pulse inputs, two opposite methods

Both road speed and engine RPM arrive as pulses. You might expect to measure
them the same way. **You must not**, and explaining why is a graded question in
the defence.

**Road speed — measure the *gap between* pulses (the period).**

A car crawling in traffic produces very few pulses per second. If you counted
them over a 250 ms window you might get 1 pulse, or 0, or 2 — your speedometer
would jump between 0, 7 and 14 km/h with nothing in between. Useless.

But the *gap* between two pulses at that speed is long — tens of milliseconds —
and a 16-bit timer can measure it very precisely. So: capture the timer value at
each pulse, subtract, and you have an accurate speed even at walking pace.

**Engine RPM — *count* pulses in a fixed window.**

An idling engine already produces hundreds of pulses per second, and RPM changes
slowly. Counting for 250 ms gives you a big number with plenty of resolution,
and it costs almost nothing. Measuring individual gaps here would be needless
work, and every little variation between cylinders would make the needle jitter.

> **The rule to remember:** *slow signal → measure the period. Fast signal →
> count the pulses.* This comes up in every embedded job you will ever have.

### The second thing: two chips sharing one SPI bus

Two shift registers hang off the **same** three SPI wires, and they work in
opposite directions:

| Chip | Direction | Wire it uses | Strobe |
|------|-----------|--------------|--------|
| 74HC595 | **out** — drives the 8 warning lamps | `MOSI` | `RCLK` latches |
| 74HC165 | **in** — reads the 6 body switches | `MISO` | `SH/LD` samples |

The rule is absolute: **only one chip may be driving the bus at a time.** If the
165 is clocked while the 595 is being latched, the lamps show a pattern built
from half-shifted data, and the switch byte you read back is garbage — with no
error message anywhere.

The dangerous version of this bug is the *interrupted* one: a lamp refresh
starts, a button scan fires in the middle and clocks the bus, and both
transfers are silently wrong. Every transaction is therefore wrapped in an
acquire / release pair, and neither may interrupt the other.

### The third thing: reading a 32-bit counter that an ISR is writing

The odometer must never lose more than **100 m**, ever, including during a power
cut in the middle of a write.

That number is a 32-bit count of metres, and it is written by one context and
read by another. On an 8-bit CPU that is four separate byte reads — and the
odometer task can update the value **in between two of them**. You would read
the low half of the new value and the high half of the old one, and display a
distance the car has never travelled.

The fix is an **atomic read**: disable interrupts for the four bytes, copy, then
restore. It is three lines, and leaving it out produces a bug that appears once
every few thousand updates and is nearly impossible to reproduce on demand.

> **On persistence.** A real cluster keeps the odometer through a power cut, and
> that is a genuinely interesting problem — write throttling, wear levelling and
> atomic slot updates. None of it can be built here, because SimulIDE has no
> non-volatile part. The odometer therefore starts at zero on every power-up.
> Describe in your report what a real implementation would have to add.

### The rest of it

- The **LCD** shows speed, RPM and the four analog readings.
- The **lamp cluster** lights warnings with the correct priority.
- The **serial link** streams the whole dashboard and accepts commands.

---

## 3. Objectives

1. Measure a pulse period with Timer1 Input Capture, including 16-bit overflow
   extension for low speeds.
2. Count pulses on an external interrupt over a fixed window and convert to RPM.
3. Share one SPI bus between two devices with independent chip selects, without
   corrupting either.
4. Drive an 8-lamp cluster through a 74HC595 shift register.
5. Implement a bulb-check sequence and a lamp priority scheme.
6. Read 32-bit counters shared with an ISR atomically, and prove the tearing bug exists without it.
7. Model an ignition key as a state machine with a cranking phase and a
   limp-home fault path.

---

## 4. Learning Outcomes

| ID | Outcome |
|----|---------|
| LO-1 | Configure Timer1 Input Capture (`ICES1`, `ICNC1`, `ICR1`) and read `ICR1` inside `ISR(TIMER1_CAPT_vect)` |
| LO-2 | Extend a 16-bit capture to 32 bits using an overflow counter, and explain the race between `TOV1` and a capture |
| LO-3 | Choose between period measurement and frequency counting from the signal's frequency range |
| LO-4 | Sequence two SPI slaves safely: deassert one CS before asserting the other, and restore SPI mode if they differ |
| LO-5 | Shift 8 bits out to a 74HC595 over hardware SPI and latch them with a GPIO strobe |
| LO-6 | Read a 32-bit counter shared with an ISR atomically, and show the tearing bug that appears without it |
| LO-7 | Detect a stalled pulse train (zero speed) with a timeout rather than waiting forever |

---

## 5. Estimated Duration

| Phase | Hours | Course day |
|-------|:-----:|-----------|
| Requirements analysis & pin freeze | 3 | Day 11 |
| Architecture, FSM, lamp-priority design | 4 | Day 11 |
| Analog channels, 595 cluster, LCD | 6 | Day 12 |
| Input capture + RPM counting + tick | 8 | Day 13 |
| Odometer, 74HC595 policy, UART | 6 | Day 14 |
| Testing & debugging | 5 | Day 15 |
| Documentation, report, video | 4 | Day 15 + evening |
| **Total** | **36 h** | |

---

## 6. Hardware Components

| # | Component | Qty | SimulIDE part | Purpose |
|---|-----------|:---:|---------------|---------|
| 1 | ATmega32A | 1 | `atmega32` | Controller |
| 2 | Potentiometer 10 kΩ | 4 | `Potentiometer` | Fuel, coolant, battery, oil pressure |
| 3 | Variable clock / function generator | 1 | `Clock` | Wheel-speed pulses (0.5 – 500 Hz) |
| 4 | Variable clock / function generator | 1 | `Clock` | Ignition tach pulses (0 – 300 Hz) |
| 5 | 74HC595 shift register | 1 | `Shift Reg.` | 8 warning lamps |
| 6 | LED + 330 Ω | 8 | `Led` | Warning-lamp cluster |
| 7 | Switch (SPST) | 6 | `Switch` | Turn L/R, high beam, handbrake, seatbelt, door |
| 8 | Push button | 3 | `Push` | Ignition key, Start, Display-cycle |
| 9 | Buzzer | 1 | `Buzzer` | Over-speed / critical chime |
| 10 | 16×2 LCD + PCF8574 | 1 | `Lcd` + `I2CToParallel` | Main display |
| 11 | 74HC165 shift register | 1 | `74HC165` | The 6 body switches, read **in** over SPI |
| 12 | Serial terminal | 1 | `SerialPort` | Diagnostics port |

---

## 7. Pin Map

| Signal | Pin | Port bit | Direction | Notes |
|--------|-----|----------|-----------|-------|
| Fuel level | 40 | `PA0` / ADC0 | Analog in | 0 – 1023 → 0 – 100 % |
| Coolant temperature | 39 | `PA1` / ADC1 | Analog in | 0 – 1023 → 40 – 130 °C |
| Battery voltage | 38 | `PA2` / ADC2 | Analog in | 0 – 1023 → 0.0 – 16.0 V |
| Oil pressure | 37 | `PA3` / ADC3 | Analog in | 0 – 1023 → 0.0 – 10.0 bar |
| Turn-left switch | 1 | `PB0` | In, pull-up | Active low |
| Turn-right switch | 2 | `PB1` | In, pull-up | Active low |
| High-beam switch | 3 | `PB2` | In, pull-up | Active low |
| Trip-reset button | 4 | `PB3` | In, pull-up | Hold 2 s to reset trip |
| 74HC165 `SH/LD` | 5 | `PB4` | Out | Low samples the switches, high shifts |
| SPI `MOSI` | 6 | `PB5` | Out | → 74HC595 `DS` |
| SPI `MISO` | 7 | `PB6` | In | ← 74HC165 `Q7` |
| SPI `SCK` | 8 | `PB7` | Out | Shared |
| I2C `SCL` | 22 | `PC0` | Out | 4.7 kΩ pull-up |
| I2C `SDA` | 23 | `PC1` | Bidir | 4.7 kΩ pull-up |
| 74HC595 `RCLK` (latch) | 24 | `PC2` | Out | Rising edge latches |
| Handbrake switch | 25 | `PC3` | In, pull-up | Active low = engaged |
| Seatbelt switch | 26 | `PC4` | In, pull-up | Active low = unbuckled |
| Door switch | 27 | `PC5` | In, pull-up | Active low = open |
| CPU-load test pin | 28 | `PC6` | Out | Timing measurement |
| LCD backlight | 29 | `PC7` | Out | Bonus dimming |
| USART `RXD` | 14 | `PD0` | In | 9600 8N1 |
| USART `TXD` | 15 | `PD1` | Out | 9600 8N1 |
| Tach pulse input | 16 | `PD2` / INT0 | In | Rising edge, counted |
| Ignition key | 17 | `PD3` / INT1 | In, pull-up | Falling edge |
| Start button | 18 | `PD4` | In, pull-up | Polled |
| Display-cycle button | 19 | `PD5` | In, pull-up | Polled |
| Wheel-speed pulse | 20 | `PD6` / `ICP1` | In | **Timer1 Input Capture** |
| Buzzer | 21 | `PD7` / OC2 | Out | Chime tones |

> `PC2` – `PC5` carry the 595 latch and three body switches: **clear the
> `JTAGEN` fuse** or the lamp cluster will never latch.

### 74HC595 lamp map

| Q output | Lamp | Colour | Priority |
|:--------:|------|--------|:--------:|
| `Q0` | Low fuel | Amber | 5 |
| `Q1` | Oil pressure | Red | 1 |
| `Q2` | Battery / charging | Red | 2 |
| `Q3` | Coolant temperature | Red | 3 |
| `Q4` | Check engine | Amber | 4 |
| `Q5` | Left turn | Green | — |
| `Q6` | Right turn | Green | — |
| `Q7` | High beam | Blue | — |

---

## 8. Peripherals Used

| Peripheral | Configuration | Role |
|------------|---------------|------|
| **GPIO** | Switches in + pull-up; `PC2`, `PC6`, `PC7` out | Body inputs, latch, test pins |
| **ADC** | Single conversion, prescaler 64, AVCC ref | 4 sensor channels |
| **Timer0** | CTC, prescaler 1024, `OCR0 = 77` | 10 ms system tick |
| **Timer1** | Normal mode, prescaler 64, `ICIE1` + `TOIE1`, noise canceller on, rising edge | Wheel-speed period capture |
| **Timer2** | Fast PWM, OC2 | Buzzer / chime tones |
| **INT0** | Rising edge | Tach pulse counting |
| **INT1** | Falling edge | Ignition key |
| **USART** | 9600 8N1, RX interrupt | Diagnostics port |
| **SPI** | Master, Mode 0, f/16 | 74HC165 in (`PB4`) **and** 74HC595 out (`PC2` latch) |
| **I2C (TWI)** | Master, 100 kHz | PCF8574 → LCD |

### Speed maths — derive this in your report