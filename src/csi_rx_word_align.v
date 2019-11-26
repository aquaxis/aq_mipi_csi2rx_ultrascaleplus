module csi_rx_word_align(
  input         RST_N,
  input         CLK,

  input [7:0]   DIN0,
  input [7:0]   DIN1,

  output        FSYNC,

  output        VALID,
  output [31:0] DOUT,

  output        DETECT,
  output        FS,
  output        FE,
  output [7:0]  L0,
  output [7:0]  L1,
  output [15:0] DET_D0,
  output [15:0] DET_D1,
  output [15:0] PIXEL_NUM,
  output [15:0] LINE_NUM
);

reg [31:0] reg_d0_pre, reg_d1_pre;
reg [15:0] det_d0_pre, det_d1_pre;

// Buffer
always @(posedge CLK) begin
  if(!RST_N) begin
    reg_d0_pre[31: 0] <= 32'd0;
    reg_d1_pre[31: 0] <= 32'd0;
  end else begin
    reg_d0_pre[31:0] <= {DIN0[7:0], reg_d0_pre[31:8]};
    reg_d1_pre[31:0] <= {DIN1[7:0], reg_d1_pre[31:8]};
  end
end

// SoT Detect LANE0
always @(posedge CLK) begin
  if(!RST_N) begin
    det_d0_pre <= 16'd0;
  end else begin
    if(reg_d0[15:0] == 16'b1011_1000_0000_0000)       det_d0_pre <= 16'h0001;
    else if(reg_d0[16:1] == 16'b1011_1000_0000_0000)  det_d0_pre <= 16'h0002;
    else if(reg_d0[17:2] == 16'b1011_1000_0000_0000)  det_d0_pre <= 16'h0004;
    else if(reg_d0[18:3] == 16'b1011_1000_0000_0000)  det_d0_pre <= 16'h0008;
    else if(reg_d0[19:4] == 16'b1011_1000_0000_0000)  det_d0_pre <= 16'h0010;
    else if(reg_d0[20:5] == 16'b1011_1000_0000_0000)  det_d0_pre <= 16'h0020;
    else if(reg_d0[21:6] == 16'b1011_1000_0000_0000)  det_d0_pre <= 16'h0040;
    else if(reg_d0[22:7] == 16'b1011_1000_0000_0000)  det_d0_pre <= 16'h0080;
    else if(reg_d0[23:8] == 16'b1011_1000_0000_0000)  det_d0_pre <= 16'h0100;
    else if(reg_d0[24:9] == 16'b1011_1000_0000_0000)  det_d0_pre <= 16'h0200;
    else if(reg_d0[25:10] == 16'b1011_1000_0000_0000) det_d0_pre <= 16'h0400;
    else if(reg_d0[26:11] == 16'b1011_1000_0000_0000) det_d0_pre <= 16'h0800;
    else if(reg_d0[27:12] == 16'b1011_1000_0000_0000) det_d0_pre <= 16'h1000;
    else if(reg_d0[28:13] == 16'b1011_1000_0000_0000) det_d0_pre <= 16'h2000;
    else if(reg_d0[29:14] == 16'b1011_1000_0000_0000) det_d0_pre <= 16'h4000;
    else if(reg_d0[30:15] == 16'b1011_1000_0000_0000) det_d0_pre <= 16'h8000;
    else det_d0_pre <= 16'd0;
  end
end

// SoT Detect LANE1
always @(posedge CLK) begin
  if(!RST_N) begin
    det_d1_pre <= 16'd0;
  end else begin
    if(reg_d1[15:0] == 16'b1011_1000_0000_0000)       det_d1_pre <= 16'h0001;
    else if(reg_d1[16:1] == 16'b1011_1000_0000_0000)  det_d1_pre <= 16'h0002;
    else if(reg_d1[17:2] == 16'b1011_1000_0000_0000)  det_d1_pre <= 16'h0004;
    else if(reg_d1[18:3] == 16'b1011_1000_0000_0000)  det_d1_pre <= 16'h0008;
    else if(reg_d1[19:4] == 16'b1011_1000_0000_0000)  det_d1_pre <= 16'h0010;
    else if(reg_d1[20:5] == 16'b1011_1000_0000_0000)  det_d1_pre <= 16'h0020;
    else if(reg_d1[21:6] == 16'b1011_1000_0000_0000)  det_d1_pre <= 16'h0040;
    else if(reg_d1[22:7] == 16'b1011_1000_0000_0000)  det_d1_pre <= 16'h0080;
    else if(reg_d1[23:8] == 16'b1011_1000_0000_0000)  det_d1_pre <= 16'h0100;
    else if(reg_d1[24:9] == 16'b1011_1000_0000_0000)  det_d1_pre <= 16'h0200;
    else if(reg_d1[25:10] == 16'b1011_1000_0000_0000) det_d1_pre <= 16'h0400;
    else if(reg_d1[26:11] == 16'b1011_1000_0000_0000) det_d1_pre <= 16'h0800;
    else if(reg_d1[27:12] == 16'b1011_1000_0000_0000) det_d1_pre <= 16'h1000;
    else if(reg_d1[28:13] == 16'b1011_1000_0000_0000) det_d1_pre <= 16'h2000;
    else if(reg_d1[29:14] == 16'b1011_1000_0000_0000) det_d1_pre <= 16'h4000;
    else if(reg_d1[30:15] == 16'b1011_1000_0000_0000) det_d1_pre <= 16'h8000;
    else det_d1_pre <= 16'd0;
  end
end

reg [31:0] reg_d0, reg_d1;
reg [15:0] det_d0, det_d1;
reg        det_sot;

always @(posedge CLK) begin
  if(!RST_N) begin
    reg_d0 <= 32'd0;
    reg_d1 <= 32'd0;
    det_d0 <= 16'd0;
    det_d1 <= 16'd0;
    det_sot <= 1'b0;
  end else begin
    reg_d0 <= reg_d0_pre;
    reg_d1 <= reg_d1_pre;
    if((det_d0_pre != 16'd0) && (det_d1_pre != 16'd0)) begin
      det_d0  <= det_d0_pre;
      det_d1  <= det_d1_pre;
      det_sot <= 1'b1;
    end else begin
      det_sot <= 1'b0;
    end
  end
end

reg [31:0] reg_d0_buf, reg_d1_buf;

always @(posedge CLK) begin
  if(!RST_N) begin
    reg_d0_buf <= 32'd0;
    reg_d1_buf <= 32'd0;
  end else begin
    reg_d0_buf <= reg_d0;
    reg_d1_buf <= reg_d1;
  end
end


reg [7:0] align_d0, align_d1;

// Word align LANE0
always @(posedge CLK) begin
  if(!RST_N) begin
    align_d0[7:0] <= 8'd0;
  end else begin
    case(det_d0)
      16'h0001: align_d0[7:0] <= reg_d0_buf[15:8];
      16'h0002: align_d0[7:0] <= reg_d0_buf[16:9];
      16'h0004: align_d0[7:0] <= reg_d0_buf[17:10];
      16'h0008: align_d0[7:0] <= reg_d0_buf[18:11];
      16'h0010: align_d0[7:0] <= reg_d0_buf[19:12];
      16'h0020: align_d0[7:0] <= reg_d0_buf[20:13];
      16'h0040: align_d0[7:0] <= reg_d0_buf[21:14];
      16'h0080: align_d0[7:0] <= reg_d0_buf[22:15];
      16'h0100: align_d0[7:0] <= reg_d0_buf[23:16];
      16'h0200: align_d0[7:0] <= reg_d0_buf[24:17];
      16'h0400: align_d0[7:0] <= reg_d0_buf[25:18];
      16'h0800: align_d0[7:0] <= reg_d0_buf[26:19];
      16'h1000: align_d0[7:0] <= reg_d0_buf[27:20];
      16'h2000: align_d0[7:0] <= reg_d0_buf[28:21];
      16'h4000: align_d0[7:0] <= reg_d0_buf[29:22];
      16'h8000: align_d0[7:0] <= reg_d0_buf[30:23];
    endcase
  end
end

// Word align LANE1
always @(posedge CLK) begin
  if(!RST_N) begin
    align_d1[7:0] <= 8'd0;
  end else begin
    case(det_d1)
      16'h0001: align_d1[7:0] <= reg_d1_buf[15:8];
      16'h0002: align_d1[7:0] <= reg_d1_buf[16:9];
      16'h0004: align_d1[7:0] <= reg_d1_buf[17:10];
      16'h0008: align_d1[7:0] <= reg_d1_buf[18:11];
      16'h0010: align_d1[7:0] <= reg_d1_buf[19:12];
      16'h0020: align_d1[7:0] <= reg_d1_buf[20:13];
      16'h0040: align_d1[7:0] <= reg_d1_buf[21:14];
      16'h0080: align_d1[7:0] <= reg_d1_buf[22:15];
      16'h0100: align_d1[7:0] <= reg_d1_buf[23:16];
      16'h0200: align_d1[7:0] <= reg_d1_buf[24:17];
      16'h0400: align_d1[7:0] <= reg_d1_buf[25:18];
      16'h0800: align_d1[7:0] <= reg_d1_buf[26:19];
      16'h1000: align_d1[7:0] <= reg_d1_buf[27:20];
      16'h2000: align_d1[7:0] <= reg_d1_buf[28:21];
      16'h4000: align_d1[7:0] <= reg_d1_buf[29:22];
      16'h8000: align_d1[7:0] <= reg_d1_buf[30:23];
    endcase
  end
end

reg reg_sot_pre;
reg [31:0] align_data;

always @(posedge CLK) begin
  if(!RST_N) begin
    reg_sot_pre <= 1'b0;
    align_data  <= 32'd0;
  end else begin
    reg_sot_pre <= det_sot;
    align_data  <= {align_d1[ 7:0], align_d0[ 7:0], align_data[31:16]};
  end
end

wire [31:0] wire_data;
wire [7:0] wire_ecc;

assign wire_data[31:0] = align_data;

csi_rx_header_ecc u_csi_rx_hdr_ecc(
  .DIN( wire_data[23:0] ),
  .ECC( wire_ecc[7:0]   )
);

reg data_ena;
reg data_count;
reg [15:0] frame_length, length, line, line_count;
reg reg_valid;
reg [31:0] reg_data;
reg reg_fsync;
reg reg_fsync_end;
reg reg_sot;

wire wire_valid;
wire wire_length_valid;

always @(posedge CLK) begin
  if(!RST_N) begin
    reg_fsync           <= 1'b0;
    reg_fsync_end       <= 1'b0;
    data_ena            <= 1'b0;
    data_count          <= 1'b0;
    frame_length[15:0]  <= 16'd0;
    reg_valid           <= 1'b0;
    reg_data[31:0]      <= 32'd0;
    length[15:0]        <= 16'd0;
    line_count[15:0]    <= 16'd0;
    line[15:0]          <= 16'd0;
    reg_sot             <= 1'b0;
  end else begin
    if(reg_sot_pre) begin
      reg_sot           <= 1'b1;
    end else if(reg_fsync | reg_fsync_end | data_ena) begin
      reg_sot           <= 1'b0;
    end
    
    if(reg_sot) begin
      if((wire_data[7:0] == 8'b0000_0000) && (wire_data[31:24] == wire_ecc[7:0])) begin
        // Frame Start
        reg_fsync         <= 1'b1;
        data_ena          <= 1'b0;
        data_count        <= 1'b0;
        line_count[15:0]  <= 16'd0;
        reg_sot           <= 1'b0;
      end else if((wire_data[7:0] == 8'b0000_0001) && (wire_data[31:24] == wire_ecc[7:0])) begin
        // Frame End
        reg_fsync_end     <= 1'b1;
        data_ena          <= 1'b0;
        data_count        <= 1'b0;
        line[15:0]        <= line_count[15:0];
        reg_sot           <= 1'b0;
      end else if(((wire_data[7:0] == 8'b0010_1010) || (wire_data[7:0] == 8'b0010_1011)) && 
      (wire_data[31:24] == wire_ecc[7:0])) begin
        // Image Data Start
        data_ena            <= 1'b1;
        data_count          <= 1'b0;
        frame_length[15:0]  <= wire_data[23:8];
        line_count[15:0]    <= line_count[15:0] + 16'd1;
        reg_sot             <= 1'b0;
      end 
    end else if((length[15:0] == 16'd0) && (wire_data[31:0] == 32'd0)) begin
      // Image Data End
      data_ena   <= 1'b0;
      data_count <= 1'b0;
    end else begin
      data_count    <= ~data_count;
      reg_fsync     <= 1'b0;
      reg_fsync_end <= 1'b0;
    end

    reg_valid       <= wire_valid;
    reg_data[31:0]  <= wire_data[31:0];

    // Pixel Length
    if((wire_data[7:0] == 8'b0010_1010) && (wire_data[31:24] == wire_ecc[7:0])) begin
      length[15:0] <= wire_data[23:8];
    end else if(wire_valid) begin
      if(wire_length_valid) begin
        if(length[15:0] >= 16'd4) begin
          length[15:0] <= length[15:0] - 16'd4;
        end else begin
          length[15:0] <= 16'd0;
        end
      end
    end
  end
end

assign wire_valid         = ((data_ena == 1'b1) && data_count)?1'b1:1'b0;
assign wire_length_valid  = (length[15:0] > 16'd0)?1'b1:1'b0;

assign FSYNC      = reg_fsync;
assign VALID      = (wire_length_valid)?reg_valid:1'b0;
assign DOUT[31:0] = reg_data[31:0];

assign DETECT          = det_sot;
assign DET_D0          = det_d0;
assign DET_D1          = det_d1;
assign PIXEL_NUM[15:0] = frame_length[15:0];
assign LINE_NUM[15:0]  = line[15:0];

assign FS = reg_fsync;
assign FE = reg_fsync_end;
assign L0 = align_d0;
assign L1 = align_d1;

endmodule
