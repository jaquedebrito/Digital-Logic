// Semáforo com detecção de borda no pulso
module semaforo (
    input logic clk,           // Clock signal
    input logic reset,         // Reset signal (active high)
    input logic pulso,         // Signal to advance state
    output logic vermelho,     // Red light output
    output logic verde,        // Green light output
    output logic amarelo       // Yellow light output
);
    
    // State definition
    typedef enum logic [1:0] {
        INICIO    = 2'b00,
        VERDE     = 2'b01,
        AMARELO   = 2'b10,
        VERMELHO  = 2'b11
    } state_t;
    
    // Estado registrado e detecção de borda
    state_t current_state, next_state;
    logic pulso_reg;
    logic pulso_edge;
    
    // Registrador para detecção de borda
    always_ff @(posedge clk) begin
        if (reset)
            pulso_reg <= 1'b0;
        else
            pulso_reg <= pulso;
    end
    
    // Detecção de borda de subida
    assign pulso_edge = pulso & ~pulso_reg;
    
    // Atualização do estado
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= INICIO;
        end
        else begin
            current_state <= next_state;
        end
    end
    
    // Lógica de próximo estado
    always_comb begin
        // Default: permanece no estado atual
        next_state = current_state;
        
        case (current_state)
            INICIO: begin
                // Do INICIO, avança imediatamente para VERMELHO
                next_state = VERMELHO;
            end
            
            VERDE: begin
                // Do VERDE, avança para AMARELO quando há pulso
                if (pulso_edge) next_state = AMARELO;
            end
            
            AMARELO: begin
                // Do AMARELO, avança para VERMELHO quando há pulso
                if (pulso_edge) next_state = VERMELHO;
            end
            
            VERMELHO: begin
                // Do VERMELHO, avança para VERDE quando há pulso
                if (pulso_edge) next_state = VERDE;
            end
            
            default: begin
                next_state = INICIO;
            end
        endcase
    end
    
    // Lógica de saída
    always_comb begin
        // Default: todas as luzes apagadas
        vermelho = 1'b0;
        amarelo = 1'b0;
        verde = 1'b0;
        
        case (current_state)
            INICIO: begin
                // Estado INICIO: vermelho e amarelo acesos
                vermelho = 1'b1;
                amarelo = 1'b1;
            end
            
            VERDE: begin
                // Estado VERDE: apenas verde aceso
                verde = 1'b1;
            end
            
            AMARELO: begin
                // Estado AMARELO: apenas amarelo aceso
                amarelo = 1'b1;
            end
            
            VERMELHO: begin
                // Estado VERMELHO: apenas vermelho aceso
                vermelho = 1'b1;
            end
        endcase
    end
endmodule