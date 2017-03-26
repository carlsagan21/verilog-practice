`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/16/2017 11:13:55 AM
// Design Name:
// Module Name: tb_floating
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

`include "IP_floating.v"

module tb_floating;

    reg [31:0] ain;
    reg [31:0] bin;
    reg [31:0] cin;
    reg clk;
    reg rst;

    wire [31:0] out;

    IP_floating UUT(.rst(rst), .ain(ain), .bin(bin), .cin(cin), .clk(clk), .res(out));

    initial begin
        rst = 0;
        ain = 0;
        bin = 0;
        cin = 0;
        clk = 0;
        forever begin
            #10
            clk = ~clk;
        end
    end

    always @(posedge clk) begin
        ain = $random%'hfffffffff;
        bin = $random%'hfffffffff;
        cin = $random%'hfffffffff;
    end

endmodule
