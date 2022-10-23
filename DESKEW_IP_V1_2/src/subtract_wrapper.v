//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
//Date        : Sun Aug 28 15:26:54 2022
//Host        : DESKTOP-K163ABD running 64-bit major release  (build 9200)
//Command     : generate_target subtract_wrapper.bd
//Design      : subtract_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module subtract_wrapper
   (A_0,
    B_0,
    CE_0,
    CLK_0,
    S_0);
  input [12:0]A_0;
  input [12:0]B_0;
  input CE_0;
  input CLK_0;
  output [12:0]S_0;

  wire [12:0]A_0;
  wire [12:0]B_0;
  wire CE_0;
  wire CLK_0;
  wire [12:0]S_0;

  subtract subtract_i
       (.A_0(A_0),
        .B_0(B_0),
        .CE_0(CE_0),
        .CLK_0(CLK_0),
        .S_0(S_0));
endmodule
