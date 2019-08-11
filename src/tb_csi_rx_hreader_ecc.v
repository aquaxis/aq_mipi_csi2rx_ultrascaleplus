module tb_csi_rx_hdr_ecc;

reg [23:0] data;
wire [7:0] ecc;

initial begin
  data = 24'hFF_1E_00;
  #100;
  data = 24'hFF_78_00;
  #100;
  data = 24'h00_1E_FF;
  #100;
  data = 24'h00_78_FF;
  #100;
  data = 24'h01_F0_37;
  #100;
  data = 24'h0A_C2_12;
  #100;
  data = 24'hFF_87_00;
  #100;
  data = 24'h0C_D0_2A;
  #100;
end

csi_rx_header_ecc u_csi_rx_header_ecc(
  .DIN(data),
  .ECC(ecc)
);

endmodule

