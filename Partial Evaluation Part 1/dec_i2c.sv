`timescale 1ns/10ps

module dec_i2c (
    input  logic        clk,          // System clock
    input  logic        reset,        // Reset signal
    input  logic        sda,          // I2C data line
    input  logic        scl,          // I2C clock line
    input  logic        pronto,       // Ready signal
    input  logic [6:0]  endereco_local, // Local I2C address

    output logic [6:0]  endereco_recebido, // Received address
    output logic        operacao,     // Operation type (read=1, write=0)
    output logic        escrita,      // Write indication
    output logic        stop          // Stop condition detected
);

    // Internal signals
    logic prev_scl, prev_sda;         // Previous states of SCL and SDA
    logic start_cond, stop_cond;      // Start and stop condition flags
    logic sobe_scl;                   // SCL rising edge
    logic [7:0] shift_reg;            // Shift register for received bits
    logic [3:0] bit_counter;          // Counter for received bits

    typedef enum logic [2:0] {
        IDLE, ADDR, OP, ACK, DONE
    } state_t;                        // FSM state type

    state_t state;                    // Current state

    // Edge detection for SCL and SDA, and START/STOP condition detection
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            prev_scl     <= 1'b1;     // Default high during reset
            prev_sda     <= 1'b1;     // Default high during reset
            sobe_scl     <= 1'b0;     // No edge during reset
            start_cond   <= 1'b0;     // No START during reset
            stop_cond    <= 1'b0;     // No STOP during reset
        end else begin
            prev_scl     <= scl;      // Store previous SCL value
            prev_sda     <= sda;      // Store previous SDA value
            sobe_scl     <= (scl && !prev_scl);            // Detect SCL rising edge
            start_cond   <= (prev_sda && !sda && scl);     // START: SDA falls while SCL is high
            stop_cond    <= (!prev_sda && sda && scl);     // STOP: SDA rises while SCL is high
        end
    end

    // Main state machine
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state               <= IDLE;       // Start in IDLE state
            bit_counter         <= 4'd0;       // Reset bit counter
            shift_reg           <= 8'd0;       // Clear shift register
            endereco_recebido   <= 7'd0;       // Clear received address
            operacao            <= 1'b0;       // Clear operation flag
            escrita             <= 1'b0;       // Clear write flag
            stop                <= 1'b0;       // Clear stop flag
        end else begin
            escrita <= 1'b0;                   // Default state: no write operation
            stop    <= 1'b0;                   // Default state: no stop condition

            case (state)
                IDLE: begin
                    bit_counter <= 4'd0;       // Reset bit counter
                    if (start_cond)            // If START condition detected
                        state <= ADDR;         // Move to address reception
                end

                ADDR: begin
                    if (sobe_scl) begin        // On rising edge of SCL
                        shift_reg   <= {shift_reg[6:0], sda};  // Shift in data bit
                        bit_counter <= bit_counter + 1;        // Increment counter
                        if (bit_counter == 4'd7)               // After 7 address bits
                            state <= OP;                       // Move to operation bit
                    end
                end

                OP: begin
                    if (sobe_scl) begin                        // On rising edge of SCL
                        operacao          <= sda;              // R/W bit (1=read, 0=write)
                        endereco_recebido <= shift_reg[7:1];   // Extract address (bits 7-1)
                        if (shift_reg[7:1] == endereco_local && !sda) // If address matches and write op
                            escrita <= 1'b1;                   // Signal write operation
                        state <= ACK;                          // Move to ACK state
                    end
                end

                ACK: begin
                    if (sobe_scl)                              // On rising edge of SCL
                        state <= DONE;                         // Move to DONE state
                end

                DONE: begin
                    if (stop_cond) begin                       // If STOP condition detected
                        if (pronto)                            // If ready signal is high
                            stop <= 1'b1;                      // Assert stop output
                        state <= IDLE;                         // Return to IDLE state
                    end
                end

                default: state <= IDLE;                        // Safety default
            endcase
        end
    end

endmodule
