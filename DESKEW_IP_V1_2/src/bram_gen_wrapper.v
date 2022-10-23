//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
//Date        : Fri Aug 26 22:50:16 2022
//Host        : DESKTOP-K163ABD running 64-bit major release  (build 9200)
//Command     : generate_target bram_gen_wrapper.bd
//Design      : bram_gen_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module bram_gen_wrapper
   (BRAM_PORTA_0_addr,
    BRAM_PORTA_0_clk,
    BRAM_PORTA_0_din,
    BRAM_PORTA_0_dout,
    BRAM_PORTA_0_en,
    BRAM_PORTA_0_we);
  input [16:0]BRAM_PORTA_0_addr;
  input BRAM_PORTA_0_clk;
  input [7:0]BRAM_PORTA_0_din;
  output [7:0]BRAM_PORTA_0_dout;
  input BRAM_PORTA_0_en;
  input [0:0]BRAM_PORTA_0_we;

  wire [16:0]BRAM_PORTA_0_addr;
  wire BRAM_PORTA_0_clk;
  wire [7:0]BRAM_PORTA_0_din;
  wire [7:0]BRAM_PORTA_0_dout;
  wire BRAM_PORTA_0_en;
  wire [0:0]BRAM_PORTA_0_we;

  bram_gen bram_gen_i
       (.BRAM_PORTA_0_addr(BRAM_PORTA_0_addr),
        .BRAM_PORTA_0_clk(BRAM_PORTA_0_clk),
        .BRAM_PORTA_0_din(BRAM_PORTA_0_din),
        .BRAM_PORTA_0_dout(BRAM_PORTA_0_dout),
        .BRAM_PORTA_0_en(BRAM_PORTA_0_en),
        .BRAM_PORTA_0_we(BRAM_PORTA_0_we));
endmodule
