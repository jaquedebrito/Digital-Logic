`timescale 1ns/10ps

module tb_dec_i2c;

    // Interface signals
    logic clk;
    logic reset;
    logic sda;
    logic scl;
    logic pronto;
    logic [6:0] endereco_recebido;
    logic operacao;
    logic escrita;
    logic stop;

    // Parameters for clock and timing
    parameter SCL_PERIOD = 100;    // I2C clock period (100ns = 10MHz)
    parameter CLK_PERIOD = 10;     // System clock period (10ns = 100MHz)

    // Local address for the device under test
    localparam logic [6:0] ENDERECO_LOCAL = 7'b1100100;  // Address 0x64

    // Device Under Test instantiation
    dec_i2c dut (
        .clk(clk),
        .reset(reset),
        .sda(sda),
        .scl(scl),
        .pronto(pronto),
        .endereco_local(ENDERECO_LOCAL),
        .endereco_recebido(endereco_recebido),
        .operacao(operacao),
        .escrita(escrita),
        .stop(stop)
    );

    // System clock generation
    always begin
        #(CLK_PERIOD/2) clk = ~clk;  // Toggle clock every half period
    end

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        sda = 1;
        scl = 1;
        pronto = 1;

        // Apply reset sequence
        #(CLK_PERIOD*2);
        reset = 1;                   // Assert reset
        #(CLK_PERIOD*2);
        reset = 0;                   // Deassert reset
        #(CLK_PERIOD*2);

        // Test case 1: Correct address with write operation (0x64 + write bit = 0xC8)
        send_i2c_transaction(8'b11001000);
        #(SCL_PERIOD*5);            // Wait between transactions

        // Test case 2: Correct address with read operation (0x64 + read bit = 0xC9)
        send_i2c_transaction(8'b11001001);
        #(SCL_PERIOD*5);            // Wait between transactions

        // Test case 3: Incorrect address (0x55 = 0xAA)
        send_i2c_transaction(8'b10101010);
        #(SCL_PERIOD*5);            // Wait before completion

        $display("Simulation complete");
        $finish;                     // End simulation
    end

    // Task to simulate a complete I2C transaction
    task automatic send_i2c_transaction(input logic [7:0] data);
        begin
            // Generate START condition (SDA falls while SCL is high)
            sda = 1; scl = 1;
            #(SCL_PERIOD/2);
            sda = 0;                 // SDA goes low while SCL is high
            #(SCL_PERIOD/2);

            // Transmit 8 bits (7-bit address + 1-bit R/W) MSB first
            for (int i = 7; i >= 0; i--) begin
                scl = 0;             // SCL low to prepare for data change
                #(SCL_PERIOD/3);
                sda = data[i];       // Set data bit on SDA
                #(SCL_PERIOD/3);
                scl = 1;             // SCL high to latch data bit
                #(SCL_PERIOD/3);
            end

            // Generate ACK cycle (simulated as fixed low response)
            scl = 0;
            #(SCL_PERIOD/3);
            sda = 0;                 // ACK bit (pulled low by slave)
            #(SCL_PERIOD/3);
            scl = 1;                 // SCL high to latch ACK
            #(SCL_PERIOD/3);

            // Generate STOP condition (SDA rises while SCL is high)
            scl = 0;
            #(SCL_PERIOD/3);
            sda = 0;                 // Prepare SDA low
            #(SCL_PERIOD/3);
            scl = 1;                 // SCL goes high
            #(SCL_PERIOD/3);
            sda = 1;                 // SDA rises while SCL is high
            #(SCL_PERIOD/3);
        end
    endtask

    // Signal monitoring and waveform dumping for analysis
    initial begin
        $monitor("Time=%t | SCL=%b | SDA=%b | ADDRESS=%b | OP=%b | WRITE=%b | STOP=%b",
                 $time, scl, sda, endereco_recebido, operacao, escrita, stop);
        $dumpfile("dec_i2c_test.vcd");
        $dumpvars(0, tb_dec_i2c);
    end

endmodule
