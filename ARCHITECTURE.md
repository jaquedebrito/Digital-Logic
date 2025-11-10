# 📐 Repository Architecture and Organization

## Directory Structure

```
Digital-Logic/
│
├── 📄 README.md                          # Main repository documentation
├── 📄 RESUMO.md                          # Comprehensive summary (Portuguese)
├── 📄 CONTRIBUTING.md                    # Contribution guidelines
├── 📄 LICENSE                            # MIT License
├── 📄 .gitignore                         # Git ignore rules
│
├── 📁 Partial Evaluation Part 1/         # I2C Protocol Implementation
│   ├── dec_i2c.sv                       # I2C Decoder module
│   ├── tb_dec_i2c.sv                    # Testbench
│   ├── README.md                         # Detailed documentation
│   └── xrun.log                          # Simulation log
│
├── 📁 Partial Evaluation Part 2/         # Sequential Logic Projects
│   ├── README.md                         # Overview and corrections
│   ├── sinaleira2.sv                     # Advanced traffic controller
│   ├── tb_sinaleira2.sv                  # Testbench
│   │
│   └── 📁 Lesson 8/                      # Individual sequential projects
│       ├── 📁 contador/                  # 5-bit counter
│       │   ├── contador_5b.sv
│       │   ├── contador_5b_tb.sv
│       │   └── README.md
│       │
│       ├── 📁 semaforo/                  # Basic traffic light
│       │   ├── semaforo.sv
│       │   ├── semaforo_tb.sv
│       │   └── README.md
│       │
│       ├── 📁 semaforo_pedestre/         # Pedestrian crossing
│       │   ├── semaforo_pedestre.sv
│       │   ├── semaforo_pedestre_tb.sv
│       │   └── README.md
│       │
│       ├── 📁 detecta_padrao_serial/     # Pattern detector
│       │   ├── detec_padrao_serial.sv
│       │   ├── detec_padrao_serial_tb.sv
│       │   └── README.md
│       │
│       ├── 📁 flip_flop_D/               # D Flip-Flop
│       │   ├── flip_flop_D.sv
│       │   ├── flip_flop_D_tb.sv
│       │   └── README.md
│       │
│       └── 📁 sinaleira/                 # Traffic signal
│           ├── sinaleira.sv
│           ├── sinaleira_tb.sv
│           └── README.md
│
├── 📁 Practical Activity 2/              # Combinational Logic
│   ├── README.md
│   ├── sistema_x.sv                      # Constant comparator
│   ├── sistema_x_tb.sv
│   ├── sistema_x_schematic.pdf
│   ├── sistema_x_waveform.pdf
│   ├── sistema_y.sv                      # Dynamic comparator
│   ├── sistema_y_tb.sv
│   ├── sistema_y_schematic.pdf
│   ├── sistema_y_waveform.pdf
│   │
│   └── 📁 Multiplexer_Design_Challenge/
│       ├── mux8x1.sv
│       ├── mux8x1_tb.sv
│       ├── schematic.pdf
│       ├── waveform.pdf
│       └── README.md
│
├── 📁 Pratical_Activity_3/               # Vote Counter
│   ├── README.md
│   ├── vote_counter.sv                   # Vote counting circuit
│   ├── vote_counter_tb.sv
│   ├── waveform_1.pdf
│   └── waveform_2.pdf
│
├── 📁 Pratical_Activity_4/               # Bus Arbiter
│   ├── README.md
│   ├── arbitro.sv                        # Bus arbitration logic
│   ├── tb.sv                             # Testbench
│   ├── waveform.pdf
│   └── waveform_2.pdf
│
└── 📁 project_final/                     # PT2262/2272 System
    ├── README.md
    ├── Datasheet PT2262-2272-1-1.pdf
    ├── PT2262.pdf
    │
    ├── 📁 codificador/                   # Encoder
    │   ├── codificador_pt2262.sv
    │   ├── codificador_tb.sv
    │   ├── comp_endereco.sv
    │   └── run_sim.sh
    │
    ├── 📁 decodificador/                 # Decoder
    │   ├── decodificador_pt2272.sv
    │   ├── decodificador_tb.sv
    │   ├── comp_endereco.sv
    │   └── run_sim.sh
    │
    └── 📁 reports/                       # Synthesis Reports
        ├── codificador_pt2262_area.rpt
        ├── codificador_pt2262_power.rpt
        ├── codificador_pt2262_gates.rpt
        ├── codificador_pt2262_datapath_map.rpt
        └── codificador_pt2262_datapath_generic.rpt
```

## 🏗️ Project Categories

### 1️⃣ Protocol Implementation
- **I2C Decoder** - Communication protocol with FSM

### 2️⃣ Sequential Logic
- **Traffic Controllers** - Multi-state FSMs with timing
- **Counters** - Synchronous counting circuits
- **Pattern Detectors** - Sequence recognition
- **Flip-Flops** - Basic sequential elements

### 3️⃣ Combinational Logic
- **Comparators** - Equality checking circuits
- **Multiplexers** - Data selection logic

### 4️⃣ System Design
- **Vote Counter** - Bit counting with one-hot encoding
- **Bus Arbiter** - Resource allocation logic
- **RF System** - Complete encoder/decoder with synthesis

## 🔄 Design Flow

```
┌─────────────────────────────────────────────────────────┐
│                    Design Entry                          │
│              (SystemVerilog HDL)                         │
└───────────────────┬─────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────────────┐
│                   Simulation                             │
│              (Cadence Xcelium)                           │
│  • Functional verification                               │
│  • Testbench validation                                  │
│  • Waveform analysis                                     │
└───────────────────┬─────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────────────┐
│                    Synthesis                             │
│               (Cadence Genus)                            │
│  • RTL to gates                                          │
│  • Technology mapping                                    │
│  • Optimization                                          │
└───────────────────┬─────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────────────┐
│                  Analysis & Reports                      │
│  • Area utilization                                      │
│  • Power consumption                                     │
│  • Timing analysis                                       │
│  • Gate count                                            │
└─────────────────────────────────────────────────────────┘
```

## 📊 Technology Overview

### Language Features Used

**SystemVerilog Constructs:**
- `module` / `endmodule` - Module definitions
- `always_ff` - Synchronous sequential logic
- `always_comb` - Combinational logic
- `typedef enum` - State encoding
- `logic` - 4-state data type
- `parameter` - Parameterization

**Design Patterns:**
- Finite State Machines (FSM)
- Counters and timers
- Edge detection
- One-hot encoding
- Priority encoding
- Hierarchical design

## 🎯 Skill Progression

```
Level 1: Fundamentals
├── Flip-Flops
├── Basic FSMs
└── Simple combinational logic

Level 2: Intermediate
├── Counters with parameters
├── Multi-state FSMs
├── Protocol decoders
└── Hierarchical designs

Level 3: Advanced
├── Complete system design
├── Synthesis optimization
├── Timing constraints
└── Power analysis
```

## 📈 Complexity Matrix

| Project | FSM States | I/O Signals | Code Lines | Synthesis |
|---------|-----------|-------------|------------|-----------|
| Flip-Flop D | - | 3 | ~30 | ✓ |
| 5-bit Counter | - | 4 | ~60 | ✓ |
| Traffic Light | 4 | 5 | ~100 | ✓ |
| I2C Decoder | 5 | 10 | ~200 | ✓ |
| Traffic Controller | 7 | 10 | ~250 | ✓ |
| Vote Counter | - | 7 | ~120 | ✓ |
| Bus Arbiter | - | 10 | ~80 | ✓ |
| PT2262 Encoder | Multiple | 15+ | ~300 | ✓ |
| PT2272 Decoder | Multiple | 15+ | ~350 | ✓ |

## 🔧 Tool Integration

### Simulation Environment
```bash
# Xcelium simulation
xrun -sv [module].sv [testbench].sv

# With waveform dump
xrun -sv -gui [module].sv [testbench].sv
```

### Synthesis Flow
```tcl
# Genus synthesis
read_hdl -sv [module].sv
elaborate [top_module]
synthesize -to_mapped
report_area
report_power
report_gates
```

## 📚 Documentation Standards

Each project includes:
- ✅ Module specification
- ✅ Interface description (I/O)
- ✅ Functional description
- ✅ State diagrams (for FSMs)
- ✅ Simulation results
- ✅ Waveform screenshots
- ✅ Implementation notes
- ✅ Usage instructions

## 🎓 Learning Objectives Mapping

### Course Topics → Projects

| Topic | Projects |
|-------|----------|
| Boolean Algebra | All combinational designs |
| Sequential Circuits | Flip-Flops, Counters |
| FSM Design | Traffic lights, I2C, Semaphores |
| Timing Analysis | All sequential projects |
| HDL Coding | All projects |
| Simulation | All projects with testbenches |
| Synthesis | Final project + selected modules |
| Verification | All testbenches |

## 🌟 Best Practices Demonstrated

1. **Code Quality**
   - Meaningful naming conventions
   - Comprehensive comments
   - Proper indentation
   - Module headers

2. **Design Methodology**
   - Hierarchical structure
   - Reusable components
   - Parameterization
   - Synchronous design

3. **Verification**
   - Complete testbenches
   - Edge case testing
   - Waveform documentation
   - Result validation

4. **Documentation**
   - Detailed READMEs
   - State diagrams
   - Interface specifications
   - Usage examples

## 🔍 File Type Reference

| Extension | Purpose | Tools |
|-----------|---------|-------|
| `.sv` | SystemVerilog source | Xcelium, Genus |
| `.log` | Simulation logs | Xcelium output |
| `.pdf` | Documentation/waveforms | Viewers |
| `.rpt` | Synthesis reports | Genus output |
| `.sh` | Shell scripts | Bash |
| `.md` | Documentation | Markdown viewers |

---

**Last Updated:** 2024  
**Maintainer:** Jaqueline Ferreira de Brito  
**Repository:** [github.com/jaquedebrito/Digital-Logic](https://github.com/jaquedebrito/Digital-Logic)
