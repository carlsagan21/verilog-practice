module my_add #(
	parameter BIT_WIDTH = 32
)
(
	input [BIT_WIDTH-1:0] ain,
	input [BIT_WIDTH-1:0] bin,
	output [BIT_WIDTH-1:0] dout,
	output overflow
);

assign {overflow, dout} = ain + bin;

endmodule
