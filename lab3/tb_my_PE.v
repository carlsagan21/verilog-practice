`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/27/2017 01:23:02 PM
// Design Name:
// Module Name: tb_my_PE
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
`include "my_PE.v"

module tb_my_PE #(
    parameter BITWIDTH = 32,
    parameter L_RAM_SIZE = 6
) (
    // no input output
);

reg clk;
reg aresetn;
reg [BITWIDTH-1:0] ain, din;
reg [L_RAM_SIZE-1:0] addr;
reg we;
reg valid;
wire dvalid;
wire [BITWIDTH-1:0] dout;

integer i;

my_PE UUT (
    .aclk(clk),
    .aresetn(aresetn),
    .ain(ain),
    .din(din),
    .addr(addr),
    .we(we),
    .valid(valid),
    .dvalid(dvalid),
    .dout(dout)
);

initial begin
    aresetn = 1;
    ain = 0;
    din = 0;
    addr = 0;
    we = 0;
    valid = 0;

    clk = 0;
    forever begin
        #5 clk = ~clk;
    end
end

initial begin
    #5;
    we = 1;
    for (i = 0; i < 16; i = i + 1) begin
       addr = i;
       din = i;
    end
    we = 0;

    #10;

    valid = 1;
    for (i = 0; i < 16; i = i + 1) begin
        addr = i;
        ain = 10;
        // delay several cycles... have to use dvalid to check
//        wait (dvalid) begin

//        end
    end
    valid = 0;

    $finish;
end



endmodule
