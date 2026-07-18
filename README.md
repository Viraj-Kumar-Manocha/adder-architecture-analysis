# ⚡ Adder Architecture Analysis — RCA vs CLA (4-bit, 16-bit, 64-bit)

A comparative study of **Ripple Carry Adder (RCA)** and **Carry Lookahead Adder (CLA)** architectures in **Verilog**, evaluated at three bit-widths — **4-bit, 16-bit, and 64-bit** — to quantify how carry-propagation delay scales with adder width and architecture choice.

![Verilog](https://img.shields.io/badge/HDL-Verilog-blue)
![Vivado](https://img.shields.io/badge/Tool-Xilinx%20Vivado-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

---

## 📖 Overview

This project implements and compares two classic binary adder architectures — the **Ripple Carry Adder** (simple, carry ripples sequentially through each full adder) and the **Carry Lookahead Adder** (pre-computes carries in parallel using generate/propagate logic to cut critical-path delay).

Both architectures were built from a common `full_adder.v` building block, scaled up to 4-bit, 16-bit, and 64-bit widths, individually verified with dedicated testbenches, and synthesized to extract **critical path delay** at each width. The goal is to visualize, with real synthesis data, how RCA delay grows roughly linearly with bit-width while CLA delay grows much more slowly — the classic area-vs-speed tradeoff in digital design.

This project was built to strengthen understanding of combinational timing analysis, carry-propagation vs. carry-lookahead logic, and how architectural choices affect maximum achievable frequency.

---

## ✨ Features

- 🔧 **Two Adder Architectures** — Ripple Carry Adder and Carry Lookahead Adder, both built from a shared `full_adder` primitive
- 📏 **Three Bit-Widths** — 4-bit, 16-bit, and 64-bit versions of each architecture (6 adders total)
- 🧪 **Fully Verified** — dedicated testbenches for every width, with self-checking testbenches at 4-bit and 64-bit
- 📊 **Critical Path Delay Analysis** — synthesis-based timing reports comparing RCA vs CLA at each width
- 📈 **Scaling Comparison** — direct visualization of how delay scales with bit-width for each architecture
- 🌊 **Waveform Verification** — simulation waveform capture for the 64-bit adders

---

## 🏗️ Architecture

**Ripple Carry Adder (RCA)** — carry-out of each full adder feeds directly into the carry-in of the next, so the worst-case delay grows linearly with bit-width:

```
a0  b0         a1  b1         a2  b2          a3  b3
 │  │           │  │           │  │            │  │
 ▼  ▼           ▼  ▼           ▼  ▼            ▼  ▼
┌────┐ cout    ┌────┐  cout   ┌────┐  cout    ┌────┐
│ FA │──────▶▶│ FA │──────▶▶│ FA │──────▶▶ │ FA │──▶ cout
└────┘         └────┘         └────┘          └────┘
  │              │              │                │
  ▼              ▼              ▼                ▼
 sum0           sum1           sum2             sum3
```

**Carry Lookahead Adder (CLA)** — generate (G) and propagate (P) signals are computed for every bit in parallel, and a lookahead logic block computes every carry directly from the inputs, breaking the ripple dependency:

```
       a0 b0    a1 b1    a2 b2    a3 b3
        │ │      │ │      │ │      │ │
        ▼ ▼      ▼ ▼      ▼ ▼      ▼ ▼
        G/P      G/P      G/P      G/P
         │        │        │        │
         └────────┴───┬────┴────────┘
                      ▼
             Carry Lookahead Logic
       (computes c1, c2, c3, c4 directly)
                      │
       ┌──────┬───────┼───────┬──────┐
       ▼      ▼       ▼       ▼      ▼
      sum0   sum1    sum2    sum3   cout
```

> Wider adders (16-bit, 64-bit) are built hierarchically from these same principles — either full ripple chains or block/hierarchical carry lookahead — which is exactly what makes the delay-scaling comparison meaningful.

The elaborated (post-synthesis RTL) schematic for each of the six adders — showing the actual gate-level structure Vivado generates — is available in [`results/schematics/`](results/schematics).

---

## 📂 Repository Structure

```
adder-architecture-analysis/
│
├── src/                                # Design source files
│   ├── full_adder.v                    # Single-bit full adder (shared building block)
│   ├── rca_4bit.v                      # 4-bit Ripple Carry Adder
│   ├── rca_16bit.v                     # 16-bit Ripple Carry Adder
│   ├── rca_64bit.v                     # 64-bit Ripple Carry Adder
│   ├── cla_4bit.v                      # 4-bit Carry Lookahead Adder
│   ├── cla_16bit.v                     # 16-bit Carry Lookahead Adder
│   └── cla_64bit.v                     # 64-bit Carry Lookahead Adder
│
├── tb/                                  # Verification files
│   ├── tb_adder.v                       # Testbench for the base full_adder
│   ├── tb_4bit_adders.v                 # RCA vs CLA, 4-bit — self checking
│   ├── tb_16bit_adders.v                # RCA vs CLA, 16-bit
│   └── tb_64bit_adders.v                # RCA vs CLA, 64-bit — self checking
│
├── results/
│   ├── delay_analysis/                  # Critical path delay screenshots (6 total)
│   │   ├── rca_4bit_delay.png
│   │   ├── cla_4bit_delay.png
│   │   ├── rca_16bit_delay.png
│   │   ├── cla_16bit_delay.png
│   │   ├── rca_64bit_delay.png
│   │   └── cla_64bit_delay.png
│   │
│   ├── schematics/                      # Elaborated RTL schematics (6 total)
│   │   ├── rca_4bit_schematic.png
│   │   ├── cla_4bit_schematic.png
│   │   ├── rca_16bit_schematic.png
│   │   ├── cla_16bit_schematic.png
│   │   ├── rca_64bit_schematic.png
│   │   └── cla_64bit_schematic.png
│   │
│   └── waveforms/                       # Simulation waveform captures
│       └── 64bit_adders_waveform.png
│
└── README.md
```

---

## 🧪 Testing & Verification

Each adder width was verified against its own testbench before comparison:

| Module         | Testbench               | Status    |
| -------------- | ----------------------- | --------- |
| `full_adder`   | `tb_adder.v`            | ✅ Passed |
| 4-bit RCA/CLA  | `tb_4bit_adders.v`      | ✅ Passed |
| 16-bit RCA/CLA | `tb_16bit_adders.v`     | ✅ Passed |
| 64-bit RCA/CLA | `tb_64bit_adders.v`     | ✅ Passed |

---

## 📊 Timing Analysis Results

Critical path delay and logic levels (LUT levels) were both extracted from the post-synthesis timing reports for each adder. Screenshots for all six runs are available in [`results/delay_analysis/`](results/delay_analysis).

| Bit-Width |  RCA Delay  | RCA Logic Levels |  CLA Delay  | CLA Logic Levels | Speedup (RCA / CLA) |
| :-------: | :---------: | :--------------: | :---------: | :--------------: | :-----------------: |
| 4-bit     |  `5.848 ns` |        `4`       | `5.848 ns`  |        `4`       |       `1.00×`       |
| 16-bit    |  `9.354 ns` |       `10`       | `7.895 ns`  |        `6`       |       `1.18×`       |
| 64-bit    | `23.346 ns` |       `34`       | `10.199 ns` |        `8`       |       `2.29×`       |


### 📈 Observations

- **RCA delay** does not scale strictly linearly with bit-width. The observed trend (`5.848 ns` → `9.354 ns` → `23.346 ns` for 4-bit → 16-bit → 64-bit) shows a smaller jump from 4-bit to 16-bit and a much larger jump from 16-bit to 64-bit, rather than a uniform per-bit increase.
- **CLA delay** grows much more gradually across the same widths (`5.848 ns` → `7.895 ns` → `10.199 ns`), staying comparatively flat even as bit-width increases significantly.
- Ideally, RCA delay should scale **linearly** with bit-width, since each additional bit adds one more full-adder stage to the carry chain. The non-linear trend observed here is a synthesis-level effect: at smaller widths, a larger share of the critical path comes from fixed overheads — I/O buffer delay, routing/interconnect delay, and placement on the FPGA fabric — rather than pure logic delay through the carry chain. As the adder grows wider, the carry-ripple logic delay increasingly dominates the path, so the growth rate climbs closer to linear at larger widths. This is also influenced by how Xilinx Vivado's synthesis and place-and-route engine maps and packs the logic onto the target device.
- **LUT levels** follow a similar pattern to delay for the same underlying reason — RCA's level count rises more sharply at higher widths, while CLA's parallel carry structure keeps it comparatively flat.
- The crossover in practicality (CLA's extra gate/area cost being worth it) becomes most visible at 64-bit, where RCA's ripple delay dominates the critical path.

> All synthesis and timing analysis was performed in **Xilinx Vivado**, targeting the **Artix-7 (xc7a) FPGA**, package **fgg236**.
---

## 🌊 Waveform Verification

Simulation waveforms for the 64-bit RCA and CLA testbench are available in [`results/waveforms/`](results/waveforms), confirming functional correctness (sum and carry-out) alongside the timing results above.

---

## 🚀 Getting Started

### Prerequisites

- [Xilinx Vivado](https://www.xilinx.com/support/download.html) (Design Suite)

### Running Simulations

1. Clone the repository:

```
git clone https://github.com/Viraj-Kumar-Manocha/adder-architecture-analysis.git
cd adder-architecture-analysis
```

2. Open Vivado and create a new project, adding all files from `src/` as design sources.
3. Add the desired testbench from `tb/` as a simulation source.
4. Run **Behavioral Simulation** to view waveforms in the Vivado waveform viewer.

### Running Synthesis / Timing Analysis

1. With all `src/` files added as design sources, set the top module to the adder you want to analyze (e.g. `rca_64bit` or `cla_64bit`).
2. Run **Synthesis** in Vivado.
3. Open the **Timing Summary** report to view the critical path delay for that adder.
4. Repeat for each of the six adders to reproduce the comparison table above.

---

## 🔮 Future Improvements

- Extend the comparison with a third architecture (e.g. **Carry Select Adder** or **Kogge-Stone Adder**) for a broader tradeoff study

---

## 📜 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

## 🙋 Author

**Viraj Kumar Manocha**

Undergraduate at Indian Institute of Technology Ropar

Feel free to connect or reach out for questions/collaboration! [LinkedIn](https://www.linkedin.com/in/viraj-kumar-818aa0321/)
