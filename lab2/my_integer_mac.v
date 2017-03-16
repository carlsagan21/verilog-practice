`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/16/2017 10:20:53 AM
// Design Name:
// Module Name: my_integer_mac
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module my_integer_mac(
    input [31:0] ain, bin, cin,
    input clk,
    output [31:0] out
    );

    wire [31:0] sum;

    mult_gen_MAC multi( // from IP catalog
        .A(ain),
        .B(bin),
        .CLK(clk),
        .P(sum)
    );

    c_addsub_MAC adder( // from IP catalog
        .A(sum),
        .B(cin),
        .CLK(clk),
        .S(out)
    );

endmodule
