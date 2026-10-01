module apb_simple_slave (
    input  logic        pclk,
    input  logic        presetn,
    input  logic        psel,
    input  logic        penable,
    input  logic        pwrite,
    input  logic [7:0]  paddr,
    input  logic [31:0] pwdata,
    output logic [31:0] prdata,
    output logic        pready,
    output logic        pslverr,
    input  logic [3:0]  wait_cycles
);

  logic [31:0] regfile [0:3];
  logic [3:0]  wait_count;
  logic        trans_done;

  function automatic logic valid_addr(input logic [7:0] addr);
    valid_addr = (addr == 8'h00) || (addr == 8'h04) || (addr == 8'h08) || (addr == 8'h0C);
  endfunction

  function automatic logic [1:0] addr_idx(input logic [7:0] addr);
    case (addr)
      8'h00: addr_idx = 2'd0;
      8'h04: addr_idx = 2'd1;
      8'h08: addr_idx = 2'd2;
      default: addr_idx = 2'd3;
    endcase
  endfunction

  assign pready = psel && penable && (wait_count == 0);

  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      regfile[0] <= 32'h0000_0000;
      regfile[1] <= 32'h0000_0000;
      regfile[2] <= 32'h0000_0000;
      regfile[3] <= 32'h0000_0000;
      prdata     <= 32'h0000_0000;
      pslverr    <= 1'b0;
      wait_count <= 4'd0;
      trans_done <= 1'b0;
    end else begin
      if (!psel) begin
        wait_count <= 4'd0;
        trans_done <= 1'b0;
        pslverr    <= 1'b0;
      end else begin
        if (!penable && !trans_done) begin
          wait_count <= wait_cycles;
          pslverr    <= 1'b0;
        end else if (penable && !trans_done) begin
          if (wait_count != 0) begin
            wait_count <= wait_count - 1'b1;
          end else begin
            trans_done <= 1'b1;
            if (!valid_addr(paddr)) begin
              pslverr <= 1'b1;
              prdata  <= 32'hDEAD_BEEF;
            end else if (pwrite) begin
              regfile[addr_idx(paddr)] <= pwdata;
              pslverr <= 1'b0;
            end else begin
              prdata  <= regfile[addr_idx(paddr)];
              pslverr <= 1'b0;
            end
          end
        end
      end
    end
  end

endmodule
