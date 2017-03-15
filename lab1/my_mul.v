module my_mul #(
	parameter BIT_WIDTH = 32
)
(
	input [BIT_WIDTH-1:0] ain,
	input [BIT_WIDTH-1:0] bin,
	output [BIT_WIDTH-1:0] dout,
	output overflow
);

wire [BIT_WIDTH*2-1:0] result = ain * bin;

assign {overflow, dout} = {|result[BIT_WIDTH*2-1:BIT_WIDTH], result[BIT_WIDTH-1:0]};

endmodule
