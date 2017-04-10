`timescale 1ns / 1ps

module tb_bram # ();
  parameter BRAM_ADDR_WIDTH = 15;

  reg [BRAM_ADDR_WIDTH-1:0] BRAM_ADDR;
  reg BRAM_CLK;
  wire [31:0] BRAM_WRDATA1;
  wire [31:0] BRAM_RDDATA1;
  wire [31:0] BRAM_RDDATA2;
  reg done;

  reg [BRAM_ADDR_WIDTH-1:0] temp_ADDR1;
  reg [BRAM_ADDR_WIDTH-1:0] temp_ADDR2;

  integer i;

  initial begin
    BRAM_CLK = 0;
    BRAM_ADDR = 0;
    for(i=0; i<8192; i=i+1) begin
      #10;
      BRAM_ADDR = BRAM_ADDR+3'b100;
    end
    #20;
    done <= 1;
  end

  always #5 BRAM_CLK=~BRAM_CLK;

  always @(posedge BRAM_CLK) begin
    temp_ADDR1 <= BRAM_ADDR;
    temp_ADDR2 <= temp_ADDR1;
  end

 my_bram # (
 15, "input.txt", "output1.txt"
 ) bram1 (
    .BRAM_ADDR(BRAM_ADDR),
    .BRAM_CLK(BRAM_CLK),
    .BRAM_WRDATA(BRAM_WRDATA1),
    .BRAM_RDDATA(BRAM_RDDATA1),
    .BRAM_EN(1'b1),
    .BRAM_RST(1'b0),
    .BRAM_WE(4'b0000),
    .done(done)
  );

 my_bram # (
 15, "", "output2.txt"
  ) bram2 (
    .BRAM_ADDR(temp_ADDR2),
    .BRAM_CLK(BRAM_CLK),
    .BRAM_WRDATA(BRAM_RDDATA1),
    .BRAM_RDDATA(BRAM_RDDATA2),
    .BRAM_EN(1'b1),
    .BRAM_RST(1'b0),
    .BRAM_WE(4'b1111),
    .done(done)
  );

endmodule
