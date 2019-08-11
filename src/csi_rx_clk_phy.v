module csi_rx_clk_phy(
  input RST_N,

  input MIPI_CLK_P,
  input MIPI_CLK_N,

  output CLK_BIT,
  output CLK_DIV,
  output CLK_BYTE
);

wire clk_bit_pre;

// Clock
/*
IBUFDS
#(
  .DIFF_TERM("TRUE"),
  .IBUF_LOW_PWR("FALSE"),
  .IOSTANDARD("DEFAULT")
)
u_IBUFDS_CLK(
  .I(MIPI_CLK_P),
  .IB(MIPI_CLK_N),
  .O(clk_bit_pre)
);
*/

IBUFDS_DPHY #(
  .DIFF_TERM("TRUE"),
  .IOSTANDARD("MIPI_DPHY_DCI"),
  .SIM_DEVICE("ULTRASCALE_PLUS")
)
u_IBUFDS_DPHY(
  .I(MIPI_CLK_P),
  .IB(MIPI_CLK_N),
  .HSRX_DISABLE(1'b0),
  .LPRX_DISABLE(1'b1),
  .HSRX_O(clk_bit_pre),
  .LPRX_O_N(),
  .LPRX_O_P()
);

BUFGCE u_BUFGCE_CLK
(
  .CE(1'b1),
  .I(clk_bit_pre),
  .O(CLK_BIT)
);
/*
BUFGCE_DIV #(
  .BUFGCE_DIVIDE(2),
  .CE_TYPE("SYNC"),
  .HARDSYNC_CLR("FALSE")
)
u_BUFGCE_DIV(
  .O(CLK_DIV),

  .CE(1'b1),
  .CLR(~RST_N),
  .I(clk_bit_pre)
);
*/
BUFGCE_DIV #(
  .BUFGCE_DIVIDE(4),
  .CE_TYPE("SYNC"),
  .HARDSYNC_CLR("FALSE")
)
u_BUFGCE_DIV2(
  .O(CLK_BYTE),

  .CE(1'b1),
  .CLR(~RST_N),
  .I(clk_bit_pre)
);

/*
BUFIO u_BUFIO_CLK
(
  .I(clk_bit_pre),
  .O(CLK_BIT)
);

BUFR
#(
  .BUFR_DIVIDE("4"),
  .SIM_DEVICE("7SERIES")
)
u_BUFR_CLK(
  .CLR(~RST_N),
  .CE(1),
  .I(clk_bit_pre),
  .O(CLK_BYTE)
);
*/
endmodule
