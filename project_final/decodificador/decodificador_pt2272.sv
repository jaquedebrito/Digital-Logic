`timescale 10ns / 1ps

module decodificador_pt2272(
    input logic clk,      // 3MHz
    input logic reset,    // Reset ativo alto
    input logic [7:0] A,  // Endereço de entrada
    input logic cod_i,    // Dado codificado de entrada
    output logic [3:0] D, // Dado recebido registrado
    output logic dv       // Sinalização de novo dado válido recebido
);

    logic [6:0] counter;         // Contador para gerar a base de tempo de 12 kHz
    logic [3:0] bit_counter;     // Contador para os bits de A, D e SYNC
    logic [6:0] osc_counter;     // Contador de oscilações para controlar os 32 ciclos
    logic osc;                   // Oscilador de 12 kHz
    logic [3:0] D_reg;           // Registrador para armazenar os dados recebidos

    logic [7:0] A_01;            // Endereço com nível alto ou baixo
    logic [7:0] A_F;             // Endereço com FLOAT
    logic sync_detected;         // Sinal para detectar o SYNC

    assign D = D_reg;
    assign dv = (bit_counter > 12 && osc_counter == 0 && sync_detected); // Dv é gerado quando SYNC é detectado

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
            osc <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == 124) begin  // Divisão por 125 para gerar OSC de 12 kHz
                counter <= 0;
                osc <= ~osc;           // Alterna o OSC a cada 125 ciclos de 3 MHz
            end
        end
    end

    // Detecção do SYNC e controle dos dados recebidos
    always_ff @(posedge osc or posedge reset) begin
        if (reset) begin
            osc_counter <= 0;
            bit_counter <= 0;
            sync_detected <= 0;    // Inicializa SYNC como não detectado
        end else begin
            // Controle do osc_counter para completar 32 ciclos por bit
            if (osc_counter == 31) begin
                osc_counter <= 0;               // Resetar o contador de oscilações após 32 ciclos
                bit_counter <= bit_counter + 1; // Incrementar o contador de bits
            end else begin
                osc_counter <= osc_counter + 1; // Incrementar o contador de oscilações
            end

            // Lógica de decodificação dos dados
            if (bit_counter < 8) begin
                // Decodificação dos bits de A
                if (A_01[bit_counter] == 1 && A_F[bit_counter] == 0) begin
                    // A = 1, adicionar o bit correspondente a D
                    D_reg[bit_counter] <= 1;
                end else if (A_01[bit_counter] == 0 && A_F[bit_counter] == 1) begin
                    // A = 0, outro bit correspondente
                    D_reg[bit_counter] <= 0;
                end
            end else if (bit_counter < 12) begin
                // Decodificação dos bits de D
                D_reg[bit_counter - 8] <= cod_i;
            end

            /// Detecção de SYNC após 12 bits de D recebidos
            if (bit_counter == 12 && osc_counter == 31) begin
                sync_detected <= 1;
            end else if (bit_counter > 12) begin
                sync_detected <= 0;
            end

            // Após a detecção de SYNC, preparar para o próximo pacote
            if (sync_detected) begin
                bit_counter <= 0;
                osc_counter <= 0;
            end
        end
    end
endmodule
