`include "../lab1/my_add.v"

module adder_array (cmd, ain0, ain1, ain2, ain3, bin0, bin1, bin2, bin3, dout0, dout1, dout2, dout3, overflow);
  parameter BIT_WIDTH = 32;

  input [2:0] cmd;
  input [BIT_WIDTH-1:0] ain0, ain1, ain2, ain3;
  input [BIT_WIDTH-1:0] bin0, bin1, bin2, bin3;
  output reg [BIT_WIDTH-1:0] dout0, dout1, dout2, dout3;
  output reg [3:0] overflow;

  wire [BIT_WIDTH*4-1:0] ain = {ain3, ain2, ain1, ain0};
  wire [BIT_WIDTH*4-1:0] bin = {bin3, bin2, bin1, bin0};
  wire [BIT_WIDTH*4-1:0] dout;
  wire [3:0] temp_overflow;

  genvar i;

  generate
    for(i=0; i<4; i=i+1) begin: add
      my_add my_add_impl(
        ain[BIT_WIDTH*(i+1)-1 : BIT_WIDTH*i],
        bin[BIT_WIDTH*(i+1)-1 : BIT_WIDTH*i],
        dout[BIT_WIDTH*(i+1)-1 : BIT_WIDTH*i],
        temp_overflow[i]
      );
    end
  endgenerate

  integer j;

  always @ ( * ) begin
    for (j=0; j<5; j=j+1) begin
      if (cmd == 3'b000) begin
        {dout3, dout2, dout1, dout0} = {{(BIT_WIDTH*3){1'b0}}, dout[(BIT_WIDTH*1)-1 : (BIT_WIDTH*0)], {(BIT_WIDTH*0){1'b0}}};
        overflow = {{3{1'b0}}, temp_overflow[0], {0{1'b0}}};
      end
      else if (cmd == 3'b001) begin
        {dout3, dout2, dout1, dout0} = {{(BIT_WIDTH*2){1'b0}}, dout[(BIT_WIDTH*2)-1 : (BIT_WIDTH*1)], {(BIT_WIDTH*1){1'b0}}};
        overflow = {{2{1'b0}}, temp_overflow[1], {1{1'b0}}};
      end
      else if (cmd == 3'b010) begin
        {dout3, dout2, dout1, dout0} = {{(BIT_WIDTH*1){1'b0}}, dout[(BIT_WIDTH*3)-1 : (BIT_WIDTH*2)], {(BIT_WIDTH*2){1'b0}}};
        overflow = {{1{1'b0}}, temp_overflow[2], {2{1'b0}}};
      end
      else if (cmd == 3'b011) begin
        {dout3, dout2, dout1, dout0} = {{(BIT_WIDTH*0){1'b0}}, dout[(BIT_WIDTH*4)-1 : (BIT_WIDTH*3)], {(BIT_WIDTH*3){1'b0}}};
        overflow = {{0{1'b0}}, temp_overflow[3], {3{1'b0}}};
      end
      else if (cmd == 3'b100) begin
        {dout3, dout2, dout1, dout0} = dout;
        overflow = temp_overflow;
      end
      else begin
        $display("invalid cmd: %d", cmd);
      end
    end
  end

endmodule
