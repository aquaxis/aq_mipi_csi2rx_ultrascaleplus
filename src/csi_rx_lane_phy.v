module csi_rx_lane_phy(
  input RST_N,

  input CLK_P,
  input CLK_N,

  input CLK_DIV,

  input DIN_P,
  input DIN_N,

  input DOUT_CLK,
  output DOUT_VALID,
  output [7:0] DOUT
);

wire in_data;
wire [7:0] serdes_data;
/*
IBUFDS
#(
  .DIFF_TERM("TRUE"),
  .IBUF_LOW_PWR("FALSE"),
  .IOSTANDARD("DEFAULT")
)
u_IBUFDS
(
  .I(DIN_P),
  .IB(DIN_N),
  .O(in_data)
);
*/

IBUFDS_DPHY #(
  .DIFF_TERM("TRUE"),
  .IOSTANDARD("MIPI_DPHY_DCI"),
  .SIM_DEVICE("ULTRASCALE_PLUS")
)
u_IBUFDS_DPHY(
  .I(DIN_P),
  .IB(DIN_N),
  .HSRX_DISABLE(1'b0),
  .LPRX_DISABLE(1'b1),
  .HSRX_O(in_data),
  .LPRX_O_N(),
  .LPRX_O_P()
);

IDELAYE3 #(
  .CASCADE("NONE"),
  .DELAY_FORMAT("TIME"),
  .DELAY_SRC("IDATAIN"),
  .DELAY_TYPE("FIXED"),
  .DELAY_VALUE(0),
  .IS_CLK_INVERTED(0),
  .IS_RST_INVERTED(0),
  .LOOPBACK("FALSE"),
  .REFCLK_FREQUENCY(500.0),
  .SIM_DEVICE("ULTRASCALE_PLUS"),
  .SIM_VERSION(2.0),
  .UPDATE_MODE("ASYNC")
)
u_IDELAYE3(
  .CASC_OUT(),
  .CNTVALUEOUT(),
  .DATAOUT(in_delayed),

  .CASC_IN(),
  .CASC_RETURN(),
  .CE(),
  .CLK(CLK_DIV),
  .CNTVALUEIN(),
  .DATAIN(),
  .EN_VTC(),
  .IDATAIN(in_data),
  .INC(),
  .LOAD(),
  .RST(~RST_N)
);

wire serdes_clk, fifo_empty;

ISERDESE3 #(
  .DATA_WIDTH(8),
  .DDR_CLK_EDGE("OPPOSITE_EDGE"),
  .FIFO_ENABLE("TRUE"),
  .FIFO_SYNC_MODE("FALSE"),
  .IDDR_MODE("FALSE"),
  .IS_CLK_B_INVERTED(0),
  .IS_CLK_INVERTED(0),
  .IS_RST_INVERTED(0),
  .SIM_DEVICE("ULTRASCALE_PLUS"),
  .SIM_VERSION(2.0)
)
u_ISERDESE3 (
  .FIFO_EMPTY(fifo_empty),
  .INTERNAL_DIVCLK(serdes_clk),
  .Q(serdes_data),

  .CLK(CLK_P),
  .CLKDIV(CLK_DIV),
  .CLK_B(CLK_N),
  .D(in_data),
  .FIFO_RD_CLK(DOUT_CLK),
  .FIFO_RD_EN(~fifo_empty),
  .RST(~RST_N)
);

assign DOUT_VALID = ~fifo_empty;

assign DOUT = serdes_data;
//assign DOUT_CLK = serdes_clk;

endmodule
