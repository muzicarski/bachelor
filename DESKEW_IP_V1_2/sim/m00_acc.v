//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
//Date        : Sun Aug 28 20:52:01 2022
//Host        : DESKTOP-K163ABD running 64-bit major release  (build 9200)
//Command     : generate_target m00_acc.bd
//Design      : m00_acc
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "m00_acc,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=m00_acc,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "m00_acc.hwdef" *) 
module m00_acc
   (BYPASS_0,
    B_0,
    CE_0,
    CLK_0,
    Q_0,
    SCLR_0);
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.BYPASS_0 DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.BYPASS_0, LAYERED_METADATA undef" *) input BYPASS_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.B_0 DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.B_0, LAYERED_METADATA undef" *) input [7:0]B_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clockenable:1.0 CE.CE_0 CE" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CE.CE_0, POLARITY ACTIVE_HIGH" *) input CE_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_0, ASSOCIATED_RESET SCLR_0, CLK_DOMAIN m00_acc_CLK_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input CLK_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.Q_0 DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.Q_0, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value data} bitwidth {attribs {resolve_type generated dependency bitwidth format long minimum {} maximum {}} value 29} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} integer {signed {attribs {resolve_type generated dependency signed format bool minimum {} maximum {}} value FALSE}}}} DATA_WIDTH 29}" *) output [28:0]Q_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.SCLR_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.SCLR_0, INSERT_VIP 0, POLARITY ACTIVE_HIGH" *) input SCLR_0;

  wire BYPASS_0_1;
  wire [7:0]B_0_1;
  wire CE_0_1;
  wire CLK_0_1;
  wire SCLR_0_1;
  wire [28:0]c_accum_0_Q;

  assign BYPASS_0_1 = BYPASS_0;
  assign B_0_1 = B_0[7:0];
  assign CE_0_1 = CE_0;
  assign CLK_0_1 = CLK_0;
  assign Q_0[28:0] = c_accum_0_Q;
  assign SCLR_0_1 = SCLR_0;
  m00_acc_c_accum_0_0 c_accum_0
       (.B(B_0_1),
        .BYPASS(BYPASS_0_1),
        .CE(CE_0_1),
        .CLK(CLK_0_1),
        .Q(c_accum_0_Q),
        .SCLR(SCLR_0_1));
endmodule
