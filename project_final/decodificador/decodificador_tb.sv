`timescale 1ns/1ps

module tb_codificador_decodificador;
    // Sinais de teste
    logic clk;
    logic reset;
    logic [7:0] A;
    logic [3:0] D_input;
    logic [3:0] D_output;
    logic cod_i;
    logic cod_o;    
    logic dv;
    logic sync;  

    // Instanciação do codificador
    codificador_pt2262 codificador_inst (
        .clk(clk),
        .reset(reset),
        .A(A),
        .D(D_input),
        .cod_o(cod_o),
        .sync(sync)
    );

    // Instanciação do decodificador
    decodificador_pt2272 decodificador_inst (
        .clk(clk),
        .reset(reset),
        .A(A),
        .cod_i(cod_o),
        .D(D_output),
        .dv(dv)
    );

    // Gerar o clock
    always begin
        #166 clk = ~clk;  // Período de 20 ns (50 MHz)
    end

    // Processo de teste
    initial begin
        // Inicialização
        clk = 0;
        reset = 0;
        D_input = 4'b0000;
        A = 8'b00000000;

        // Geração do reset
        reset = 1;
        #40;
        reset = 0;
        #40;

        // Teste no modo 0
        A = 8'b01010010;
        D_input = 4'b1010;
        @(posedge sync);  // Espera até dv ser ativado
        if (D_output !== D_input) begin
            $display("Erro: D_output (%b) diferente de D_input (%b)", D_output, D_input);
        end else begin
            $display("Sucesso: D_output (%b) igual a D_input (%b)", D_output, D_input);
        end
        #1300000;

        // Teste no modo 1
        A = 8'b11001100;
        D_input = 4'b1111;
        @(posedge sync);  // Espera até dv ser ativado
        if (D_output !== D_input) begin
            $display("Erro: D_output (%b) diferente de D_input (%b)", D_output, D_input);
        end else begin
            $display("Sucesso: D_output (%b) igual a D_input (%b)", D_output, D_input);
        end
        #1300000;
        // Finalizando a simulação
        $finish;
    end
endmodule
