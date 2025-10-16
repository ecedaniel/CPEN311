# FPGA Music Player with Embedded PicoBlaze Processor

## 🧩 Project Overview
This project implements a **Simple iPod system** on an FPGA board using Verilog HDL.  
It interfaces with on-board **Flash memory**, a **keyboard**, and **audio output**, and integrates an **embedded PicoBlaze processor** to perform **real-time digital signal processing (DSP)** — specifically, an **averaging filter** that measures signal strength and displays it on LEDs.

The design demonstrates fundamental concepts of **finite state machines (FSMs)**, **hardware–software co-design**, and **peripheral interfacing**, culminating in a small but complete embedded audio system.

---

## 🚀 Features
### 🎧 Audio Playback
- Reads 16-bit (or optionally 8-bit) audio samples from on-board Flash memory.
- Streams data to the DE1-SoC’s **audio D/A converter** at 22 kHz sampling rate.
- Supports **play**, **pause**, **forward**, **backward**, and **reset** controls via the keyboard.

### 🎹 Keyboard Interface
- PS/2 keyboard controls playback:
  - `E` → Play  
  - `D` → Stop  
  - `B` → Reverse playback  
  - `F` → Forward playback  
  - `R` → Restart (bonus feature)

### 🧠 Embedded Processor (PicoBlaze)
- Performs real-time averaging over 256 consecutive samples.
- Displays signal strength using **LED bar visualization**.
- Demonstrates a hybrid hardware/software control architecture.

### 🔁 Clock and Control
- Uses a **frequency divider** (27 MHz → 22 kHz) for sampling rate control.
- Synchronizes asynchronous domains with edge-detection logic.
- Speed adjustment through on-board keys:
  - `KEY0` → Increase playback speed  
  - `KEY1` → Decrease playback speed  
  - `KEY2` → Reset speed to normal

---

## 📂 File Structure
| File | Description |
|------|--------------|
| `simple_ipod_solution.v` | Top-level integration module handling Flash, keyboard, and audio FSMs. |
| `flash_reader.v` | FSM for interfacing with the on-board Flash controller to fetch audio data. |
| `keyboard_control.v` | Handles PS/2 keyboard input and maps scan codes to control commands. |
| `address_control.v` | Generates sequential and bidirectional addresses for Flash reads. |
| `FDC.v` | Frequency divider and edge-detector module for generating the 22 kHz read clock. |
| `myclockdivider.v` | General-purpose clock divider used across modules. |
| `pracPICO.psm` | PicoBlaze assembly program implementing real-time averaging and LED output. |

---

## 🧠 Design Concepts
This project brings together several core hardware design ideas:
- **FSM Design:** Structured control of Flash memory and playback logic.
- **Bus Protocols:** Avalon-MM signaling for Flash read operations.
- **Embedded Processing:** Offloading DSP tasks to PicoBlaze.
- **Clock Domain Crossing:** Synchronizing asynchronous data domains.
- **Digital Filtering:** Implementing averaging as a simple low-pass filter.

---

## ⚙️ Simulation and Testing
- **Quartus Prime** used for synthesis, timing analysis, and SignalTap debugging.
- **ModelSim-Altera** used for FSM and clock-divider simulation.
- Real-time testing performed using:
  - Flash memory loaded with `american_hero_song.hex`
  - Keyboard input via PS/2 interface
  - Audio output via Line-Out jack

---

## 📊 LED Strength Meter
The PicoBlaze interrupt routine computes the **average of 256 absolute sample values** and updates the LED display accordingly:
- LED bar fills **from left to right** based on average magnitude.
- Implements division by 256 through bit shifting (power-of-two optimization).
- Demonstrates embedded DSP principles using integer arithmetic.

---

## 🛠️ Tools and Environment
- **Intel Quartus Prime 21.1 (Lite Edition)**
- **ModelSim-Altera (Simulation)**
- **PicoBlaze Assembler**
- **DE1-SoC FPGA Board**
- **Language:** Verilog HDL and PicoBlaze Assembly

---

## 🧾 References
- UBC CPEN 311 – *Lab 2: Simple iPod (FSMs, Flash Memory and Keyboard)*:contentReference[oaicite:0]{index=0}  
- UBC CPEN 311 – *Lab 3: Add a Strength Meter to the Simple iPod (Embedded PicoBlaze Processor)*:contentReference[oaicite:1]{index=1}

---

## 🏁 Future Improvements
- Add an **AXI-Stream audio interface** for broader FPGA support.  
- Extend PicoBlaze firmware for **peak detection** and **VU-meter smoothing**.  
- Implement a **7-segment or VGA visualizer** for richer signal feedback.

---

## 🧑‍💻 Author
**Daniel Kim**  
Electrical Engineering, University of British Columbia  
Focused on Digital & Embedded Systems, FPGA Design, and Hardware-Software Co-Design.

---

> “From transistors to software — bridging hardware and computation through design.”
