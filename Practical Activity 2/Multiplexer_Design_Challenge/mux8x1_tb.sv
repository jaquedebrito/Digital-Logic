//JAQUELINE FERREIRA DE BRITO
//ATIVIDADE EM AULA - TESTBENCH MULTIPLEXADOR 8x1

`timescale 1ns/10ps

module tb();
    logic EN;
    logic [3:0] A;
    logic [7:0] X;
    logic Q;
    
    // Instanciação do módulo a ser testado
    meu_primeiro_mux8x1 duv (
        .EN(EN),
        .A(A),
        .X(X),
        .Q(Q)
    );
    
    // Geração de estímulos
    initial begin
        // Inicialização
        EN = 0;
        A = 4'b0000;
        X = 8'b10101010;
        #10;
        
        // Teste 1: Verificar se a saída é zero quando EN=0
        $display("TESTE 1: Verificar sinal de habilitação (EN=0)");
        repeat (4) begin
            A = $random;
            X = $random;
            #10;
            if (Q !== 0) $error("FALHA: Saída deve ser 0 quando EN=0, A=%b, X=%b, Q=%b", A, X, Q);
            else $display("PASSOU: EN=0, A=%b, X=%b, Q=%b", A, X, Q);
        end
        
        // Teste 2: Verificar cada seleção quando EN=1
        $display("TESTE 2: Verificar todas as seleções possíveis (EN=1)");
        EN = 1;
        X = 8'b10101010; // Padrão alternado para facilitar a verificação
        
        for (int i = 0; i < 8; i++) begin
            A = i;
            #10;
            if (Q !== X[i]) $error("FALHA: Para A=%d, esperado Q=%b, obtido Q=%b", i, X[i], Q);
            else $display("PASSOU: A=%d seleciona X[%d]=%b, Q=%b", i, i, X[i], Q);
        end
        
        // Teste 3: Valores aleatórios com EN=1
        $display("TESTE 3: Valores aleatórios com EN=1");
        repeat (10) begin
            int addr = $urandom_range(0, 7); // Limitamos a 0-7 para maior clareza
            A = addr;
            X = $random;
            #10;
            if (Q !== X[addr]) 
                $error("FALHA: Para A=%d, X=%b, esperado Q=%b, obtido Q=%b", addr, X, X[addr], Q);
            else 
                $display("PASSOU: A=%d, X=%b, Q=%b", addr, X, Q);
        end
        
        $display("Simulação concluída");
        $finish;
    end
    
    // Monitor para exibir valores
    initial begin
        $monitor("Tempo=%0t, EN=%b, A=%b, X=%b, Q=%b", $time, EN, A, X, Q);
    end
    
endmodule