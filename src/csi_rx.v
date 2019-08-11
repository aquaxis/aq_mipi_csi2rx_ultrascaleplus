module csi_rx(
  input RST,

  input MIPI_CLK_P,
  input MIPI_CLK_N,

  output [3:0] LED

);

wire RST_N;

assign RST_N = ~RST;

wire clk_bit, clk_byte;

csi_rx_clk_phy u_csi_rx_clk_phy(
  .RST_N(RST_N),

  .MIPI_CLK_P(MIPI_CLK_P),
  .MIPI_CLK_N(MIPI_CLK_N),

  .CLK_BIT(clk_bit),
  .CLK_BYTE(clk_byte)

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
assign LED[2] = 0;
assign LED[1] = 0;
assign LED[0] = 1;

endmodule
