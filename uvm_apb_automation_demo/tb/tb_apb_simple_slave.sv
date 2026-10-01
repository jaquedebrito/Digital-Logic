`timescale 1ns/1ps

module tb_apb_simple_slave;
  logic        pclk;
  logic        presetn;
  logic        psel;
  logic        penable;
  logic        pwrite;
  logic [7:0]  paddr;
  logic [31:0] pwdata;
  logic [31:0] prdata;
  logic        pready;
  logic        pslverr;
  logic [3:0]  wait_cycles;

  string testcase;
  int    seed;

  int uvm_error_count;
  int uvm_fatal_count;

  bit saw_write;
  bit saw_read;
  bit saw_waitstate;
  bit saw_violation_detected;

  longint first_failure_time_ns;
  longint root_cause_time_ns;

  string status;
  real   coverage;

  apb_simple_slave dut (
      .pclk(pclk),
      .presetn(presetn),
      .psel(psel),
      .penable(penable),
      .pwrite(pwrite),
      .paddr(paddr),
      .pwdata(pwdata),
      .prdata(prdata),
      .pready(pready),
      .pslverr(pslverr),
      .wait_cycles(wait_cycles)
  );

  initial pclk = 1'b0;
  always #5 pclk = ~pclk;

  task automatic reset_dut();
    begin
      presetn  = 1'b0;
      psel     = 1'b0;
      penable  = 1'b0;
      pwrite   = 1'b0;
      paddr    = '0;
      pwdata   = '0;
      wait_cycles = 4'd0;
      repeat (3) @(posedge pclk);
      presetn  = 1'b1;
      repeat (2) @(posedge pclk);
    end
  endtask

  task automatic mark_error(input string msg);
    begin
      uvm_error_count = uvm_error_count + 1;
      if (first_failure_time_ns < 0)
        first_failure_time_ns = $time;
      root_cause_time_ns = $time;
      $display("TB_ERROR time_ns=%0t message=%s", $time, msg);
    end
  endtask

  task automatic apb_write(input logic [7:0] addr, input logic [31:0] data);
    int timeout;
    begin
      timeout = 0;
      @(posedge pclk);
      psel    <= 1'b1;
      penable <= 1'b0;
      pwrite  <= 1'b1;
      paddr   <= addr;
      pwdata  <= data;

      @(posedge pclk);
      penable <= 1'b1;

      while (!pready && timeout < 50) begin
        saw_waitstate = 1'b1;
        timeout++;
        @(posedge pclk);
      end

      if (!pready)
        mark_error($sformatf("WRITE timeout addr=0x%0h", addr));

      @(posedge pclk);
      psel    <= 1'b0;
      penable <= 1'b0;
      pwrite  <= 1'b0;
      saw_write = 1'b1;
    end
  endtask

  task automatic apb_read(input logic [7:0] addr, output logic [31:0] data);
    int timeout;
    begin
      timeout = 0;
      @(posedge pclk);
      psel    <= 1'b1;
      penable <= 1'b0;
      pwrite  <= 1'b0;
      paddr   <= addr;

      @(posedge pclk);
      penable <= 1'b1;

      while (!pready && timeout < 50) begin
        saw_waitstate = 1'b1;
        timeout++;
        @(posedge pclk);
      end

      if (!pready) begin
        mark_error($sformatf("READ timeout addr=0x%0h", addr));
      end

      data = prdata;
      @(posedge pclk);
      psel    <= 1'b0;
      penable <= 1'b0;
      saw_read = 1'b1;
    end
  endtask

  task automatic inject_protocol_violation();
    begin
      @(posedge pclk);
      psel    <= 1'b0;
      penable <= 1'b1; // violação proposital: PENABLE alto sem PSEL
      pwrite  <= 1'b1;
      paddr   <= 8'h00;
      pwdata  <= 32'hABCD_1234;
      @(posedge pclk);
      penable <= 1'b0;
      pwrite  <= 1'b0;
      paddr   <= '0;
      pwdata  <= '0;
    end
  endtask

  always @(posedge pclk) begin
    if (presetn && penable && !psel) begin
      saw_violation_detected <= 1'b1;
      mark_error("Protocol violation detected: PENABLE asserted without PSEL");
    end
  end

  task automatic run_smoke();
    logic [31:0] rdata;
    begin
      wait_cycles = 4'd0;
      apb_write(8'h04, 32'hCAFE_BABE);
      apb_read(8'h04, rdata);
      if (rdata !== 32'hCAFE_BABE)
        mark_error($sformatf("Smoke mismatch: got=0x%08h expected=0xCAFE_BABE", rdata));
    end
  endtask

  task automatic run_corner();
    logic [31:0] rdata0;
    logic [31:0] rdata1;
    begin
      wait_cycles = 4'd4;
      apb_write(8'h00, 32'h1234_5678);
      apb_write(8'h08, 32'hA5A5_5A5A);
      apb_read(8'h00, rdata0);
      apb_read(8'h08, rdata1);
      if (rdata0 !== 32'h1234_5678)
        mark_error($sformatf("Corner mismatch addr0: got=0x%08h", rdata0));
      if (rdata1 !== 32'hA5A5_5A5A)
        mark_error($sformatf("Corner mismatch addr8: got=0x%08h", rdata1));
    end
  endtask

  task automatic run_injected();
    begin
      wait_cycles = 4'd0;
      inject_protocol_violation();
      repeat (2) @(posedge pclk);
    end
  endtask

  task automatic finalize_status_and_coverage();
    int total_points;
    int hit_points;
    begin
      total_points = 0;
      hit_points = 0;

      if (testcase == "apb_smoke_basic_rw") begin
        total_points = 2;
        hit_points = (saw_write ? 1 : 0) + (saw_read ? 1 : 0);
        status = (uvm_error_count == 0) ? "PASS" : "FAIL";
      end else if (testcase == "apb_corner_waitstate_max") begin
        total_points = 3;
        hit_points = (saw_write ? 1 : 0) + (saw_read ? 1 : 0) + (saw_waitstate ? 1 : 0);
        status = (uvm_error_count == 0) ? "PASS" : "FAIL";
      end else begin
        total_points = 1;
        hit_points = (saw_violation_detected ? 1 : 0);
        if (uvm_error_count > 0)
          status = "FAIL_EXPECTED";
        else
          status = "FAIL_NO_DETECTION";
      end

      coverage = (total_points > 0) ? (100.0 * hit_points / total_points) : 0.0;
    end
  endtask

  initial begin
    testcase = "apb_smoke_basic_rw";
    seed = 1;

    if (!$value$plusargs("TESTCASE=%s", testcase))
      testcase = "apb_smoke_basic_rw";
    if (!$value$plusargs("SEED=%d", seed))
      seed = 1;

    void'($urandom(seed));

    uvm_error_count = 0;
    uvm_fatal_count = 0;
    saw_write = 1'b0;
    saw_read = 1'b0;
    saw_waitstate = 1'b0;
    saw_violation_detected = 1'b0;
    first_failure_time_ns = -1;
    root_cause_time_ns = -1;

    reset_dut();

    if (testcase == "apb_smoke_basic_rw") begin
      run_smoke();
    end else if (testcase == "apb_corner_waitstate_max") begin
      run_corner();
    end else if (testcase == "apb_injected_protocol_violation") begin
      run_injected();
    end else begin
      mark_error($sformatf("Unknown testcase: %s", testcase));
      status = "INVALID_TESTCASE";
    end

    finalize_status_and_coverage();

    $display("TB_RESULT testcase=%s status=%s uvm_error_count=%0d uvm_fatal_count=%0d coverage=%0.1f first_failure_time_ns=%0d root_cause_time_ns=%0d",
             testcase, status, uvm_error_count, uvm_fatal_count, coverage,
             first_failure_time_ns, root_cause_time_ns);

    repeat (2) @(posedge pclk);
    $finish;
  end

endmodule
