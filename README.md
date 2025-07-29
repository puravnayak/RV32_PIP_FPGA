# Pipelined RISC-V Processor on FPGA

## Overview

This project implements a fully functional **pipelined RISC-V processor** using Verilog and deploys it on a **PYNQ-Z2 FPGA** board. The processor is capable of executing a wide range of RISC-V instructions with improved performance through pipelining.

## Features

- Five-stage pipelined architecture: **Fetch, Decode, Execute, Memory, Writeback**
- Supports **base RISC-V RV32I instruction set**
- Handles **data and control hazards** using forwarding and stalling
- Improved throughput over a single-cycle implementation
- Supports **base RISC-V RV32I instruction set**
- Handles **Interrupts**
- Synthesized and deployed on **PYNQ-Z2 FPGA**
- Simulated and verified using **testbench programs**

## Methodology

1. Designed and verified a functional **single-cycle RISC-V processor** in Verilog.
2. Enhanced performance by **introducing pipelining** across five standard stages.
3. Implemented hazard detection and resolution mechanisms to ensure correctness.
4. Synthesized and deployed the pipelined processor to an FPGA board.

## Results

- Achieved **significant performance improvement** over the single-cycle core.
- Successfully resolved hazards, ensuring **stable and accurate execution**.
- Validated the processor through **simulation and real-time execution** on FPGA.

## Tools and Technologies

- **Verilog HDL**
- **Vivado** (for synthesis and implementation)
- **PYNQ-Z2 FPGA Board**
- **ModelSim / Vivado Simulator** for verification

## Getting Started

```
To run this project on your FPGA board:
1. Clone this repository
2. Open the project in Vivado
3. Run synthesis, implementation, and generate bitstream
4. Upload to your PYNQ-Z2 board

```

## Credits
1. [**Aaditya GB**](https://github.com/AadithyaGB)
2. [**Jenil Malviya**](https://github.com/Jenil9825)
3. [**Jishnu Madhav**](https://github.com/JishnuMadav)
4. [**Purav Nayak**](https://github.com/puravnayak)