`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/26/2017 07:37:55 PM
// Design Name:
// Module Name: my_PE
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
`include "floating_point_MAC.v"

module my_PE # (
    parameter BITWIDTH = 32,
    parameter L_RAM_SIZE = 6
) (
  // clk / reset
  input aclk,
  input aresetn,
  // port A
  input [BITWIDTH-1:0] ain,
  // peram -> port B
  input [BITWIDTH-1:0] din,
  input [L_RAM_SIZE-1:0] addr,
  input we,
  // integrated valid signal
  input valid,
  // computation result
  output dvalid,
  output [BITWIDTH-1:0] dout
);
  reg [BITWIDTH-1:0] peram [0:2**L_RAM_SIZE-1]; //local register (* ram_style = "block" *)
  reg dvalid;
  reg [BITWIDTH-1:0] dout;

  reg [BITWIDTH-1:0] rout;
  reg rvalid;

  integer k;

  initial begin
    for (k = 0; k < 2**L_RAM_SIZE-1; k = k + 1) begin
        peram[k] = 0;
    end
    rout = 0;
    dout=0;
    dvalid=0;
  end

  floating_point_MAC M1(
         .aclk(aclk),
         .aresetn(aresetn),
         .s_axis_a_tvalid(valid),
         .s_axis_b_tvalid(valid),
         .s_axis_c_tvalid(valid),
         .s_axis_a_tdata(ain),
         .s_axis_b_tdata(rout),
         .s_axis_c_tdata(dout),
         .m_axis_result_tvalid(dvalid),
         .m_axis_result_tdata(dout)
  );

  always @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
        dout = 0;
    end
    else begin
        if (we) begin
            peram[addr] = din;
        end
        else begin
            rout= peram[addr];
        end
    end
  end
endmodule
