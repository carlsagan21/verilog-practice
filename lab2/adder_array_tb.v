`timescale 1ns/100ps
`include "adder_array.v"

module adder_array_tb;
    parameter BIT_WIDTH = 32;
    parameter TEST_COUNT = 32;

    reg [2:0] cmd;
    reg [BIT_WIDTH-1:0] ain0, ain1, ain2, ain3, bin0, bin1, bin2, bin3;
    wire [BIT_WIDTH-1:0] dout0, dout1, dout2, dout3;
    wire [3:0] overflow;

    adder_array UUT(.cmd(cmd), .ain0(ain0), .ain1(ain1), .ain2(ain2), .ain3(ain3), .bin0(bin0), .bin1(bin1), .bin2(bin2), .bin3(bin3), .dout0(dout0), .dout1(dout1), .dout2(dout2), .dout3(dout3), .overflow(overflow));

    integer i, j;

    initial begin
        $dumpfile("adder_array_tb.vcd");
        $dumpvars(0, adder_array_tb);

        cmd = 0;
        ain0 = 0;
        ain1 = 0;
        ain2 = 0;
        ain3 = 0;
        bin0 = 0;
        bin1 = 0;
        bin2 = 0;
        bin3 = 0;
        #10;

        for (i=0; i<TEST_COUNT; i=i+1) begin
            cmd = i%5;
            ain0 = $urandom%'hffffffff;
            ain1 = $urandom%'hffffffff;
            ain2 = $urandom%'hffffffff;
            ain3 = $urandom%'hffffffff;
            bin0 = $urandom%'hffffffff;
            bin1 = $urandom%'hffffffff;
            bin2 = $urandom%'hffffffff;
            bin3 = $urandom%'hffffffff;

            #10;
            $display("ain: %h, %h, %h, %h / bin: %h, %h, %h, %h / dout: %h, %h, %h, %h / overflow: %h", ain0, ain1, ain2, ain3, bin0, bin1, bin2, bin3, dout0, dout1, dout2, dout3, overflow);
        end

    $finish;
    end

endmodule
