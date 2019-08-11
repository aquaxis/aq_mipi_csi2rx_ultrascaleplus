module csi_rx_phy(
  input RST_N,

  input MIPI_CLK_P,
  input MIPI_CLK_N,

  input MIPI_D0_P,
  input MIPI_D0_N,
  input MIPI_D1_P,
  input MIPI_D1_N


);

// Clock
IBUFDS 
#(
  .DIFF_TERM(1),
  .IBUF_LOW_PWR(0),
  .IOSTANDARD("DEFAULT")
)
u_IBUFDS_CLK(
  .I(MIPI_CLK_P),
  .IB(MIPI_CLK_N),
  .O(clk_bit)
);


endmodule
