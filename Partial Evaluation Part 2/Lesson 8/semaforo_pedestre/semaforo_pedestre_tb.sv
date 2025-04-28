module tb_semaforo_pedestre();

    logic clk, reset, botao_pedestre;
    logic Q1, Q2, Q3, Q4, Q5;

    semaforo_pedestre dut (
        .clk(clk),
        .reset(reset),
        .botao_pedestre(botao_pedestre),
        .Q1(Q1),
        .Q2(Q2),
        .Q3(Q3),
        .Q4(Q4),
        .Q5(Q5)
    );

    // Clock de 1s (simulação acelerada)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 unidades = 1 ciclo de clock
    end

    // Estímulos
    initial begin
        $display("Iniciando simulação...");
        reset = 1;
        botao_pedestre = 0;
        #10;
        reset = 0;

        // Deixar passar veículos por um tempo
        #30;

        // Pressionar botão do pedestre
        botao_pedestre = 1;
        #10;
        botao_pedestre = 0;

        // Esperar passar pelos estados amarelo e pedestre
        #100;

        // Pressionar de novo
        botao_pedestre = 1;
        #10;
        botao_pedestre = 0;

        #100;

        $finish;
    end

    // Monitorar sinais
    initial begin
        $monitor("Time=%0t : reset=%b botao=%b | Q1=%b Q2=%b Q3=%b | Q4=%b Q5=%b", 
                 $time, reset, botao_pedestre, Q1, Q2, Q3, Q4, Q5);
    end

endmodule

