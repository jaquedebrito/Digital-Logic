`timescale 1ns / 1ps

module tb_codificador_pt2262;
    // Declaração de sinais
    logic clk;
    logic reset;
    logic [7:0] A;
    logic [3:0] D;
    logic sync;
    logic cod_o;

    // Sinais de saída do comparador de endereço
    logic [7:0] A_01;  // Endereço com nível alto ou baixo
    logic [7:0] A_F;   // Endereço com FLOAT

    // Instanciação do codificador
    codificador_pt2262 uut (
        .clk(clk),
        .reset(reset),
        .A(A),
        .D(D),
        .sync(sync),
        .cod_o(cod_o)
    );

    // Gerar o clock (3 MHz)
    always begin
        #166 clk = ~clk;  // Período de 250 ciclos (3 MHz)
    end

    // Processo de teste
    initial begin
        // Inicialização
        clk = 0;
        reset = 0;
        A = 8'b00000000;
        D = 4'b0000;

        // Geração do reset
        reset = 0;
        #50;
        reset = 1;
        #500;
        reset = 0;
        #500;

        // Teste no modo 0 (uso direto de A)
       
        A = 8'b01010010;  // Exemplo de valor para A
        D = 4'b1010;      // Exemplo de valor para D
        $display("Modo 0: A = %b, D = %b", A, D);
        #42.7ms;

        // Teste no modo 1 (uso de A_F e A_01)
        
        A = 8'b11001100;  // Outro valor para A
        D = 4'b1111;      // Outro valor para D
        $display("Modo 1: A = %b, D = %b", A, D);
        #42.7ms;

        // Teste com valores de A onde alguns bits são "Z"
        A = 8'b1z0zzz11;  // Testando valores de A com "Z" (FLOAT)
        D = 4'b1100;
        $display("Modo 1 com FLOAT: A = %b, D = %b", A, D);
        #42.7ms;

        // Verificando o comportamento de A_F e A_01
        $display("A_F = %b, A_01 = %b", A_F, A_01);
        #500000;

        // Finalizando a simulação
        $finish;
    end
endmodule
