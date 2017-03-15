// Verilog test bench for example_3_1
`timescale 1ns/100ps
`include "my_add.v"

module my_add_tb;
  parameter BITWIDTH = 32;
  parameter TESTCOUNT = 8;

  reg [BITWIDTH-1:0] ain, bin;
  wire [BITWIDTH-1:0] dout;
  wire overflow;

  my_add UUT(ain, bin, dout, overflow);

  integer i;

  initial begin
    ain = 'hffffffff;
    bin = 'h1;

    $dumpfile("my_add_tb.vcd");
    $dumpvars(0, my_add_tb);
    for (i=0; i<TESTCOUNT; i=i+1) begin
      ain = $random%'hffffffff;
      bin = $random%'hffffffff;
      #10;
      $display("ain: %h / bin: %h / dout: %h / overflow: %h", ain, bin, dout, overflow);
    end

    $finish;
  end

endmodule
