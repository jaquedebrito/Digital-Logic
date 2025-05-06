# Final Project: PT2262/2272 Encoder and Decoder

## Overview

This repository contains the final project for the **Digital Logic** course, focusing on the design and implementation of an **encoder and decoder** for the PT2262/2272 chip. The project showcases the application of digital logic design principles, simulation, and synthesis to create a functional encoding and decoding system.

---

## Project Structure

```
project_final/
├── Datasheet PT2262-2272-1-1.pdf         # Datasheet for the PT2262/2272 chip
├── PT2262.pdf                            # Additional datasheet reference
├── codificador/                          # Encoder implementation
│   ├── codificador_pt2262.sv             # Verilog code for PT2262 encoder
│   ├── codificador_tb.sv                 # Testbench for the encoder
│   ├── comp_endereco.sv                  # Address comparator module
│   ├── run_sim.sh                        # Simulation script for encoder
├── decodificador/                        # Decoder implementation
│   ├── decodificador_pt2272.sv           # Verilog code for PT2272 decoder
│   ├── decodificador_tb.sv               # Testbench for the decoder
│   ├── comp_endereco.sv                  # Address comparator module
│   ├── run_sim.sh                        # Simulation script for decoder
├── reports/                              # Reports generated during synthesis
│   ├── codificador_pt2262_area.rpt       # Area utilization report for encoder
│   ├── codificador_pt2262_power.rpt      # Power analysis for encoder
│   ├── codificador_pt2262_gates.rpt      # Gate-level analysis for encoder
│   ├── codificador_pt2262_datapath_map.rpt # Datapath mapping report
│   ├── codificador_pt2262_datapath_generic.rpt # Generic datapath report
```

---

## Key Components

### 1. Encoder (PT2262)
- **`codificador_pt2262.sv`**: Implements the PT2262 encoding logic.
- **`comp_endereco.sv`**: Address comparison to validate inputs.
- **`codificador_tb.sv`**: Testbench for functional verification.
- **Simulation**: Use `run_sim.sh` to execute test scenarios.

### 2. Decoder (PT2272)
- **`decodificador_pt2272.sv`**: Implements the PT2272 decoding logic.
- **`comp_endereco.sv`**: Address comparison to validate inputs.
- **`decodificador_tb.sv`**: Testbench for functional verification.
- **Simulation**: Use `run_sim.sh` to execute test scenarios.

### 3. Reports
Detailed synthesis reports for the encoder, including:
- **Area Utilization**: `codificador_pt2262_area.rpt`
- **Power Analysis**: `codificador_pt2262_power.rpt`
- **Gate-Level Analysis**: `codificador_pt2262_gates.rpt`
- **Datapath Mapping**: `codificador_pt2262_datapath_map.rpt`
- **Generic Datapath**: `codificador_pt2262_datapath_generic.rpt`

### 4. Datasheets
- **Datasheet PT2262-2272-1-1.pdf**: Comprehensive datasheet for the PT2262/2272 chips.
- **PT2262.pdf**: Additional resource for reference.

---

## Getting Started

### Prerequisites
- Familiarity with digital logic and Verilog/SystemVerilog.
- Access to simulation tools like **ModelSim** or **Vivado**.
- Synthesis tools for generating reports.

### How to Use
1. Clone the repository:
   ```bash
   git clone https://github.com/jaquedebrito/Digital-Logic.git
   cd Digital-Logic/project_final
   ```
2. Navigate to the **`codificador/`** or **`decodificador/`** folder for your desired module.
3. Run simulations with the provided `run_sim.sh` scripts:
   ```bash
   ./run_sim.sh
   ```
4. Explore the **`reports/`** directory for synthesis results.

---

## Contributions

Contributions are welcome! If you'd like to improve the implementation, add features, or enhance documentation, feel free to submit a pull request.

---

## Acknowledgments

This project was developed as part of the **Digital Logic** course to provide hands-on experience with digital design and simulation.
