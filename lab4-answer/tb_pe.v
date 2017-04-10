module tb_pe();
parameter L_RAM_SIZE = 6;

reg aclk;
reg [L_RAM_SIZE-1:0] addr;
reg [31:0] ain_mem [2**L_RAM_SIZE-1:0];
reg [31:0] din_mem [2**L_RAM_SIZE-1:0];
reg we;
reg valid;
reg [31:0] ain;
reg [31:0] din;
wire dvalid;
wire [31:0] dout;

integer i;
initial begin
  $readmemh("ain.txt", ain_mem);
  $readmemh("din.txt", din_mem);
  aclk = 0;
  addr = 0;
  valid = 0;
  we = 1;
  din = din_mem[0];
  for(i=0; i<16; i=i+1) begin
    #10;
    addr = addr+1;
    din = din_mem[addr];
  end
  //initial valid signal
  #10;
  addr = 0;
  valid = 1;
  we = 0;
  ain = ain_mem[0];
  #10;
  valid = 0;

  for(i=0; i<16; i=i+1) begin
    wait(dvalid==1)
    #10
    valid = 1;
    addr = addr+1;
    ain = ain_mem[addr];
    #10
    valid = 0;
  end
end

always #5 aclk = ~aclk;

my_pe #(
6
) PE (
  .aclk(aclk),
  .aresetn(1'b1),
  .ain(ain),
  .din(din),
  .addr(addr),
  .we(we),
  .valid(valid),
  .dvalid(dvalid),
  .dout(dout)
);

endmodule
