module zybo_z7_mipi_top(
    DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    GPIO_0_tri_io,
    IIC_0_0_scl_io,
    IIC_0_0_sda_io,

    RST,

    MIPI_CLK_P,
    MIPI_CLK_N,

    MIPI_LANE0_P,
    MIPI_LANE0_N,
    MIPI_LANE1_P,
    MIPI_LANE1_N,

    LP_LANE0_P,
    LP_LANE0_N,
    LP_LANE1_P,
    LP_LANE1_N,

    HDMI_CLK_P,
    HDMI_CLK_N,

    HDMI_D0_P,
    HDMI_D0_N,
    HDMI_D1_P,
    HDMI_D1_N,
    HDMI_D2_P,
    HDMI_D2_N,

    LED

    );

  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  inout [1:0]GPIO_0_tri_io;
  inout IIC_0_0_scl_io;
  inout IIC_0_0_sda_io;

    input RST;

    input MIPI_CLK_P;
    input MIPI_CLK_N;

    input MIPI_LANE0_P;
    input MIPI_LANE0_N;
    input MIPI_LANE1_P;
    input MIPI_LANE1_N;

    input LP_LANE0_P;
    input LP_LANE0_N;
    input LP_LANE1_P;
    input LP_LANE1_N;

    output HDMI_CLK_P;
    output HDMI_CLK_N;

    output HDMI_D0_P;
    output HDMI_D0_N;
    output HDMI_D1_P;
    output HDMI_D1_N;
    output HDMI_D2_P;
    output HDMI_D2_N;

    output [3:0] LED;

    wire [7:0] data_l0, data_l1;

    wire clk_bit, clk_byte;
    
    wire [31:0] DEBUG;
    
    wire mipi_fsync;
    wire mipi_valid;
    wire [31:0] mipi_data;

ZYBO_Z7_wrapper u_ZYBO_Z7_wrapper(
    .DDR_addr(DDR_addr),
    .DDR_ba(DDR_ba),
    .DDR_cas_n(DDR_cas_n),
    .DDR_ck_n(DDR_ck_n),
    .DDR_ck_p(DDR_ck_p),
    .DDR_cke(DDR_cke),
    .DDR_cs_n(DDR_cs_n),
    .DDR_dm(DDR_dm),
    .DDR_dq(DDR_dq),
    .DDR_dqs_n(DDR_dqs_n),
    .DDR_dqs_p(DDR_dqs_p),
    .DDR_odt(DDR_odt),
    .DDR_ras_n(DDR_ras_n),
    .DDR_reset_n(DDR_reset_n),
    .DDR_we_n(DDR_we_n),
    .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
    .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
    .FIXED_IO_mio(FIXED_IO_mio),
    .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
    .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
    .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
    .DEBUG_0(DEBUG),
    .GPIO_0_tri_io(GPIO_0_tri_io),
    .HDMI_CLK_N(HDMI_CLK_N),
    .HDMI_CLK_P(HDMI_CLK_P),
    .HDMI_D0_N(HDMI_D0_N),
    .HDMI_D0_P(HDMI_D0_P),
    .HDMI_D1_N(HDMI_D1_N),
    .HDMI_D1_P(HDMI_D1_P),
    .HDMI_D2_N(HDMI_D2_N),
    .HDMI_D2_P(HDMI_D2_P),
    .IIC_0_0_scl_io(IIC_0_0_scl_io),
    .IIC_0_0_sda_io(IIC_0_0_sda_io),
    .I_AXIS_FSYNC(mipi_fsync),
    .I_AXIS_TCLK(clk_byte),
    .I_AXIS_tdata(mipi_data),
    .I_AXIS_tkeep(1'b0),
    .I_AXIS_tlast(1'b0),
    .I_AXIS_tready(),
    .I_AXIS_tstrb(4'hF),
    .I_AXIS_tvalid(mipi_valid),
    .MIPI_CLK(clk_byte),
    .MIPI_LANE0(data_l0),
    .MIPI_LANE0_LPD_N(LP_LANE0_N),
    .MIPI_LANE0_LPD_P(LP_LANE0_P),
    .MIPI_LANE1(data_l1),
    .MIPI_LANE1_LPD_N(LP_LANE1_N),
    .MIPI_LANE1_LPD_P(LP_LANE1_P)
);

wire RST_N;

assign RST_N = ~RST;


csi_rx_clk_phy u_csi_rx_clk_phy(
  .RST_N(RST_N),

  .MIPI_CLK_P(MIPI_CLK_P),
  .MIPI_CLK_N(MIPI_CLK_N),

  .CLK_BIT(clk_bit),
  .CLK_BYTE(clk_byte)

);

csi_rx_lane_phy u_csi_rx_lane0_phy(
  .RST_N(RST_N),

  .CLK_P(clk_bit),
  .CLK_N(~clk_bit),

  .CLK_BYTE(clk_byte),

  .DIN_P(MIPI_LANE0_P),
  .DIN_N(MIPI_LANE0_N),
  .DOUT(data_l0)
);

csi_rx_lane_phy u_csi_rx_lane1_phy(
  .RST_N(RST_N),

  .CLK_P(clk_bit),
  .CLK_N(~clk_bit),

  .CLK_BYTE(clk_byte),

  .DIN_P(MIPI_LANE1_P),
  .DIN_N(MIPI_LANE1_N),
  .DOUT(data_l1)
);

csi_rx_word_align u_csi_rx_word_align(
  .RST_N(RST_N),
  .CLK(clk_byte),

  .DIN0(data_l0),
  .DIN1(data_l1),

  .FSYNC(mipi_fsync),

  .VALID(mipi_valid),
  .DOUT(mipi_data)
);

/*
reg [31:0] count_bit, count_byte;
reg state_bit, state_byte;

always @(posedge clk_bit or negedge RST_N) begin
  if(!RST_N) begin
    count_bit <= 0;
    state_bit <= 0;
  end else begin
    if(count_bit >= 600000000) begin
      count_bit <= 0;
      state_bit <= ~state_bit;
    end else begin
      count_bit <= count_bit + 1;
    end
  end
end
*/

reg [31:0] count_byte;
reg state_byte;

always @(posedge clk_byte or negedge RST_N) begin
  if(!RST_N) begin
    count_byte <= 0;
    state_byte <= 0;
  end else begin
    if(count_byte >= 100000000) begin
      count_byte <= 0;
      state_byte <= ~state_byte;
    end else begin
      count_byte <= count_byte + 1;
    end
  end
end

assign LED[3] = state_byte;
assign LED[2] = DEBUG[1];
assign LED[1] = DEBUG[0];
assign LED[0] = 1;

endmodule
