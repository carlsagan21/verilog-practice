`timescale 1ns/100ps
`include "my_mul.v"

module my_mul_tb;
  parameter BITWIDTH = 32;
  parameter TESTCOUNT = 8;

  reg [BITWIDTH-1:0] ain, bin;
  wire [BITWIDTH-1:0] dout;
  wire overflow;

  my_mul UUT(ain, bin, dout, overflow);

  integer i;

  initial begin
    ain = 'hffffffff;
    bin = 'h1;

    $dumpfile("my_mul_tb.vcd");
    $dumpvars(0, my_mul_tb);
    for (i=0; i<TESTCOUNT; i=i+1) begin
      ain = $random%'hffff;
      bin = $random%'hfffff;
      #10;
      $display("ain: %h / bin: %h / dout: %h / overflow: %h", ain, bin, dout, overflow);
    end

    $finish;
  end

endmodule
