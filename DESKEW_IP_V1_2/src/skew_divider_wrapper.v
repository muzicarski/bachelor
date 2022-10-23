//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
//Date        : Fri Sep  2 12:19:13 2022
//Host        : DESKTOP-K163ABD running 64-bit major release  (build 9200)
//Command     : generate_target skew_divider_wrapper.bd
//Design      : skew_divider_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module skew_divider_wrapper
   (M_AXIS_DOUT_0_tdata,
    M_AXIS_DOUT_0_tvalid,
    S_AXIS_DIVIDEND_0_tdata,
    S_AXIS_DIVIDEND_0_tready,
    S_AXIS_DIVIDEND_0_tvalid,
    S_AXIS_DIVISOR_0_tdata,
    S_AXIS_DIVISOR_0_tready,
    S_AXIS_DIVISOR_0_tvalid,
    aclk_0,
    aclken_0);
  output [47:0]M_AXIS_DOUT_0_tdata;
  output M_AXIS_DOUT_0_tvalid;
  input [39:0]S_AXIS_DIVIDEND_0_tdata;
  output S_AXIS_DIVIDEND_0_tready;
  input S_AXIS_DIVIDEND_0_tvalid;
  input [39:0]S_AXIS_DIVISOR_0_tdata;
  output S_AXIS_DIVISOR_0_tready;
  input S_AXIS_DIVISOR_0_tvalid;
  input aclk_0;
  input aclken_0;

  wire [47:0]M_AXIS_DOUT_0_tdata;
  wire M_AXIS_DOUT_0_tvalid;
  wire [39:0]S_AXIS_DIVIDEND_0_tdata;
  wire S_AXIS_DIVIDEND_0_tready;
  wire S_AXIS_DIVIDEND_0_tvalid;
  wire [39:0]S_AXIS_DIVISOR_0_tdata;
  wire S_AXIS_DIVISOR_0_tready;
  wire S_AXIS_DIVISOR_0_tvalid;
  wire aclk_0;
  wire aclken_0;

  skew_divider skew_divider_i
       (.M_AXIS_DOUT_0_tdata(M_AXIS_DOUT_0_tdata),
        .M_AXIS_DOUT_0_tvalid(M_AXIS_DOUT_0_tvalid),
        .S_AXIS_DIVIDEND_0_tdata(S_AXIS_DIVIDEND_0_tdata),
        .S_AXIS_DIVIDEND_0_tready(S_AXIS_DIVIDEND_0_tready),
        .S_AXIS_DIVIDEND_0_tvalid(S_AXIS_DIVIDEND_0_tvalid),
        .S_AXIS_DIVISOR_0_tdata(S_AXIS_DIVISOR_0_tdata),
        .S_AXIS_DIVISOR_0_tready(S_AXIS_DIVISOR_0_tready),
        .S_AXIS_DIVISOR_0_tvalid(S_AXIS_DIVISOR_0_tvalid),
        .aclk_0(aclk_0),
        .aclken_0(aclken_0));
endmodule
