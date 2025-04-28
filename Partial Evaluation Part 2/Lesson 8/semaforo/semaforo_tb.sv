// Testbench para verificar a detecção de borda no semáforo
module semaforo_tb();
    // Test signals
    logic clk;
    logic reset;
    logic pulso;
    logic vermelho;
    logic verde;
    logic amarelo;
    
    // Instantiate the device under test (DUT)
    semaforo dut (
        .clk(clk),
        .reset(reset),
        .pulso(pulso),
        .vermelho(vermelho),
        .verde(verde),
        .amarelo(amarelo)
    );
    
    // Clock generation
    always begin
        #5 clk = ~clk;  // 10ns period
    end
    
    // Function to display current state
    function void display_state();
        $display("Time=%0t, State: Vermelho=%b, Verde=%b, Amarelo=%b", 
                 $time, vermelho, verde, amarelo);
    endfunction
    
    // Test sequence específica para testar detecção de borda
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        pulso = 0;
        
        // Release reset
        #20 reset = 0;
        display_state(); // Deve estar no estado VERMELHO após INICIO
        
        // Teste 1: Pulso único para avançar para VERDE
        #10 pulso = 1;
        #10 pulso = 0;
        #10 display_state(); // Deve estar em VERDE
        
        // Teste 2: Pulso mantido em alto - NÃO deve avançar
        #10 pulso = 1;
        #30 display_state(); // Ainda deve estar em VERDE
        
        // Teste 3: Pulso voltando a 0 e depois 1 - DEVE avançar
        #10 pulso = 0;
        #10 pulso = 1;
        #10 display_state(); // Deve avançar para AMARELO
        
        // Teste 4: Outro pulso para VERMELHO
        #10 pulso = 0;
        #10 pulso = 1;
        #10 display_state(); // Deve avançar para VERMELHO
        
        // Teste 5: Testar reset durante operação
        #10 reset = 1;
        #10 reset = 0;
        #10 display_state(); // Deve voltar a VERMELHO após INICIO
        
        // Fim do teste
        #10 $finish;
    end
    
    // Monitor
    initial begin
        $monitor("Time=%0t, reset=%b, pulso=%b, pulso_edge=%b, vermelho=%b, verde=%b, amarelo=%b", 
                 $time, reset, pulso, dut.pulso_edge, vermelho, verde, amarelo);
    end
endmodule