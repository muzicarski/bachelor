//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2.1 (win64) Build 2729669 Thu Dec  5 04:49:17 MST 2019
//Date        : Wed Sep 14 13:42:25 2022
//Host        : SAMISKO running 64-bit major release  (build 9200)
//Command     : generate_target mult_p_wrapper.bd
//Design      : mult_p_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module mult_p_wrapper
   (A_0,
    B_0,
    CE_0,
    CLK_0,
    P_0);
  input [8:0]A_0;
  input [8:0]B_0;
  input CE_0;
  input CLK_0;
  output [17:0]P_0;

  wire [8:0]A_0;
  wire [8:0]B_0;
  wire CE_0;
  wire CLK_0;
  wire [17:0]P_0;

  mult_p mult_p_i
       (.A_0(A_0),
        .B_0(B_0),
        .CE_0(CE_0),
        .CLK_0(CLK_0),
        .P_0(P_0));
endmodule
