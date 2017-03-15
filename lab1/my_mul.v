module my_mul #(
	parameter BITWIDTH = 32
)
(
	input [BITWIDTH-1:0] ain,
	input [BITWIDTH-1:0] bin,
	output [BITWIDTH-1:0] dout,
	output overflow
);

wire [BITWIDTH*2-1:0] result = ain * bin;

assign {overflow, dout} = {|result[BITWIDTH*2-1:BITWIDTH], result[BITWIDTH-1:0]};

endmodule
