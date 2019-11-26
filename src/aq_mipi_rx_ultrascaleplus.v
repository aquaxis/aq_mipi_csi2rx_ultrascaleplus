module aq_mipi_rx_ultrascaleplus
(
  input         RST_N,

  input         MIPI_CLK_P,
  input         MIPI_CLK_N,

  input         MIPI_LANE0_P,
  input         MIPI_LANE0_N,
  input         MIPI_LANE1_P,
  input         MIPI_LANE1_N,

  input         LP_LANE0_P,
  input         LP_LANE0_N,
  input         LP_LANE1_P,
  input         LP_LANE1_N,

  output        MIPI_CLK,
  output [15:0] PIXEL_NUM,
  output [15:0] LINE_NUM,
  output        DETECT,
  output        FS,
  output        FE,
  output [7:0]  L0,
  output [7:0]  L1,
  output [15:0] DET_D0,
  output [15:0] DET_D1,

  output [7:0]  MIPI_LANE0,
  output [7:0]  MIPI_LANE1,

  output        MIPI_FSYNC,

  output        AXIS_TCLK,
  output [31:0] AXIS_TDATA,
  output        AXIS_TKEEP,
  output        AXIS_TLAST,
  input         AXIS_TREADY,
  output [3:0]  AXIS_TSTRB,
  output        AXIS_TVALID,

  output [31:0] DEBUG
);

  wire [7:0]  data_l0, data_l1;
  wire        clk_div, clk_bit, data_clk;

  wire        mipi_fsync;
  wire        mipi_valid;
  wire [31:0] mipi_data;

  csi_rx_clk_phy u_csi_rx_clk_phy(
    .RST_N      ( RST_N       ),

    .MIPI_CLK_P ( MIPI_CLK_P  ),
    .MIPI_CLK_N ( MIPI_CLK_N  ),

    .CLK_BIT    ( clk_bit     ),
    .CLK_DIV    ( clk_div     ),
    .CLK_BYTE   ( data_clk    )
  );

  csi_rx_lane_phy u_csi_rx_lane0_phy(
    .RST_N      ( RST_N         ),

    .CLK_P      ( clk_bit       ),
    .CLK_N      ( ~clk_bit      ),

    .CLK_DIV    ( data_clk      ),

    .DIN_P      ( MIPI_LANE0_P  ),
    .DIN_N      ( MIPI_LANE0_N  ),

    .DOUT_CLK   ( data_clk      ),
    .DOUT_VALID (),
    .DOUT       ( data_l0       )
  );

  csi_rx_lane_phy u_csi_rx_lane1_phy(
    .RST_N      ( RST_N         ),

    .CLK_P      ( clk_bit       ),
    .CLK_N      ( ~clk_bit      ),

    .CLK_DIV    ( data_clk      ),

    .DIN_P      ( MIPI_LANE1_P  ),
    .DIN_N      ( MIPI_LANE1_N  ),

    .DOUT_CLK   ( data_clk      ),
    .DOUT_VALID (),
    .DOUT       ( data_l1       )
  );

  csi_rx_word_align u_csi_rx_word_align(
    .RST_N      ( RST_N       ),
    .CLK        ( data_clk    ),

    .DIN0       ( data_l0     ),
    .DIN1       ( data_l1     ),

    .FSYNC      ( mipi_fsync  ),

    .VALID      ( mipi_valid  ),
    .DOUT       ( mipi_data   ),

    .DETECT     ( DETECT      ),
    .FS         ( FS          ),
    .FE         ( FE          ),
    .L0         ( L0          ),
    .L1         ( L1          ),
    .DET_D0     ( DET_D0      ),
    .DET_D1     ( DET_D1      ),
    .PIXEL_NUM  ( PIXEL_NUM   ),
    .LINE_NUM   ( LINE_NUM    )
  );

  assign MIPI_LANE0   = data_l0;
  assign MIPI_LANE1   = data_l1;

  assign MIPI_FSYNC   = mipi_fsync;
  assign AXIS_TCLK    = data_clk;
  assign AXIS_TDATA   = mipi_data;
  assign AXIS_TKEEP   = 1'b0;
  assign AXIS_TLAST   = 1'b0;
  assign AXIS_TSTRB   = 4'hF;
  assign AXIS_TVALID  = mipi_valid;

  assign MIPI_CLK     = data_clk;

endmodule
