# ⚡ Quick Reference Guide - Digital Logic Projects

## 🚀 Quick Start Commands

### Simulation (Cadence Xcelium)

```bash
# Basic simulation
xrun -sv module.sv testbench.sv

# With GUI and waveform viewer
xrun -sv -gui module.sv testbench.sv

# With coverage
xrun -sv -coverage all module.sv testbench.sv

# Access waveform database
xrun -sv -access +rwc module.sv testbench.sv
```

### Alternative Simulators

```bash
# ModelSim
vlog -sv module.sv testbench.sv
vsim -do "run -all" work.testbench_name

# VCS
vcs -sverilog module.sv testbench.sv
./simv

# Icarus Verilog (open-source, limited SV support)
iverilog -g2012 -o sim module.sv testbench.sv
./sim
```

### Synthesis (Cadence Genus)

```bash
# Launch Genus
genus

# Or with script
genus -f synthesis_script.tcl
```

## 📋 Project Quick Access

### Run Simulations by Project

```bash
# I2C Decoder
cd "Partial Evaluation Part 1"
xrun -sv dec_i2c.sv tb_dec_i2c.sv

# Traffic Light Controller
cd "Partial Evaluation Part 2"
xrun -sv sinaleira2.sv tb_sinaleira2.sv

# 5-bit Counter
cd "Partial Evaluation Part 2/Lesson 8/contador"
xrun -sv contador_5b.sv contador_5b_tb.sv

# Vote Counter
cd Pratical_Activity_3
xrun -sv vote_counter.sv vote_counter_tb.sv

# Bus Arbiter
cd Pratical_Activity_4
xrun -sv arbitro.sv tb.sv

# PT2262 Encoder
cd project_final/codificador
./run_sim.sh

# PT2272 Decoder
cd project_final/decodificador
./run_sim.sh
```

## 🎯 Common SystemVerilog Patterns

### Basic Module Template

```systemverilog
module module_name #(
    parameter WIDTH = 8
)(
    input  logic clk,
    input  logic reset,
    input  logic [WIDTH-1:0] data_in,
    output logic [WIDTH-1:0] data_out,
    output logic valid
);

    // Internal signals
    logic [WIDTH-1:0] reg_data;
    
    // Sequential logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_data <= '0;
        end else begin
            reg_data <= data_in;
        end
    end
    
    // Combinational logic
    always_comb begin
        data_out = reg_data;
        valid = (reg_data != '0);
    end

endmodule
```

### FSM Template

```systemverilog
module fsm_example (
    input  logic clk,
    input  logic reset,
    input  logic start,
    output logic done
);

    // State definition
    typedef enum logic [1:0] {
        IDLE   = 2'b00,
        ACTIVE = 2'b01,
        DONE   = 2'b10
    } state_t;
    
    state_t current_state, next_state;
    
    // State register
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end
    
    // Next state logic
    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE:   if (start) next_state = ACTIVE;
            ACTIVE: next_state = DONE;
            DONE:   next_state = IDLE;
        endcase
    end
    
    // Output logic
    assign done = (current_state == DONE);

endmodule
```

### Counter Template

```systemverilog
module counter #(
    parameter WIDTH = 8,
    parameter MAX_VALUE = 255
)(
    input  logic clk,
    input  logic reset,
    input  logic enable,
    output logic [WIDTH-1:0] count,
    output logic overflow
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= '0;
        end else if (enable) begin
            if (count == MAX_VALUE)
                count <= '0;
            else
                count <= count + 1'b1;
        end
    end
    
    assign overflow = (count == MAX_VALUE) && enable;

endmodule
```

### Testbench Template

```systemverilog
module testbench;

    // Clock and reset
    logic clk = 0;
    logic reset;
    
    // DUT signals
    logic [3:0] input_signal;
    logic output_signal;
    
    // Clock generation (10ns period)
    always #5 clk = ~clk;
    
    // DUT instantiation
    module_name dut (
        .clk(clk),
        .reset(reset),
        .input_signal(input_signal),
        .output_signal(output_signal)
    );
    
    // Test sequence
    initial begin
        // Initialize
        reset = 1;
        input_signal = 0;
        
        // Release reset
        @(posedge clk);
        reset = 0;
        
        // Test cases
        repeat(10) begin
            @(posedge clk);
            input_signal = $random;
        end
        
        // Finish simulation
        #100;
        $display("Test completed");
        $finish;
    end
    
    // Waveform dump
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, testbench);
    end

endmodule
```

## 🔧 Debugging Tips

### Display Statements

```systemverilog
// Simple display
$display("Value = %d", signal);

// Time-stamped display
$display("Time=%0t: Value=%b", $time, signal);

// Formatted output
$display("Hex=%h, Decimal=%d, Binary=%b", val, val, val);

// Monitor (prints on change)
$monitor("Time=%0t: clk=%b, data=%h", $time, clk, data);
```

### Assertions

```systemverilog
// Immediate assertion
assert (condition) else $error("Error message");

// Property assertion
property p_valid_range;
    @(posedge clk) (value >= MIN) && (value <= MAX);
endproperty

assert property (p_valid_range);
```

## 📊 Synthesis TCL Commands

### Basic Synthesis Script

```tcl
# Read design files
read_hdl -sv module.sv

# Elaborate design
elaborate top_module

# Set constraints
set_max_delay 10 -from [all_inputs] -to [all_outputs]

# Synthesize
synthesize -to_mapped

# Reports
report_area > area.rpt
report_power > power.rpt
report_gates > gates.rpt
report_timing > timing.rpt

# Write output
write_hdl > synthesized.v
write_sdc > constraints.sdc
```

## 🎨 Waveform Analysis

### Key Signals to Monitor

**For FSMs:**
- Clock and reset
- Current state
- Input triggers
- Output signals
- State transitions

**For Counters:**
- Clock and reset
- Enable signal
- Count value
- Overflow/done flag

**For Protocols:**
- Clock signals
- Data lines
- Control signals
- State indicators

## 📈 Common Issues & Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| Simulation hangs | Missing clock generator | Add `always #5 clk = ~clk;` |
| X/Z values | Uninitialized signals | Add reset logic |
| Synthesis warnings | Latches inferred | Use complete case statements |
| Timing violations | Long combinational paths | Add pipeline stages |
| Functional mismatch | Race conditions | Use non-blocking assignments in sequential |

## 🔍 File Extensions Reference

| Extension | Description |
|-----------|-------------|
| `.sv` | SystemVerilog source file |
| `.svh` | SystemVerilog header file |
| `.v` | Verilog source file |
| `.log` | Simulation/synthesis log |
| `.vcd` | Value Change Dump (waveform) |
| `.fsdb` | Fast Signal Database (Verdi) |
| `.rpt` | Report file (synthesis) |
| `.sdc` | Synopsys Design Constraints |
| `.lib` | Liberty timing library |
| `.tcl` | Tool Command Language script |

## 💡 Pro Tips

### Simulation Speed

```systemverilog
// Use time scale
`timescale 1ns/1ps

// Limit simulation time
initial begin
    #10000;  // 10 microseconds
    $finish;
end
```

### Code Reusability

```systemverilog
// Use parameters
parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 16;

// Use generate blocks
generate
    for (genvar i = 0; i < WIDTH; i++) begin
        // Replicated logic
    end
endgenerate
```

### Better Debugging

```systemverilog
// Name your blocks
begin : block_name
    // Code
end

// Use meaningful signal names
logic state_machine_idle;
logic data_valid_flag;
logic [7:0] byte_counter;
```

## 📚 Useful SystemVerilog Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `+`, `-`, `*`, `/` | Arithmetic | `a + b` |
| `==`, `!=` | Equality | `a == 5` |
| `===`, `!==` | Case equality (4-state) | `a === 1'bx` |
| `&`, `|`, `^` | Bitwise | `a & b` |
| `&&`, `||`, `!` | Logical | `a && b` |
| `<<`, `>>` | Shift | `a << 2` |
| `{,}` | Concatenation | `{a, b, c}` |
| `{n{}}` | Replication | `{4{1'b0}}` |
| `? :` | Conditional | `sel ? a : b` |

## 🎯 Design Checklist

- [ ] Reset behavior defined
- [ ] Clock domain specified
- [ ] All outputs assigned in all conditions
- [ ] No latches (unless intended)
- [ ] Testbench covers all states/cases
- [ ] Waveforms captured
- [ ] Documentation updated
- [ ] Synthesis successful
- [ ] Timing constraints met

## 📞 Getting Help

1. Check project README files
2. Review [CONTRIBUTING.md](CONTRIBUTING.md)
3. Consult [SystemVerilog LRM](https://ieeexplore.ieee.org/document/8299595)
4. Visit [Cadence Support](https://support.cadence.com/)
5. Open an issue on GitHub

---

**Quick Links:**
- [Main README](README.md)
- [Project Summary (Portuguese)](RESUMO.md)
- [Architecture Guide](ARCHITECTURE.md)
- [Contributing Guidelines](CONTRIBUTING.md)
