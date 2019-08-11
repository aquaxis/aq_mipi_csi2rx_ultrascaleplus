module csi_rx_header_ecc(
  input [23:0]  DIN,
  output [7:0]  ECC
);

  assign ECC[7] = 0;
  assign ECC[6] = 0;
  assign ECC[5] = DIN[10] ^ DIN[11] ^ DIN[12] ^ DIN[13] ^ DIN[14] ^ DIN[15] ^ DIN[16] ^ DIN[17] ^ DIN[18] ^ DIN[19] ^ DIN[21] ^ DIN[22] ^ DIN[23];
  assign ECC[4] = DIN[4]  ^ DIN[5]  ^ DIN[6]  ^ DIN[7]  ^ DIN[8]  ^ DIN[9]  ^ DIN[16] ^ DIN[17] ^ DIN[18] ^ DIN[19] ^ DIN[20] ^ DIN[22] ^ DIN[23];
  assign ECC[3] = DIN[1]  ^ DIN[2]  ^ DIN[3]  ^ DIN[7]  ^ DIN[8]  ^ DIN[9]  ^ DIN[13] ^ DIN[14] ^ DIN[15] ^ DIN[19] ^ DIN[20] ^ DIN[21] ^ DIN[23];
  assign ECC[2] = DIN[0]  ^ DIN[2]  ^ DIN[3]  ^ DIN[5]  ^ DIN[6]  ^ DIN[9]  ^ DIN[11] ^ DIN[12] ^ DIN[15] ^ DIN[18] ^ DIN[20] ^ DIN[21] ^ DIN[22];
  assign ECC[1] = DIN[0]  ^ DIN[1]  ^ DIN[3]  ^ DIN[4]  ^ DIN[6]  ^ DIN[8]  ^ DIN[10] ^ DIN[12] ^ DIN[14] ^ DIN[17] ^ DIN[20] ^ DIN[21] ^ DIN[22] ^ DIN[23];
  assign ECC[0] = DIN[0]  ^ DIN[1]  ^ DIN[2]  ^ DIN[4]  ^ DIN[5]  ^ DIN[7]  ^ DIN[10] ^ DIN[11] ^ DIN[13] ^ DIN[16] ^ DIN[20] ^ DIN[21] ^ DIN[22] ^ DIN[23];

endmodule
