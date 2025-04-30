`timescale 1ns/10ps

module tb_dec_i2c;

    logic clk;
    logic reset;
    logic sda;
    logic scl;
    logic pronto;
    logic [6:0] endereco_recebido;
    logic operacao;
    logic escrita;
    logic stop;

    parameter SCL_PERIOD = 100;
    parameter CLK_PERIOD = 10;

    localparam logic [6:0] ENDERECO_LOCAL = 7'b1100100;

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

    // Clock do sistema
    always begin
        #(CLK_PERIOD/2) clk = ~clk;
    end

    initial begin
        clk = 0;
        reset = 0;
        sda = 1;
        scl = 1;
        pronto = 1;

        #(CLK_PERIOD*2);
        reset = 1;
        #(CLK_PERIOD*2);
        reset = 0;
        #(CLK_PERIOD*2);

        // Transação com endereço correto + escrita
        send_i2c_transaction(8'b11001000);
        #(SCL_PERIOD*5);

        // Transação com endereço correto + leitura
        send_i2c_transaction(8'b11001001);
        #(SCL_PERIOD*5);

        // Endereço incorreto
        send_i2c_transaction(8'b10101010);
        #(SCL_PERIOD*5);

        $display("Simulation complete");
        $finish;
    end

    // Tarefa para simular uma transação I2C
    task automatic send_i2c_transaction(input logic [7:0] data);
        begin
            // Condição de start: SDA cai com SCL alto
            sda = 1; scl = 1;
            #(SCL_PERIOD/2);
            sda = 0; #(SCL_PERIOD/2);

            // Transmissão dos 8 bits MSB primeiro
            for (int i = 7; i >= 0; i--) begin
                scl = 0;
                #(SCL_PERIOD/3);
                sda = data[i];
                #(SCL_PERIOD/3);
                scl = 1;
                #(SCL_PERIOD/3);
            end

            // Bit de ACK (simulado como 0 fixo)
            scl = 0;
            #(SCL_PERIOD/3);
            sda = 0;
            #(SCL_PERIOD/3);
            scl = 1;
            #(SCL_PERIOD/3);

            // Condição de stop: SDA sobe com SCL alto
            scl = 0;
            #(SCL_PERIOD/3);
            sda = 0;
            #(SCL_PERIOD/3);
            scl = 1;
            #(SCL_PERIOD/3);
            sda = 1;
            #(SCL_PERIOD/3);
        end
    endtask

    // Monitoramento de sinais e waveform
    initial begin
        $monitor("Time=%t | SCL=%b | SDA=%b | END=%b | OP=%b | ESC=%b | STOP=%b",
                 $time, scl, sda, endereco_recebido, operacao, escrita, stop);
        $dumpfile("dec_i2c_test.vcd");
        $dumpvars(0, tb_dec_i2c);
    end

endmodule
