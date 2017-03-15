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

wire [BIT_WIDTH-1:0] mul_result;
wire mul_overflow;

my_mul my_mul_impl(ain, bin, mul_result, mul_overflow);

// reg [BIT_WIDTH*2-1:0] sum = sum + ain * bin;
reg [BIT_WIDTH:0] sum;

initial begin

end

always @ (en or ain or bin) begin
  sum = sum + mul_result;
end

// assign {overflow, dout} = {|result[BIT_WIDTH*2-1:BIT_WIDTH], result[BIT_WIDTH-1:0]};

endmodule
