`include "my_mul.v"

module my_mac #(
	parameter BIT_WIDTH = 32
)
(
	input [BIT_WIDTH-1:0] ain,
	input [BIT_WIDTH-1:0] bin,
  input en,
	output [BIT_WIDTH-1:0] dout,
	output overflow
);

reg [BIT_WIDTH-1:0] sum;
reg [BIT_WIDTH*2-1:0] cal_result;
reg over_reg;
assign overflow = over_reg;
assign dout = sum;

initial begin
	sum = 0;
	cal_result = 0;
	over_reg = 0;
end

always @(en or ain or bin) begin
	if (en) begin
		cal_result = sum + ain * bin;
		over_reg = |cal_result[BIT_WIDTH * 2 - 1 : BIT_WIDTH];
		sum = cal_result[BIT_WIDTH - 1 : 0];
	end
	else begin
		sum = 0;
		over_reg = 0;
	end
end

endmodule
