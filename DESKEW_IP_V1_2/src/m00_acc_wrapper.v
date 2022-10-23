//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
//Date        : Sat Aug 27 15:46:55 2022
//Host        : DESKTOP-K163ABD running 64-bit major release  (build 9200)
//Command     : generate_target m00_acc_wrapper.bd
//Design      : m00_acc_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module m00_acc_wrapper
   (BYPASS_0,
    B_0,
    CE_0,
    CLK_0,
    Q_0,
    SCLR_0);
  input BYPASS_0;
  input [7:0]B_0;
  input CE_0;
  input CLK_0;
  output [28:0]Q_0;
  input SCLR_0;

  wire BYPASS_0;
  wire [7:0]B_0;
  wire CE_0;
  wire CLK_0;
  wire [28:0]Q_0;
  wire SCLR_0;

  m00_acc m00_acc_i
       (.BYPASS_0(BYPASS_0),
        .B_0(B_0),
        .CE_0(CE_0),
        .CLK_0(CLK_0),
        .Q_0(Q_0),
        .SCLR_0(SCLR_0));
endmodule
