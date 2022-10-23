//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
//Date        : Fri Sep  2 12:22:13 2022
//Host        : DESKTOP-K163ABD running 64-bit major release  (build 9200)
//Command     : generate_target skew_divider.bd
//Design      : skew_divider
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "skew_divider,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=skew_divider,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "skew_divider.hwdef" *) 
module skew_divider
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
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_DOUT_0 TDATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXIS_DOUT_0, CLK_DOMAIN skew_divider_aclk_0, FREQ_HZ 1000000, HAS_TKEEP 0, HAS_TLAST 0, HAS_TREADY 0, HAS_TSTRB 0, INSERT_VIP 0, LAYERED_METADATA xilinx.com:interface:datatypes:1.0 {TDATA {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type automatic dependency {} format long minimum {} maximum {}} value 42} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} struct {field_fractional {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value fractional} enabled {attribs {resolve_type generated dependency fract_enabled format bool minimum {} maximum {}} value true} datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type generated dependency fract_width format long minimum {} maximum {}} value 9} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type generated dependency fract_remainder_fractwidth format long minimum {} maximum {}} value 9} signed {attribs {resolve_type generated dependency fract_remainder_signed format bool minimum {} maximum {}} value false}}}}} field_remainder {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value remainder} enabled {attribs {resolve_type generated dependency remainder_enabled format bool minimum {} maximum {}} value false} datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type generated dependency remainder_width format long minimum {} maximum {}} value 0} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} real {fixed {fractwidth {attribs {resolve_type generated dependency fract_remainder_fractwidth format long minimum {} maximum {}} value 9} signed {attribs {resolve_type generated dependency fract_remainder_signed format bool minimum {} maximum {}} value false}}}}} field_quotient {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value quotient} enabled {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value true} datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type generated dependency quotient_width format long minimum {} maximum {}} value 33} bitoffset {attribs {resolve_type generated dependency quotient_offset format long minimum {} maximum {}} value 9} integer {signed {attribs {resolve_type generated dependency quotient_signed format bool minimum {} maximum {}} value true}}}}}}} TDATA_WIDTH 48 TUSER {datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type automatic dependency {} format long minimum {} maximum {}} value 0} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0} struct {field_divide_by_zero {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value divide_by_zero} enabled {attribs {resolve_type generated dependency divbyzero_enabled format bool minimum {} maximum {}} value false} datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type generated dependency divbyzero_width format long minimum {} maximum {}} value 0} bitoffset {attribs {resolve_type immediate dependency {} format long minimum {} maximum {}} value 0}}} field_divisor_tuser {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value divisor_tuser} enabled {attribs {resolve_type generated dependency divisor_enabled format bool minimum {} maximum {}} value false} datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type generated dependency divisor_width format long minimum {} maximum {}} value 0} bitoffset {attribs {resolve_type generated dependency divisor_offset format long minimum {} maximum {}} value 0} integer {signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value false}}}} field_dividend_tuser {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value dividend_tuser} enabled {attribs {resolve_type generated dependency dividend_enabled format bool minimum {} maximum {}} value false} datatype {name {attribs {resolve_type immediate dependency {} format string minimum {} maximum {}} value {}} bitwidth {attribs {resolve_type generated dependency dividend_width format long minimum {} maximum {}} value 0} bitoffset {attribs {resolve_type generated dependency dividend_offset format long minimum {} maximum {}} value 0} integer {signed {attribs {resolve_type immediate dependency {} format bool minimum {} maximum {}} value false}}}}}}} TUSER_WIDTH 0}, PHASE 0.0, TDATA_NUM_BYTES 6, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0" *) output [47:0]M_AXIS_DOUT_0_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS_DOUT_0 TVALID" *) output M_AXIS_DOUT_0_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_DIVIDEND_0 TDATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXIS_DIVIDEND_0, CLK_DOMAIN skew_divider_aclk_0, FREQ_HZ 1000000, HAS_TKEEP 0, HAS_TLAST 0, HAS_TREADY 1, HAS_TSTRB 0, INSERT_VIP 0, LAYERED_METADATA undef, PHASE 0.0, TDATA_NUM_BYTES 5, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0" *) input [39:0]S_AXIS_DIVIDEND_0_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_DIVIDEND_0 TREADY" *) output S_AXIS_DIVIDEND_0_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_DIVIDEND_0 TVALID" *) input S_AXIS_DIVIDEND_0_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_DIVISOR_0 TDATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXIS_DIVISOR_0, CLK_DOMAIN skew_divider_aclk_0, FREQ_HZ 1000000, HAS_TKEEP 0, HAS_TLAST 0, HAS_TREADY 1, HAS_TSTRB 0, INSERT_VIP 0, LAYERED_METADATA undef, PHASE 0.0, TDATA_NUM_BYTES 5, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0" *) input [39:0]S_AXIS_DIVISOR_0_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_DIVISOR_0 TREADY" *) output S_AXIS_DIVISOR_0_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 S_AXIS_DIVISOR_0 TVALID" *) input S_AXIS_DIVISOR_0_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.ACLK_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.ACLK_0, ASSOCIATED_BUSIF S_AXIS_DIVIDEND_0:M_AXIS_DOUT_0:S_AXIS_DIVISOR_0, CLK_DOMAIN skew_divider_aclk_0, FREQ_HZ 1000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input aclk_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clockenable:1.0 CE.ACLKEN_0 CE" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CE.ACLKEN_0, POLARITY ACTIVE_HIGH" *) input aclken_0;

  wire [39:0]S_AXIS_DIVIDEND_0_1_TDATA;
  wire S_AXIS_DIVIDEND_0_1_TREADY;
  wire S_AXIS_DIVIDEND_0_1_TVALID;
  wire [39:0]S_AXIS_DIVISOR_0_1_TDATA;
  wire S_AXIS_DIVISOR_0_1_TREADY;
  wire S_AXIS_DIVISOR_0_1_TVALID;
  wire aclk_0_1;
  wire aclken_0_1;
  wire [47:0]div_gen_0_M_AXIS_DOUT_TDATA;
  wire div_gen_0_M_AXIS_DOUT_TVALID;

  assign M_AXIS_DOUT_0_tdata[47:0] = div_gen_0_M_AXIS_DOUT_TDATA;
  assign M_AXIS_DOUT_0_tvalid = div_gen_0_M_AXIS_DOUT_TVALID;
  assign S_AXIS_DIVIDEND_0_1_TDATA = S_AXIS_DIVIDEND_0_tdata[39:0];
  assign S_AXIS_DIVIDEND_0_1_TVALID = S_AXIS_DIVIDEND_0_tvalid;
  assign S_AXIS_DIVIDEND_0_tready = S_AXIS_DIVIDEND_0_1_TREADY;
  assign S_AXIS_DIVISOR_0_1_TDATA = S_AXIS_DIVISOR_0_tdata[39:0];
  assign S_AXIS_DIVISOR_0_1_TVALID = S_AXIS_DIVISOR_0_tvalid;
  assign S_AXIS_DIVISOR_0_tready = S_AXIS_DIVISOR_0_1_TREADY;
  assign aclk_0_1 = aclk_0;
  assign aclken_0_1 = aclken_0;
  skew_divider_div_gen_0_0 div_gen_0
       (.aclk(aclk_0_1),
        .aclken(aclken_0_1),
        .m_axis_dout_tdata(div_gen_0_M_AXIS_DOUT_TDATA),
        .m_axis_dout_tvalid(div_gen_0_M_AXIS_DOUT_TVALID),
        .s_axis_dividend_tdata(S_AXIS_DIVIDEND_0_1_TDATA),
        .s_axis_dividend_tready(S_AXIS_DIVIDEND_0_1_TREADY),
        .s_axis_dividend_tvalid(S_AXIS_DIVIDEND_0_1_TVALID),
        .s_axis_divisor_tdata(S_AXIS_DIVISOR_0_1_TDATA),
        .s_axis_divisor_tready(S_AXIS_DIVISOR_0_1_TREADY),
        .s_axis_divisor_tvalid(S_AXIS_DIVISOR_0_1_TVALID));
endmodule
