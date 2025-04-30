`timescale 1ns/10ps

module dec_i2c (
    input  logic        clk,          
    input  logic        reset,        
    input  logic        sda,          
    input  logic        scl,          
    input  logic        pronto,       
    input  logic [6:0]  endereco_local,

    output logic [6:0]  endereco_recebido,
    output logic        operacao,
    output logic        escrita,
    output logic        stop
);

    // Sinais internos
    logic prev_scl, prev_sda;
    logic start_cond, stop_cond;
    logic sobe_scl;
    logic [7:0] shift_reg;
    logic [3:0] bit_counter;

    typedef enum logic [2:0] {
        IDLE, ADDR, OP, ACK, DONE
    } state_t;

    state_t state;

    // Detecção de bordas e condições START/STOP
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            prev_scl     <= 1'b1;
            prev_sda     <= 1'b1;
            sobe_scl     <= 1'b0;
            start_cond   <= 1'b0;
            stop_cond    <= 1'b0;
        end else begin
            prev_scl     <= scl;
            prev_sda     <= sda;
            sobe_scl     <= (scl && !prev_scl);
            start_cond   <= (prev_sda && !sda && scl);
            stop_cond    <= (!prev_sda && sda && scl);
        end
    end

    // Máquina de estados principal
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state               <= IDLE;
            bit_counter         <= 4'd0;
            shift_reg           <= 8'd0;
            endereco_recebido   <= 7'd0;
            operacao            <= 1'b0;
            escrita             <= 1'b0;
            stop                <= 1'b0;
        end else begin
            escrita <= 1'b0;
            stop    <= 1'b0;

            case (state)
                IDLE: begin
                    bit_counter <= 4'd0;
                    if (start_cond)
                        state <= ADDR;
                end

                ADDR: begin
                    if (sobe_scl) begin
                        shift_reg   <= {shift_reg[6:0], sda};
                        bit_counter <= bit_counter + 1;
                        if (bit_counter == 4'd7)
                            state <= OP;
                    end
                end

                OP: begin
                    if (sobe_scl) begin
                        operacao          <= sda;
                        endereco_recebido <= shift_reg[7:1]; // bits 7 a 1 são o endereço
                        if (shift_reg[7:1] == endereco_local && !sda)
                            escrita <= 1'b1;
                        state <= ACK;
                    end
                end

                ACK: begin
                    if (sobe_scl)
                        state <= DONE;
                end

                DONE: begin
                    if (stop_cond) begin
                        if (pronto)
                            stop <= 1'b1;
                        state <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
