// Testbench para o Detector de Padrão Serial
module detec_padrao_serial_tb();
    // Test signals
    logic clk;
    logic reset;
    logic x;
    logic match;
    
    // Device under test
    detec_padrao_serial dut (
        .clk(clk),
        .reset(reset),
        .x(x),
        .match(match)
    );
    
    // Clock generation
    always begin
        #5 clk = ~clk;  // 10ns period
    end
    
    // Monitor para melhor visualização
    always @(posedge clk) begin
        $display("Time=%0t, Reset=%b, x=%b, dado_ff=%b, match=%b", 
                 $time, reset, x, dut.dado_ff, match);
    end
    
    // Test sequence
    initial begin
        // Initialize
        clk = 0;
        reset = 1;
        x = 0;
        
        // Release reset
        #10 reset = 0;
        
        $display("\n--- Teste 1: Padrão 0111 ---");
        #10 x = 0;
        #10 x = 1;
        #10 x = 1;
        #10 x = 1;  // Aqui o padrão 0111 deve ser detectado
        
        $display("\n--- Teste 2: Padrão 1011 (não deve casar) ---");
        #10 x = 1;
        #10 x = 0;
        #10 x = 1;
        #10 x = 1;  // Este padrão não deve ser detectado
        
        $display("\n--- Teste 3: Padrão 0111 novamente ---");
        #10 x = 0;
        #10 x = 1;
        #10 x = 1;
        #10 x = 1;  // Novamente o padrão 0111
        
        $display("\n--- Teste 4: Teste de reset ---");
        #10 reset = 1;
        #10 reset = 0;
        $display("Reset aplicado, registrador deve estar zerado");
        
        $display("\n--- Teste 5: Sequência após reset ---");
        #10 x = 1;
        #10 x = 1;
        #10 x = 1;
        #10 x = 0;  // Este padrão não deve ser detectado
        
        // Fim do teste
        #10 $finish;
    end
endmodule