// Verilog test bench for example_3_1
`timescale 1ns/100ps
`include "adder_array.v"

module adder_array_tb;
  parameter BITWIDTH = 32;
  parameter TESTCOUNT = 32;

  reg [2:0] cmd;
  reg [BITWIDTH-1:0] ain0, ain1, ain2, ain3, bin0, bin1, bin2, bin3;
  wire [BITWIDTH-1:0] dout0, dout1, dout2, dout3;
  wire [3:0] overflow;

  adder_array UUT(.cmd(cmd), .ain0(ain0), .ain1(ain1), .ain2(ain2), .ain3(ain3), .bin0(bin0), .bin1(bin1), .bin2(bin2), .bin3(bin3), .dout0(dout0), .dout1(dout1), .dout2(dout2), .dout3(dout3), .overflow(overflow));

  integer i, j;

  initial begin
    // ain0 = 0;
    // ain1 = 0;
    // ain2 = 0;
    // ain3 = 0;
    // bin0 = 0;
    // bin1 = 0;
    // bin2 = 0;
    // bin3 = 0;

    $dumpfile("adder_array_tb.vcd");
    $dumpvars(0, adder_array_tb);

    for (i=0; i<TESTCOUNT; i=i+1) begin
      // for (j=0; j<4; j=j+1) begin
      //   ain = $random%'hffffffff;
      //   bin = $random%'hffffffff;
      // end
      cmd = i%5;
      ain0 = $random%'hffffffff;
      ain1 = $random%'hffffffff;
      ain2 = $random%'hffffffff;
      ain3 = $random%'hffffffff;
      bin0 = $random%'hffffffff;
      bin1 = $random%'hffffffff;
      bin2 = $random%'hffffffff;
      bin3 = $random%'hffffffff;

      #10;
      $display("ain: %h, %h, %h, %h / bin: %h, %h, %h, %h / dout: %h, %h, %h, %h / overflow: %h", ain0, ain1, ain2, ain3, bin0, bin1, bin2, bin3, dout0, dout1, dout2, dout3, overflow);
    end

    $finish;
  end

endmodule
