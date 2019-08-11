module csi_rx_10bit_unpack(
  input         RST_N,
  input         CLK,
  input         ENABLE,
  input [31:0]  DIN,
  input         DIN_VALID,
  output [39:0] DOUT,
  output        DOUT_VALID
);

always @(posedge CLK) begin
  if(!RST_N) begin
  end else begin
    if(ENABLE) begin
      if(DIN_VALID) begin
        case(byte_count_int)
        0: begin
          dout_int <= 0;
          dout_valid_int <= 0;
          bytes_int <= DIN;
          byte_count_int <= 0;
        end
        1: begin
          dout_int <= {DIN, bytes_int[7:0]};
          dout_valid_int <= 1;
          bytes_int <= 0;
          byte_count_int <= 0;
        end
        2: begin
          dout_int <= {DIN[23:0], bytes_int[15:0]};
          dout_valid_int <= 1;
          bytes_int <= {6'd0, DIN[31:24]};
          byte_count_int <= 1;
        end
        3: begin
          dout_int <= {DIN[15:0], bytes_int[23:0]};
          dout_valid_int <= 1;
          bytes_int <= {4'd0, DIN[31:16]};
          byte_count_int <= 2;
        end
        4: begin
        end
        default: begin
          dout_int <= {DIN[7:0], bytes_int[31:0]};
          dout_valid_int <= 1;
          bytes_int <= {2'd0, DIN[31:8]};
          byte_count_int <= 3;
        end
        endcase
      end else begin
        byte_count_int <= 0;
        dout_valid_int <= 0;
      end
      dout_unpacked[ 9: 0] <= {dout_int[ 7: 0], dout_int[33:32]};
      dout_unpacked[19:10] <= {dout_int[15: 8], dout_int[35:34]};
      dout_unpacked[29:20] <= {dout_int[23:16], dout_int[37:36]};
      dout_unpacked[39:30] <= {dout_int[31:24], dout_int[39:38]};
      dout_valid_up <= dout_valid_int;
      dout          <= dout_unpack;
      dout_valid    <= dout_valid_up;
    end
  end
end

endmodule
