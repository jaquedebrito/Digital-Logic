`timescale 10ns / 1ps

//Codificador
module codificador_pt2262 (
    //Inputs
    input logic clk,       // 3 MHz clock
    input logic reset,     // reset ativo alto
    input logic [7:0] A,   // endereço de entrada, trinário
    input logic [0:3] D,   // dado de entrada

    //Outputs
    output logic sync,     // indica geração do símbolo SYNC
    output logic cod_o     // saída codificada
);

    logic [6:0] counter;        // Contador para a divisão de frequência (para 12 kHz)
    logic [3:0] bit_counter;    // Contador para os bits de A, D e SYNC
    logic [6:0] osc_counter;    // Contador de oscilações (para controlar os 32 ciclos)
    logic osc;                  // Oscilador de 12 kHz
    logic cod_o_reg;            // Registro de saída codificada

    // Saídas do comparador de endereço
    logic [7:0] A_01;         // Endereço com nível alto ou baixo
    logic [7:0] A_F;          // Endereço com FLOAT

    // A saída codificada é atribuída ao registrador interno
    assign cod_o = cod_o_reg;

    // Instanciação do comparador de endereço
    comp_endereco comp_inst (
        .A(A),      // Entrada A
        .A_01(A_01), // Saída A_01 (nível alto ou baixo)
        .A_F(A_F)   // Saída A_F (FLOAT)
    );
    
    // Divisor de frequência para gerar OSC (12 kHz)
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            osc <= 1;
        end else begin
            counter <= counter + 1;
            if (counter == 124) begin  // Divisão por 125 para gerar OSC de 12 kHz
                counter <= 0;
                osc <= ~osc;           // Alterna o OSC a cada 125 ciclos de 3 MHz
            end
        end
    end

    // Gera a sequência codificada de A, D e SYNC
    always_ff @(posedge osc or posedge reset) begin
        if (reset) begin
            osc_counter <= 0;          // Reinicia o contador de oscilações
            bit_counter <= 0;          // Reinicia o contador de bits
            cod_o_reg <= 0;            // Zera a saída codificada
            sync <= 0;                 // Desativa o sinal SYNC                 
        end 
        else begin

            // Controle do osc_counter para completar 32 ciclos por bit
            if (osc_counter == 31 && bit_counter < 12) begin
                osc_counter <= 0;                   // Resetar o contador de oscilações após 32 ciclos
                bit_counter <= bit_counter + 1;     // Incrementar o contador de bits para o próximo bit de A ou D
            end

            // bit_counter: Controla o avanço pelos bits de A, D e SYNC.
            // osc_counter: Controla os 32 ciclos de oscilação necessários para cada bit 

            else begin
                osc_counter <= osc_counter + 1;     // Incrementar o contador de oscilações
            end

            // Lógica de codificação para cada bit de A, D e SYNC
            if (bit_counter < 8) begin
                sync <= 0;

                // A (endereços): Codificados com base em padrões específicos de nível alto, baixo ou FLOAT.
                // D (dados): Codificados com padrões definidos no case.
                // SYNC: Indica o fim da transmissão com um padrão de 4 oscilações altas.

                // Codificação dos bits de A usando A_F[x] e A_01[x]
                if (A_F[bit_counter] == 0 && A_01[bit_counter] == 0) begin
                    if(osc_counter < 4)
                            cod_o_reg <= 1;
                        else if (osc_counter >3 && osc_counter<16)
                            cod_o_reg <= 0;
                        else if (osc_counter >15 && osc_counter<20)
                            cod_o_reg <= 1;
                        else 
                            cod_o_reg <= 0;
                    end
                else if (A_F[bit_counter] == 0 && A_01[bit_counter] == 1) begin
                    if(osc_counter < 12)
                            cod_o_reg <= 1;
                        else if (osc_counter >11 && osc_counter<16)
                            cod_o_reg <= 0;
                        else if (osc_counter >15 && osc_counter<29)
                            cod_o_reg <= 1;
                        else 
                            cod_o_reg <= 0;
                    end
                else if (A_F[bit_counter] == 1) begin
                    if(osc_counter < 4)
                            cod_o_reg <= 1;
                        else if (osc_counter >3 && osc_counter<16)
                            cod_o_reg <= 0;
                        else if (osc_counter >15 && osc_counter<29)
                            cod_o_reg <= 1;
                        else 
                            cod_o_reg <= 0;
                    end
                end
                
            else if (bit_counter < 12) begin
                // Codificação dos bits de D
                case (D[bit_counter - 8]) 
                        2'b00: begin                    
                            if(osc_counter < 4)
                                cod_o_reg <= 1;
                            else if (osc_counter >3 && osc_counter<16)
                                cod_o_reg <= 0;
                            else if (osc_counter >15 && osc_counter<20)
                                cod_o_reg <= 1;
                            else 
                                cod_o_reg <= 0;
                        end
                        2'b01: begin                    
                            if(osc_counter < 12)
                                cod_o_reg <= 1;
                            else if (osc_counter >11 && osc_counter<16)
                                cod_o_reg <= 0;
                            else if (osc_counter >15 && osc_counter<29)
                                cod_o_reg <= 1;
                            else 
                                cod_o_reg <= 0;
                        end
                endcase
            end
                // Gera o SYNC
            if (bit_counter >11) begin
                sync <= 1;
                if(bit_counter == 12 && osc_counter <4)
                    cod_o_reg <= 1;  // SYNC é representado por 4 oscilações altas
                else
                cod_o_reg <= 0;
                if (osc_counter == 127) begin
                    osc_counter <= 0;
                    bit_counter <= 0;  // Reinicia após completar todos os bits de A, D e SYNC
                end
            end
        end
    end
endmodule