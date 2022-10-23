//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
//Date        : Thu Sep  1 20:04:40 2022
//Host        : DESKTOP-K163ABD running 64-bit major release  (build 9200)
//Command     : generate_target signed_fixed_point_mult_wrapper.bd
//Design      : signed_fixed_point_mult_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module signed_fixed_point_mult_wrapper
   (A_0,
    B_0,
    CLK_0,
    P_0);
  input [12:0]A_0;
  input [12:0]B_0;
  input CLK_0;
  output [25:0]P_0;

  wire [12:0]A_0;
  wire [12:0]B_0;
  wire CLK_0;
  wire [25:0]P_0;

  signed_fixed_point_mult signed_fixed_point_mult_i
       (.A_0(A_0),
        .B_0(B_0),
        .CLK_0(CLK_0),
        .P_0(P_0));
endmodule
