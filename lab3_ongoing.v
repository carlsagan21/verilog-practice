`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/22/2017 01:22:17 PM
// Design Name:
// Module Name: my_BRAM
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


module my_BRAM # (
  parameter integer BRAM_ADDR_WIDTH = 15, // 4x8192
  parameter INIT_FILE = "input.txt",
  parameter OUT_FILE = "output.txt"
)(
  input wire [BRAM_ADDR_WIDTH-1:0] BRAM_ADDR,
  input wire BRAM_CLK,
  input wire [31:0] BRAM_WRDATA,
  output reg [31:0] BRAM_RDDATA,
  input wire BRAM_EN,
  input wire BRAM_RST,
  input wire [3:0] BRAM_WE,
  input wire done
);
  reg [31:0] mem[0:8191];
  wire [BRAM_ADDR_WIDTH-3:0] addr = BRAM_ADDR[BRAM_ADDR_WIDTH-1:2];
  reg [31:0] dout;

  reg [31:0] read_waiting;

  //codes for simulation
  initial begin
    read_waiting = 0;
    integer k;
    for (k = 0; k < 8192; k = k + 1) begin
        mem[k] = 0;
    end

    if (INIT_FILE != "") begin
        #10;// read data
    end  // ___________________________________________  //read data from INIT_FILE and store them into mem


//    wait (done) _______________________________________________  //write data stored in mem into OUT_FILE
  end
  //code for BRAM implementation
  always @(posedge BRAM_CLK or BRAM_RST) begin
    if (BRAM_RST) begin
        BRAM_RDDATA = 0;
    end
    else begin
        if (BRAM_EN) begin
           if (BRAM_WE == 0) begin
             BRAM_RDDATA = mem[addr];
           end
           else begin
               if(BRAM_WE[0]) begin
                 mem[addr][7:0] = BRAM_WRDATA[7:0];
               end
               if(BRAM_WE[1]) begin
                 mem[addr][15:8] = BRAM_WRDATA[15:8];
               end
               if(BRAM_WE[2]) begin
                 mem[addr][23:16] = BRAM_WRDATA[23:16];
               end
               if(BRAM_WE[3]) begin
                 mem[addr][31:24] = BRAM_WRDATA[31:24];
               end
           end
        end
        else begin
            // ?
        end
    end
  end


endmodule
