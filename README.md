# 💡 Digital Logic – SystemVerilog Projects with Cadence Tools

[![SystemVerilog](https://img.shields.io/badge/Language-SystemVerilog-blue.svg)](https://en.wikipedia.org/wiki/SystemVerilog)
[![Cadence](https://img.shields.io/badge/Tools-Cadence-orange.svg)](https://www.cadence.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Projects](https://img.shields.io/badge/Projects-15+-green.svg)](#-projects-index)
[![Documentation](https://img.shields.io/badge/Docs-Comprehensive-brightgreen.svg)](ARCHITECTURE.md)
[![Code Quality](https://img.shields.io/badge/Quality-Production-success.svg)](CONTRIBUTING.md)

This repository contains comprehensive projects developed for the Digital Logic course, focused on designing and simulating digital circuits using SystemVerilog. The projects demonstrate mastery of digital design fundamentals, finite state machines, combinational and sequential logic, and hardware synthesis.

### 📊 Repository Statistics

- **📁 Total Projects:** 15+ individual designs
- **📝 SystemVerilog Files:** 34 modules and testbenches
- **📄 Documentation Files:** 14 detailed README files
- **💻 Lines of Code:** 895+ lines of SystemVerilog
- **🔧 Tools:** Cadence Xcelium, Cadence Genus
- **📚 Topics:** FSMs, Protocols, Counters, Arbiters, Encoders/Decoders

## 📑 Table of Contents

- [Repository Overview](#-repository-overview)
- [Projects Index](#-projects-index)
- [Technology Stack](#️-technology-stack)
- [Getting Started](#-getting-started)
- [About](#-about)
- [Course Information](#-course-information)
- [License](#-license)

## 🗂️ Repository Overview

This repository is organized into evaluation parts and practical activities, each focusing on different aspects of digital logic design:

| Directory | Type | Description | Key Topics |
|-----------|------|-------------|------------|
| [Partial Evaluation Part 1](#partial-evaluation-part-1) | Evaluation | I2C Protocol Decoder | FSM, Protocol Decoding, I2C |
| [Partial Evaluation Part 2](#partial-evaluation-part-2) | Evaluation | Sequential Logic Projects | FSM, Counters, Traffic Controllers |
| [Practical Activity 2](#practical-activity-2) | Activity | Combinational Logic Design | Comparators, Multiplexers |
| [Pratical_Activity_3](#practical-activity-3) | Activity | Vote Counter | Bit Counting, One-Hot Encoding |
| [Pratical_Activity_4](#practical-activity-4) | Activity | Bus Arbiter | Priority Encoding, Bus Control |
| [project_final](#final-project) | Final Project | PT2262/2272 Encoder/Decoder | Complete System, Synthesis Reports |

## 📚 Projects Index

### Partial Evaluation Part 1

**I2C Protocol Decoder** - A robust I2C decoder implementation featuring:
- Finite State Machine for protocol management
- START and STOP condition detection
- 7-bit address decoding
- Read/Write operation identification
- Synthesizable SystemVerilog implementation

**Files:** `dec_i2c.sv`, `tb_dec_i2c.sv`  
**[📖 Detailed Documentation](./Partial%20Evaluation%20Part%201/README.md)**

---

### Partial Evaluation Part 2

A collection of sequential logic projects demonstrating FSM design patterns:

#### 🚦 Traffic Light Controllers
- **Traffic Light Controller** (`sinaleira2.sv`) - Advanced intersection controller with:
  - Pedestrian crossing support
  - Configurable timing parameters
  - Safety constraints enforcement
  - Two-street intersection management

- **Simple Traffic Light** (`semaforo.sv`) - Basic traffic light FSM with state transitions

#### 📊 Counters and Pattern Detection
- **5-bit Configurable Counter** (`contador_5b.sv`) - Synchronous counter with:
  - Configurable maximum value (0-31)
  - Automatic restart capability
  - End-of-count detection signal

- **Serial Pattern Detector** (`detec_padrao_serial.sv`) - FSM-based pattern recognition

#### 🔧 Fundamental Components
- **D Flip-Flop** (`flip_flop_D.sv`) - Basic sequential element implementation

**[📖 Detailed Documentation](./Partial%20Evaluation%20Part%202/README.md)**

---

### Practical Activity 2

**Combinational Logic Design Challenge** - Hierarchical gate-level implementations:

#### Sistema X - Constant Comparator
- Compares 4-bit input against constant `4'b0101`
- Hierarchical design using standard cells
- Gate-level implementation with:
  - INVX1HVT inverters
  - AND3X1HVT gates
  - OR3X1HVT gates

#### Sistema Y - Dynamic Comparator (Bonus)
- Compares two 4-bit inputs (A == B)
- Configurable comparison value
- Complete with schematics and waveforms

#### 8x1 Multiplexer Design
- 8-to-1 multiplexer implementation
- Full testbench coverage
- Schematic and waveform documentation

**Files:** `sistema_x.sv`, `sistema_y.sv`, `mux8x1.sv`  
**[📖 Detailed Documentation](./Practical%20Activity%202/README.md)**

---

### Practical Activity 3

**Vote Counter** - Digital vote counting circuit featuring:
- 3-bit input vector for vote inputs
- One-hot encoded 4-bit output
- Counts number of active bits (1s) in input
- Hierarchical gate-level design
- Comprehensive testbench with all 8 input combinations

**Output Encoding:**
- `R[0] = 1` → 0 votes
- `R[1] = 1` → 1 vote
- `R[2] = 1` → 2 votes
- `R[3] = 1` → 3 votes

**Files:** `vote_counter.sv`, `vote_counter_tb.sv`  
**[📖 Detailed Documentation](./Pratical_Activity_3/README.md)**

---

### Practical Activity 4

**Bus Arbiter** - Synthesizable bus arbitration system with:
- 4-device bus access management
- Priority-based arbitration policy
- One-hot grant signal output
- Binary-encoded grant number
- Bus availability indicator
- Full synthesis and testbench verification

**Specifications:**
- Inputs: `req[3:0]` (4-bit request signals)
- Outputs: `grant[3:0]`, `available`, `grant_num[1:0]`
- Ensures only one device granted access at a time

**Files:** `arbitro.sv`, `tb.sv`  
**[📖 Detailed Documentation](./Pratical_Activity_4/README.md)**

---

### Final Project

**PT2262/2272 Encoder and Decoder System** - Complete implementation of radio frequency encoder/decoder chips:

#### 🔐 Encoder (PT2262)
- Address encoding (8 bits)
- Data encoding (4 bits)
- Synchronized transmission
- Configurable oscillator frequency

#### 🔓 Decoder (PT2272)
- Address comparison and validation
- Data extraction
- Valid transmission indicator
- Synchronized reception

#### 📊 Synthesis Reports
Complete synthesis analysis including:
- Area utilization (`codificador_pt2262_area.rpt`)
- Power analysis (`codificador_pt2262_power.rpt`)
- Gate-level analysis (`codificador_pt2262_gates.rpt`)
- Datapath mapping and optimization reports

**Files:** Encoder and decoder modules with testbenches, datasheets, simulation scripts  
**[📖 Detailed Documentation](./project_final/README.md)**

---

## ⚙️ Technology Stack

### Hardware Description Language
- **SystemVerilog** - Primary HDL for all designs
  - RTL design methodology
  - Synthesizable constructs
  - Comprehensive testbenches

### Simulation Tools
- **Cadence Xcelium** - Advanced functional and timing simulation
  - Waveform analysis
  - Coverage metrics
  - Protocol checking

### Synthesis Tools
- **Cadence Genus** - Logic synthesis and optimization
  - Area optimization
  - Power analysis
  - Timing closure
  - Technology mapping

### Automation
- **TCL Scripting** - Project automation and flow control
  - Simulation scripts
  - Synthesis flows
  - Report generation

## 🚀 Getting Started

### Prerequisites
```bash
# Required tools
- Cadence Xcelium (for simulation)
- Cadence Genus (for synthesis)
- SystemVerilog-compatible simulator (alternative: ModelSim, VCS)
```

### Running Simulations

Each project includes testbenches that can be executed using Xcelium:

```bash
# Navigate to project directory
cd "Partial Evaluation Part 1"

# Run simulation with Xcelium
xrun -sv dec_i2c.sv tb_dec_i2c.sv

# Or use provided simulation scripts
cd project_final/codificador
./run_sim.sh
```

### Synthesis Flow

For projects with synthesis support:

```bash
cd project_final/reports

# Review synthesis reports
cat codificador_pt2262_area.rpt      # Area utilization
cat codificador_pt2262_power.rpt     # Power analysis
cat codificador_pt2262_gates.rpt     # Gate count
```

## 👩‍💻 About

**Author:** Jaqueline Ferreira de Brito

### Education
- 🎓 Bachelor's Degree in Computer Science
- 🔧 Technician in Computer Maintenance and Support
- 💼 Technologist in Managerial Processes
- 🎓 Postgraduate in Microelectronics

### Focus Areas
- 🤖 Artificial Intelligence
- 💻 Hardware Design
- 🔌 Embedded Systems
- ⚡ Digital Logic and VLSI

## 📖 Course Information

### Instructor: Lucas Teixeira

**Academic Background:**
- Electrical Engineer (UFSM)
- M.Sc. in Computer Science (UFSM/PPGI)
- Ph.D. in Electrical Engineering (UFSM/PPGEE)

**Professional Experience:**
- **Fraunhofer Institute, Berlin** - Energy controller design
- **SMDH** - Coding, DFT, bring-up, and full-stack troubleshooting
- **CPD/UFSM** - Telecommunications Engineering and infrastructure
- **CTISM** - High school technical instructor
- **University of Oviedo** - Ph.D. sandwich program in energy processing for communication systems

### 🎯 Course Objectives

1. Enable students to design and simulate digital systems
2. Develop skills in hardware description at RTL using SystemVerilog
3. Master industrial-grade tools from Cadence
4. Automate design and verification processes with TCL scripting

### 📚 Course Topics

- **Digital Logic Fundamentals** - Number representations, Boolean algebra
- **Combinational Logic** - Design, description, and simulation
- **Sequential Logic** - Flip-flops, FSMs, timing constraints
- **Digital System Design** - SystemVerilog development, simulation with Xcelium, synthesis with Genus

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📖 Additional Documentation

- 📋 **[RESUMO.md](RESUMO.md)** - Comprehensive summary in Portuguese (Resumo completo em Português)
- 📐 **[ARCHITECTURE.md](ARCHITECTURE.md)** - Repository structure and organization guide
- ⚡ **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Quick start commands and code templates
- 🤝 **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines and best practices

## 📧 Contact

Jaqueline Ferreira de Brito
- GitHub: [@jaquedebrito](https://github.com/jaquedebrito)

---

**⭐ If you find this repository helpful, please consider giving it a star!**

### 🔗 Quick Navigation

| Documentation | Description |
|---------------|-------------|
| [Main README](README.md) | Complete project overview and index |
| [Summary (PT)](RESUMO.md) | Resumo completo em Português |
| [Architecture](ARCHITECTURE.md) | Repository structure and design flow |
| [Quick Reference](QUICK_REFERENCE.md) | Commands, templates, and tips |
| [Contributing](CONTRIBUTING.md) | How to contribute to this repository |
| [License](LICENSE) | MIT License details |
