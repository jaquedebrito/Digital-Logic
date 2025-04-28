module semaforo_pedestre(
    input logic clk,
    input logic reset,
    input logic botao_pedestre,
    output logic Q1, Q2, Q3, Q4, Q5
);

    typedef enum logic [1:0] {
        PASSA_VEICULO = 2'b00,
        AMARELO = 2'b01,
        PASSA_PEDESTRE = 2'b10
    } state_t;

    state_t estado, prox_estado;
    int contador;

    // Estado atual
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            estado <= PASSA_VEICULO;
            contador <= 0;
        end else begin
            estado <= prox_estado;
            if (estado == PASSA_VEICULO && botao_pedestre)
                contador <= 0; // zera para contar no amarelo
            else
                contador <= contador + 1;
        end
    end

    // Lógica de transição
    always_comb begin
        prox_estado = estado;
        case (estado)
            PASSA_VEICULO: begin
                if (botao_pedestre)
                    prox_estado = AMARELO;
            end

            AMARELO: begin
                if (contador == 2) // depois de 2 ciclos
                    prox_estado = PASSA_PEDESTRE;
            end

            PASSA_PEDESTRE: begin
                if (contador == 4) // depois de 4 ciclos
                    prox_estado = PASSA_VEICULO;
            end
        endcase
    end

    // Lógica de saída
    always_comb begin
        // Default
        Q1 = 0; Q2 = 0; Q3 = 0; Q4 = 0; Q5 = 0;

        case (estado)
            PASSA_VEICULO: begin
                Q1 = 0; Q2 = 0; Q3 = 1; // Veículos: verde
                Q4 = 1; Q5 = 0;         // Pedestre: vermelho
            end

            AMARELO: begin
                Q1 = 0; Q2 = 1; Q3 = 0; // Veículos: amarelo
                Q4 = 1; Q5 = 0;         // Pedestre: vermelho
            end

            PASSA_PEDESTRE: begin
                Q1 = 1; Q2 = 0; Q3 = 0; // Veículos: vermelho
                Q4 = 0; Q5 = 1;         // Pedestre: verde
            end
        endcase
    end

endmodule

