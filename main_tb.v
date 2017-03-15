// Verilog test bench for example_3_1
`timescale 1ns/100ps
`include "main.v"

module main_tb;

  wire A, B, C, D, E;
  integer k=0;

  assign {A,B,C} = k;
  main UUT(A, B, C, D, E);

  initial begin

    $dumpfile("main.vcd");
    $dumpvars(0, main_tb);

    for (k=0; k<8; k=k+1)
      #10 $display("done testing case %d", k);

    $finish;

  end

endmodule
