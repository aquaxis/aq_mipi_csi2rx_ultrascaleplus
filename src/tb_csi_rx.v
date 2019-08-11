`timescale 1ns / 1ps

module tb_csi_rx;

reg RST;
reg MIPI_CLK_P;
wire MIPI_CLK_N;

wire [3:0] LED;

initial begin
  MIPI_CLK_P = 0;
  RST = 1;
  #100;
  RST = 0;
end

always begin
  #(10/2)	MIPI_CLK_P <= ~MIPI_CLK_P;
end

assign MIPI_CLK_N = ~MIPI_CLK_P;

initial begin
  #100000;

  $finish();
end

csi_rx u_csi_rx(
  .RST(RST),

  .MIPI_CLK_P(MIPI_CLK_P),
  .MIPI_CLK_N(MIPI_CLK_N),

  .LED(LED)

);

endmodule
