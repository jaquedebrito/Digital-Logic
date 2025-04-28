“Pedestrian-Controlled Traffic Light” Project
Problem Statement

You were asked to design a traffic-light controller that only turns red for cars when requested by a pedestrian, following the prescribed state diagram.

    Inputs

        clk – 1 s clock period

        botao_pedestre – goes high when the pedestrian button is pressed

        reset – active-high synchronous reset

    Outputs

        Q1 – Car red lamp

        Q2 – Car yellow lamp

        Q3 – Car green lamp

        Q4 – Pedestrian red lamp

        Q5 – Pedestrian green lamp

Your top-level module was to be named semaforo_pedestre, and you also needed to provide a corresponding testbench (semaforo_pedestre_tb.sv) and verify the design via simulation.
Summary of Answers

    Number of States
    We defined 4 distinct states:

        Cars Green / Ped Red (default)

        Cars Yellow / Ped Red (pre-crossing warning)

        Cars Red / Ped Green (pedestrian crossing)

        Return to Default (after crossing completes)

    Bits to Encode States

        4 states ⇒ 2 bits (2² = 4)

    Design Implementation

        Module: semaforo_pedestre.sv

        Architecture:

            An enum FSM with 4 states, clocked on clk and reset on reset.

            Transitions triggered by botao_pedestre and simple cycle counters.

            Combinational always_comb block drives Q1…Q5 outputs based on the current state.

    Testbench

        File: semaforo_pedestre_tb.sv

        Generates a 1 s clock, pulses reset, toggles the pedestrian button at strategic times, and monitors all outputs.

        Verified correct sequence: Green → Yellow → Red/Walk → back to Green.

Simulation Results

    Compilation: zero errors, zero warnings.

    Waveform & Log: Confirmed that pressing the pedestrian button causes:

        Cars Yellow (2 s)

        Cars Red & Pedestrian Green (4 s)

        Return to Cars Green & Pedestrian Red

    The reset input immediately forces the FSM back to the default (Cars Green / Ped Red) state.

File Structure

Conclusion

    Design meets all requirements.

    FSM uses 4 states, encoded in 2 bits.

    Outputs Q1…Q5 correctly reflect each state.

    Testbench validates all scenarios, including reset behavior and multiple button presses.

This project demonstrates a clean, synthesizable SystemVerilog FSM and a robust testbench—ideal for FPGA or ASIC prototyping.
