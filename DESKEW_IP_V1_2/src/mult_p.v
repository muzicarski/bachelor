//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
//Date        : Wed Sep 21 17:36:18 2022
//Host        : DESKTOP-K163ABD running 64-bit major release  (build 9200)
//Command     : generate_target mult_p.bd
//Design      : mult_p
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "mult_p,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=mult_p,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "mult_p.hwdef" *) 
module mult_p
   (A_0,
    B_0,
    CE_0,
    CLK_0,
    P_0);
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.A_0 DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.A_0, LAYERED_METADATA undef" *) input [8:0]A_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.B_0 DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.B_0, LAYERED_METADATA undef" *) input [8:0]B_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clockenable:1.0 CE.CE_0 CE" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CE.CE_0, POLARITY ACTIVE_HIGH" *) input CE_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_0, CLK_DOMAIN mult_p_CLK_0, FREQ_HZ 10000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input CLK_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.P_0 DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.P_0, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {DATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value data} bitwidth {attribs {resolve_type generated dependency bitwidth format long minimum {} maximum {}} value 18} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} integer {signed {attribs {resolve_type generated dependency signed format bool minimum {} maximum {}} value TRUE}}}} DATA_WIDTH 18}" *) output [17:0]P_0;

  wire [8:0]A_0_1;
  wire [8:0]B_0_1;
  wire CE_0_1;
  wire CLK_0_1;
  wire [17:0]mult_gen_0_P;

  assign A_0_1 = A_0[8:0];
  assign B_0_1 = B_0[8:0];
  assign CE_0_1 = CE_0;
  assign CLK_0_1 = CLK_0;
  assign P_0[17:0] = mult_gen_0_P;
  mult_p_mult_gen_0_0 mult_gen_0
       (.A(A_0_1),
        .B(B_0_1),
        .CE(CE_0_1),
        .CLK(CLK_0_1),
        .P(mult_gen_0_P));
endmodule
