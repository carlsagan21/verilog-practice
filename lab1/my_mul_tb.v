`timescale 1ns/100ps
`include "my_mul.v"

module my_mul_tb;
  parameter BIT_WIDTH = 32;
  parameter TEST_COUNT = 8;

  reg [BIT_WIDTH-1:0] ain, bin;
  wire [BIT_WIDTH-1:0] dout;
  wire overflow;

  my_mul UUT(ain, bin, dout, overflow);

  integer i;

  initial begin
    ain = 'hffffffff;
    bin = 'h1;

    $dumpfile("my_mul_tb.vcd");
    $dumpvars(0, my_mul_tb);
    for (i=0; i<TEST_COUNT; i=i+1) begin
      ain = $random%'hffff;
      bin = $random%'hfffff;
      #10;
      $display("ain: %h / bin: %h / dout: %h / overflow: %h", ain, bin, dout, overflow);
    end

    $finish;
  end

endmodule
