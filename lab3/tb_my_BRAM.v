`timescale 100ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/26/2017 06:36:35 PM
// Design Name:
// Module Name: tb_my_BRAM
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
`include "my_BRAM.v"

module tb_my_BRAM;

parameter BITWIDTH = 32;

reg [14:0] address [1:0];
reg clk;
reg [BITWIDTH-1:0] write_data [1:0];
reg enable [1:0];
reg reset [1:0];
reg [3:0] write_enable [1:0];

reg done [1:0];

integer i, j;

wire [BITWIDTH-1:0] read_data [1:0];

my_BRAM #(
    .INIT_FILE("input.txt")
) UUT0 (
    .BRAM_ADDR(address[0]),
    .BRAM_CLK(clk),
    .BRAM_WRDATA(write_data[0]),
    .BRAM_RDDATA(read_data[0]),
    .BRAM_EN(enable[0]),
    .BRAM_RST(reset[0]),
    .BRAM_WE(write_enable[0]),
    .done(done[0])
);

my_BRAM #(
    .OUT_FILE("output.txt")
) UUT1 (
    .BRAM_ADDR(address[1]),
    .BRAM_CLK(clk),
    .BRAM_WRDATA(read_data[0]),
    .BRAM_RDDATA(read_data[1]),
    .BRAM_EN(enable[1]),
    .BRAM_RST(reset[1]),
    .BRAM_WE(write_enable[1]),
    .done(done[1])
);

initial begin
    for (i = 0; i < 2; i = i + 1) begin
        address[i] = 0;
        write_data[i] = 0;
        enable[i] = 0;
        reset[i] = 0;
        write_enable[i] = 0;
        done[i] = 0;
    end

    clk = 0;
    forever begin
        #5 clk = ~clk;
    end

end

initial begin
    #5;
    enable[0] = 1;
    enable[1] = 1;
    write_enable[0] = 0;
    write_enable[1] = 4'b1111;

    for (j = 0; j < 8192; j = j + 1) begin
        address[0] = j * 4;
        address[1] = j * 4;
        #10;
    end

    #100;

    done[0] = 1;
    done[1] = 1; // write UUT1 content
    #100;
    // reset UUT0
    reset[0] = 1;

    // UUT2 read (for check)
    write_enable[1] = 0;
    for (j = 0; j < 8192; j = j + 1) begin
        address[0] = j * 4;
        address[1] = j * 4;
        #10;
    end

    // reset UUT1
    reset[1] = 1;

    $finish;
end


//always @(posedge clk) begin

//end

endmodule
