//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
//Date        : Sun Aug 28 11:28:03 2022
//Host        : DESKTOP-K163ABD running 64-bit major release  (build 9200)
//Command     : generate_target divider_wrapper.bd
//Design      : divider_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module divider_wrapper
   (M_AXIS_DOUT_0_tdata,
    M_AXIS_DOUT_0_tuser,
    M_AXIS_DOUT_0_tvalid,
    S_AXIS_DIVIDEND_0_tdata,
    S_AXIS_DIVIDEND_0_tvalid,
    S_AXIS_DIVISOR_0_tdata,
    S_AXIS_DIVISOR_0_tvalid,
    aclk_0);
  output [31:0]M_AXIS_DOUT_0_tdata;
  output [0:0]M_AXIS_DOUT_0_tuser;
  output M_AXIS_DOUT_0_tvalid;
  input [31:0]S_AXIS_DIVIDEND_0_tdata;
  input S_AXIS_DIVIDEND_0_tvalid;
  input [31:0]S_AXIS_DIVISOR_0_tdata;
  input S_AXIS_DIVISOR_0_tvalid;
  input aclk_0;

  wire [31:0]M_AXIS_DOUT_0_tdata;
  wire [0:0]M_AXIS_DOUT_0_tuser;
  wire M_AXIS_DOUT_0_tvalid;
  wire [31:0]S_AXIS_DIVIDEND_0_tdata;
  wire S_AXIS_DIVIDEND_0_tvalid;
  wire [31:0]S_AXIS_DIVISOR_0_tdata;
  wire S_AXIS_DIVISOR_0_tvalid;
  wire aclk_0;

  divider divider_i
       (.M_AXIS_DOUT_0_tdata(M_AXIS_DOUT_0_tdata),
        .M_AXIS_DOUT_0_tuser(M_AXIS_DOUT_0_tuser),
        .M_AXIS_DOUT_0_tvalid(M_AXIS_DOUT_0_tvalid),
        .S_AXIS_DIVIDEND_0_tdata(S_AXIS_DIVIDEND_0_tdata),
        .S_AXIS_DIVIDEND_0_tvalid(S_AXIS_DIVIDEND_0_tvalid),
        .S_AXIS_DIVISOR_0_tdata(S_AXIS_DIVISOR_0_tdata),
        .S_AXIS_DIVISOR_0_tvalid(S_AXIS_DIVISOR_0_tvalid),
        .aclk_0(aclk_0));
endmodule
