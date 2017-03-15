`include "my_mul.v"

module my_mac #(
	parameter BITWIDTH = 32
)
(
	input [BITWIDTH-1:0] ain,
	input [BITWIDTH-1:0] bin,
  input en,
	output [BITWIDTH-1:0] dout,
	output overflow
);

wire [BITWIDTH-1:0] mul_result;
wire mul_overflow;

my_mul my_mul_impl(ain, bin, mul_result, mul_overflow);

// reg [BITWIDTH*2-1:0] sum = sum + ain * bin;
reg [BITWIDTH:0] sum;

initial begin

end

always @ (en or ain or bin) begin
  sum = sum + mul_result;
end

// assign {overflow, dout} = {|result[BITWIDTH*2-1:BITWIDTH], result[BITWIDTH-1:0]};

endmodule
