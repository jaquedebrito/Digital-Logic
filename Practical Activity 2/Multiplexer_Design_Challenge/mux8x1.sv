//JAQUELINE FERREIRA DE BRITO
//ATIVIDADE EM AULA - MULTIPLEXADOR 8x1

`timescale 1ns/10ps

module meu_primeiro_mux8x1 (
    input logic EN,
    input logic [3:0] A,
    input logic [7:0] X,
    output logic Q
);
    
    // Fios para decodificação do endereço
    wire [7:0] selected_inputs;
    wire mux_out;
    wire [2:0] not_A;
    wire sel0, sel1, sel2, sel3, sel4, sel5, sel6, sel7;
    
    // Inversores para endereço (usamos apenas os 3 bits menos significativos)
    INVX1HVT inv_A0 (not_A[0], A[0]);
    INVX1HVT inv_A1 (not_A[1], A[1]);
    INVX1HVT inv_A2 (not_A[2], A[2]);
    
    // Decodificador 3:8 (usamos apenas os 3 bits menos significativos do endereço)
    
    // Seletor 0 - A=000
    AND3X1HVT and_sel0 (sel0, not_A[2], not_A[1], not_A[0]);
    
    // Seletor 1 - A=001
    AND3X1HVT and_sel1 (sel1, not_A[2], not_A[1], A[0]);
    
    // Seletor 2 - A=010
    AND3X1HVT and_sel2 (sel2, not_A[2], A[1], not_A[0]);
    
    // Seletor 3 - A=011
    AND3X1HVT and_sel3 (sel3, not_A[2], A[1], A[0]);
    
    // Seletor 4 - A=100
    AND3X1HVT and_sel4 (sel4, A[2], not_A[1], not_A[0]);
    
    // Seletor 5 - A=101
    AND3X1HVT and_sel5 (sel5, A[2], not_A[1], A[0]);
    
    // Seletor 6 - A=110
    AND3X1HVT and_sel6 (sel6, A[2], A[1], not_A[0]);
    
    // Seletor 7 - A=111
    AND3X1HVT and_sel7 (sel7, A[2], A[1], A[0]);
    
    // Conectar cada entrada com seu sinal de seleção
    // CORREÇÃO: Verifique a ordem dos parâmetros nas portas AND2X1HVT (saída, entrada1, entrada2)
    AND2X1HVT and_input0 (selected_inputs[0], sel0, X[0]);
    AND2X1HVT and_input1 (selected_inputs[1], sel1, X[1]);
    AND2X1HVT and_input2 (selected_inputs[2], sel2, X[2]);
    AND2X1HVT and_input3 (selected_inputs[3], sel3, X[3]);
    AND2X1HVT and_input4 (selected_inputs[4], sel4, X[4]);
    AND2X1HVT and_input5 (selected_inputs[5], sel5, X[5]);
    AND2X1HVT and_input6 (selected_inputs[6], sel6, X[6]);
    AND2X1HVT and_input7 (selected_inputs[7], sel7, X[7]);
    
    // Combinação das entradas selecionadas usando OR
    wire or_out1, or_out2, or_out3, or_out4, or_out5, or_out6;
    
    OR2X1HVT or_1 (or_out1, selected_inputs[0], selected_inputs[1]);
    OR2X1HVT or_2 (or_out2, selected_inputs[2], selected_inputs[3]);
    OR2X1HVT or_3 (or_out3, selected_inputs[4], selected_inputs[5]);
    OR2X1HVT or_4 (or_out4, selected_inputs[6], selected_inputs[7]);
    
    // Segunda camada de OR
    OR2X1HVT or_5 (or_out5, or_out1, or_out2);
    OR2X1HVT or_6 (or_out6, or_out3, or_out4);
    
    // OR final
    OR2X1HVT or_final (mux_out, or_out5, or_out6);
    
    // Aplicar o sinal de habilitação (EN)
    AND2X1HVT enable_and (Q, mux_out, EN);
    
endmodule