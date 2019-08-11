`timescale 1ns / 1ps

module tb_csi_rx_lane_phy;

reg RST_N;
reg CLK_P;
wire CLK_N;
reg CLK_DIV;
reg DIN_P;
wire DIN_N;
reg DOUT_CLK;
wire DOUT_VALID;
wire [7:0] DOUT;

initial begin
  CLK_P    = 0;
  CLK_DIV = 0;
  DOUT_CLK = 0;
  RST_N    = 0;
  #100;
  RST_N    = 1;
end

always begin
  #(2)  CLK_P <= ~CLK_P;
end

always begin
  #(4)  CLK_DIV <= ~CLK_DIV;
end

always begin
  #(8)  DOUT_CLK <= ~DOUT_CLK;
end

assign CLK_N = ~CLK_P;

initial begin
  #100000;

  $finish();
end

always begin
  wait(RST_N);
  #(1) DIN_P = 1; // 1001_0101
  #(2) DIN_P = 0;
  #(2) DIN_P = 1;
  #(2) DIN_P = 0;
  #(2) DIN_P = 1;
  #(2) DIN_P = 0;
  #(2) DIN_P = 0;
  #(2) DIN_P = 1;

  #(2) DIN_P = 1; // 1011_0111
  #(2) DIN_P = 1;
  #(2) DIN_P = 1;
  #(2) DIN_P = 0;
  #(2) DIN_P = 1;
  #(2) DIN_P = 1;
  #(2) DIN_P = 0;
  #(2) DIN_P = 1;

  #(2) DIN_P = 0; // 1010_1010
  #(2) DIN_P = 1;
  #(2) DIN_P = 0;
  #(2) DIN_P = 1;
  #(2) DIN_P = 0;
  #(2) DIN_P = 1;
  #(2) DIN_P = 0;
  #(2) DIN_P = 1;

  #(2) DIN_P = 0; // 1010_1010
  #(2) DIN_P = 1;
  #(2) DIN_P = 0;
  #(2) DIN_P = 1;
  #(2) DIN_P = 0;
  #(2) DIN_P = 1;
  #(2) DIN_P = 0;
  #(2) DIN_P = 1;

  #(1);
end

assign DIN_N = ~DIN_P;

wire clk_bit, clk_byte;

  csi_rx_clk_phy u_csi_rx_clk_phy(
    .RST_N(RST_N),

    .MIPI_CLK_P(CLK_P),
    .MIPI_CLK_N(CLK_N),

    .CLK_BIT(clk_bit),
    .CLK_DIV(),
    .CLK_BYTE(data_clk)
  );

csi_rx_lane_phy u_csi_rx_lane_phy(
  .RST_N(RST_N),

  .CLK_P(clk_bit),
  .CLK_N(~clk_bit),

  .CLK_DIV(data_clk),

  .DIN_P(DIN_P),
  .DIN_N(DIN_N),

  .DOUT_CLK(DOUT_CLK),
  .DOUT_VALID(DOUT_VALID),
  .DOUT(DOUT)
);

endmodule