`timescale 1ns / 1ps

module tb_csi_rx_word_align;

reg RST_N, CLK;

wire [7:0] DIN0, DIN1;

wire FSYNC;

wire VALID;

wire [31:0] DOUT;

always #(10) CLK = ~CLK;

initial begin
  #0;
  RST_N = 0;
  CLK = 0;
  #100;
  RST_N = 1;

  @(posedge CLK);
end

csi_rx_word_align u_csi_rx_word_align(
  .RST_N(RST_N),
  .CLK(CLK),

  .DIN0(DIN0),
  .DIN1(DIN1),

  .FSYNC(FSYNC),

  .VALID(VALID),
  .DOUT(DOUT)
);

integer count;
always @(posedge CLK or negedge RST_N) begin
  if(!RST_N) begin
    count <= 0;
  end else begin
    count <= count +1;
  end
end

function [15:0] DATA (input integer c);
 begin
  if(c < 12) begin
    case(c)
    0: DATA = 16'h0000;
    1: DATA = 16'h0000;
    2: DATA = 16'h0000;
    3: DATA = 16'h0000;
    4: DATA = 16'hB8AE;
    5: DATA = 16'hD00A;
    6: DATA = 16'h3CC3;
    7: DATA = 16'h1406;
    8: DATA = 16'h1407;
    9: DATA = 16'h1407;
    10: DATA = 16'h1407;
    11: DATA = 16'h1407;
    12: DATA = 16'h1407;
    default: DATA = 16'h0000;
    endcase
  end else if(c < 1800) begin
    DATA = 16'h1407;
  end else begin
    DATA = 16'h0000;
  end
end
endfunction

wire [15:0] preDATA;

assign preDATA = DATA(count);
assign DIN0 = preDATA[ 7:0];
assign DIN1 = preDATA[15:8];

/*
40001A60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40001A70: 00 00 00 00 00 00 00 00 AE B8 00 00 0A D0 00 00
40001A80: C3 3C 00 00 06 14 00 00 07 14 00 00 07 14 00 00
40001A90: 07 14 00 00 07 14 00 00 47 14 00 00 07 14 00 00
40001AA0: 07 15 00 00 07 15 00 00 47 14 00 00 C7 15 00 00
*/

endmodule
