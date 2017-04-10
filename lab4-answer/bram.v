module my_bram # (
    parameter integer BRAM_ADDR_WIDTH = 15, // 4x8192
    parameter INIT_FILE = "input.txt",
    parameter OUT_FILE = "output.txt"
  )(
    input wire [BRAM_ADDR_WIDTH-1:0] BRAM_ADDR,
    input wire BRAM_CLK,
    input wire [31:0] BRAM_WRDATA,
    output reg [31:0] BRAM_RDDATA,
    input wire BRAM_EN,
    input wire BRAM_RST,
    input wire [3:0] BRAM_WE,
    input wire done
  );

    reg [31:0] mem[0:8191];
    wire [BRAM_ADDR_WIDTH-3:0] addr = BRAM_ADDR[BRAM_ADDR_WIDTH-1:2];
    reg [31:0] dout;

    initial begin
      if (INIT_FILE != "") begin
        $readmemh(INIT_FILE, mem);
      end
      wait(done)
        $writememh(OUT_FILE, mem);
    end
	always @(posedge BRAM_CLK)
      if (BRAM_WE[0] && BRAM_EN)
        mem[addr][7:0] <= BRAM_WRDATA[7:0];

    always @(posedge BRAM_CLK)
      if (BRAM_WE[1] && BRAM_EN)
        mem[addr][15:8] <= BRAM_WRDATA[15:8];

    always @(posedge BRAM_CLK)
      if (BRAM_WE[2] && BRAM_EN)
        mem[addr][23:16] <= BRAM_WRDATA[23:16];

    always @(posedge BRAM_CLK)
      if (BRAM_WE[3] && BRAM_EN)
        mem[addr][31:24] <= BRAM_WRDATA[31:24];

    always @(posedge BRAM_CLK)
      dout <= mem[addr];

    always @(posedge BRAM_CLK)
    if (BRAM_RST)
      BRAM_RDDATA <= 'd0;

    else if (BRAM_EN)
      BRAM_RDDATA <= dout;

endmodule
