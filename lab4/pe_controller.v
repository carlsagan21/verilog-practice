`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/03/2017 01:19:23 PM
// Design Name:
// Module Name: pe_controller
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


module pe_controller # (
    parameter VECTOR_SIZE = 16, // vector size
    parameter L_RAM_SIZE = 6 // 4
)(
    input start,
    output done,
    input aclk,
    input aresetn,
    output [L_RAM_SIZE-1:0] rdaddr, // address from PE // applyed -1. not sure thou..
    input [31:0] rddata,
    output reg [31:0] wrdata
);

// PE
wire [31:0] ain;
wire [31:0] din;
wire [L_RAM_SIZE-1:0] addr;
wire we_local;	//we for local reg in PE
wire we_global;	//we for global reg on the outside of PE
wire valid;		//input valid
wire dvalid;
wire [31:0] dout;
wire [L_RAM_SIZE-1:0] rdaddr;	//address from PE


// global block ram
reg [31:0] gdout;
//(* ram_style = "block" *)
reg [31:0] globalmem [0:VECTOR_SIZE-1];

//integer i;
always @(posedge aclk)
    if (we_global) begin // we_global
        globalmem[counter - 16] = rddata;
    end
    // else if (we_local) begin // we_local
    //     din = rddata;
    //     addr = counter;
    // end

// down counter
reg [31:0] counter;
wire [31:0] ld_val = load_flag ? CNTLOAD1 : (calc_flag ? CNTCALC1 : (done_flag ? CNTDONE : 0)); // per stata max_count 31?


wire counter_ld = (state_d != state) ? 1 : 0; // detect change of state FIXME
wire counter_en = (load_flag && (state_d == state)) ? 1 : (calc_flag ? dvalid : (done_flag ? 1 : 0)); // per state
wire counter_reset = !aresetn;
always @(posedge aclk)
    if (counter_reset)
        counter <= 'd0;
    else
        if (counter_ld)
            counter <= ld_val;
        else if (counter_en)
            counter <= counter - 1;

//FSM
// transition triggering flags
wire load_done;
wire calc_done;
wire done_done;

// state register
reg [3:0] state, state_d;
localparam S_IDLE = 4'd0;
localparam S_LOAD = 4'd1;
localparam S_CALC = 4'd2;
localparam S_DONE = 4'd3;

//part 1: state transition
always @(posedge aclk)
    if (!aresetn)
        state <= S_IDLE;
    else
        case (state)
            S_IDLE:
                state <= start ? S_LOAD : S_IDLE;
            S_LOAD: // LOAD PERAM
                state <= load_done ? S_CALC: S_LOAD;
            S_CALC: // CALCULATE RESULT
                state <= calc_done ? S_DONE: S_CALC;
            S_DONE:
                state <= done_done ? S_IDLE : S_DONE;
            default:
                state <= S_IDLE;
        endcase

always @(posedge aclk)
    if (!aresetn)
        state_d <= S_IDLE;
    else
        state_d <= state;

//part 2: determine state
// S_LOAD
reg load_flag;
wire load_flag_reset = ((state_d !=state) && state_d == S_LOAD) || !aresetn;
wire load_flag_en = start;
localparam CNTLOAD1 = 32;
always @(posedge aclk)
    if (load_flag_reset)
        load_flag <= 'd0;
    else
        if (load_flag_en)
            load_flag <= 'd1;
        else
            load_flag <= load_flag;

// S_CALC
reg calc_flag;
wire calc_flag_reset = ((state_d !=state) && state_d == S_CALC) || !aresetn;
wire calc_flag_en = !load_done; // FIXME
localparam CNTCALC1 = 16;
always @(posedge aclk)
    if (calc_flag_reset)
        calc_flag <= 'd0;
    else
        if (calc_flag_en)
            calc_flag <= 'd1;
        else
            calc_flag <= calc_flag;

// S_DONE
reg done_flag;
wire done_flag_reset = ((state_d !=state) && state_d == S_DONE) || !aresetn;
wire done_flag_en = !calc_done; // FIXME
localparam CNTDONE = 5;
always @(posedge aclk)
    if (done_flag_reset)
        done_flag <= 'd0;
    else
        if (done_flag_en)
            done_flag <= 'd1;
        else
            done_flag <= done_flag;

//part3: update output and internal register
//S_LOAD: we
assign we_local = state == S_LOAD && counter < 16 ? 'd1 : 'd0;
assign we_global = state == S_LOAD && counter >= 16 ? 'd1 : 'd0;

//S_CALC: wrdata
always @(posedge aclk)
    if (!aresetn)
            wrdata <= 'd0;
    else
        if (calc_done)
                wrdata <= dout;
        else
                wrdata <= wrdata;

//S_CALC: valid
reg valid_pre, valid_reg;
always @(posedge aclk)
    if (!aresetn)
        valid_pre <= 'd0;
    else
        if (dvalid && calc_flag) //FIXME
            valid_pre <= 'd1;
        else
            valid_pre <= 'd0;

always @(posedge aclk)
    if (!aresetn)
        valid_reg <= 'd0;
    else if (calc_flag)
        valid_reg <= valid_pre;

assign valid = valid_reg; // FIXME

//S_CALC: ain
assign ain = calc_flag ? gdout : 'd0;

//S_LOAD&&CALC
assign addr = CNTLOAD1 - counter; // FIXME reverse way counter


//S_LOAD
assign din = (load_flag&&counter<16) ? rddata : 'd0;
assign rdaddr = !we_global ? counter : 'd0; // FIXME

//done signals
assign load_done = (load_flag) && (counter == 'd0);
assign calc_done = (calc_flag) && (counter == 'd0) && dvalid;
assign done_done = (done_flag) && (counter == 'd0);
assign done = (state == S_DONE) && done_done;



// my_PE #(
//     .L_RAM_SIZE(L_RAM_SIZE)
// ) u_pe (
//     .aclk(aclk),
//     .aresetn(aresetn && (state != S_DONE)),
//     .ain(ain),
//     .din(din),
//     .addr(addr),
//     .we(we_local),
//     .valid(valid),
//     .dvalid(dvalid),
//     .dout(dout)
// );

endmodule
