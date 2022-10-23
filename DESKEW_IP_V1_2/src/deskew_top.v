`ifndef __DESKEW_TOP__
 `define __DESKEW_TOP__

module deskew_top(

		  //Sync:
		  clk,
		  resetn,

		  //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
		  //AXI LITE INTERFACE

		  //Write addr channel:
		  axis_waddr,
		  axis_waddr_valid,
		  axis_waddr_ready,

		  //Write data channel:
		  axis_wdata,
		  axis_wdata_valid,
		  axis_wdata_ready,

		  //Write response channel:
		  axis_bresp,
		  axis_bresp_valid,
		  axis_bresp_ready,

		  //Read addr channel:
		  axis_raddr,
		  axis_raddr_valid,
		  axis_raddr_ready,

		  //Read data channel:
		  axis_rdata,
		  axis_rdata_valid,
		  axis_rdata_ready,
		  axis_rresp,

		  //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
		  //Interrupts interface

		  //general IRQ port
		  deskew_irq,


		  //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
		  //BRAM interface:
		  //prefix "p" is short for "pixel",

          bram_clk,     //Out CLK
          bram_resetn,  //Out Reset
		  paddr,        //ADDRESS
		  pwdata,       //Write data
		  prdata,       //Read data
		  pen,          //MEM enable
		  pwen          //BYTE write strobe
		  );

   //Generics/parameters list:

   localparam			  REG_DATA_WIDTH = 32;
   localparam			  REG_ADDR_WIDTH = 8;
   
   localparam			  BRAM_ADDR_WIDTH = 17;
   localparam			  BRAM_DATA_WIDTH = 8;

   
   //Port list.

   //==============================//
   //        I N P U T S           //
   //==============================//

   //AXI LITE INTERFACE
   
   input			  clk;
   input			  resetn;

   input [REG_ADDR_WIDTH-1 : 0]	  axis_waddr;
   input			  axis_waddr_valid;

   input [REG_DATA_WIDTH-1 : 0]	  axis_wdata;
   input			  axis_wdata_valid;

   input			  axis_bresp_ready;

   input [REG_ADDR_WIDTH-1 : 0]	  axis_raddr;
   input			  axis_raddr_valid;

   input			  axis_rdata_ready;

   //BRAM INTERFACE

   input [BRAM_DATA_WIDTH-1 : 0]  prdata;

   //==============================//
   //       O U T P U T S          //
   //==============================//

   //AXI LITE INTERFACE

   output			  axis_waddr_ready;

   output			  axis_wdata_ready;
   
   output [1:0]			  axis_bresp;
   output			  axis_bresp_valid;

   output			  axis_raddr_ready;

   output [REG_DATA_WIDTH-1: 0]	  axis_rdata;
   output			  axis_rdata_valid;
   output [1:0]			  axis_rresp;

   //INTERRUPTS INTERFACE

   output			  deskew_irq;


   //BRAM INTERFACE
   output			  bram_clk;
   output			  bram_resetn;

   output [BRAM_ADDR_WIDTH-1 : 0] paddr;
   output [BRAM_DATA_WIDTH-1 : 0] pwdata;
   output			  pen;
   output			  pwen;

   //================================================================================//
   wire [8:0]			  x_cnt;
   wire [8:0]			  y_cnt;
   wire [8:0]			  x_cnt_xp;
   wire [8:0]			  y_cnt_xp;
   wire [14:0]			  xp_r;
   wire				  x_fifo_full;
   wire				  y_fifo_full;
   wire				  p_fifo_full;
   wire				  skew_vld_in;
   wire				  skew_dvd_rdy;
   wire				  skew_dvs_rdy;
   wire				  div_res_vld;
   wire [8:0]			  img_dim;
   wire [16:0]			  in_img_start_addr;
   wire [16:0]			  out_img_start_addr;
   wire				  sclr;
   wire				  x_fifo_wr;
   wire				  y_fifo_wr;
   wire				  bram_en;
   wire				  bram_wr;
   wire				  addr_gen_en;
   wire				  x_fifo_rd;
   wire				  y_fifo_rd;
   wire				  p_fifo_rd;
   wire				  m00_en;
   wire				  m01_en;
   wire				  m10_en;
   wire				  m00_r_en;
   wire				  m01_r_en;
   wire				  m10_r_en;
   wire				  div_sel;
   wire				  dividend_valid;
   wire				  divisor_valid;
   wire				  x_mc_en;
   wire				  y_mc_en;
   wire				  mu11_mac_enable_en;
   wire				  mu02_mac_enable_en;
   wire				  mu11_r_en;
   wire				  mu02_r_en;
   wire				  skew_dividend_vld;
   wire				  skew_divisor_vld;
   wire				  skew_r_en;
   wire				  m02_mult_en;
   wire				  m02_r_en;
   wire				  bram_addr_sel;
   wire				  xp_gen_en;
   wire				  xp_r_en;
   wire				  py_r_en;
   wire				  p2_addr_en;
   wire				  p1_addr_en;
   wire				  p_rd_addr_sel;
   wire				  calc_p1_addr_en;
   wire				  p1_r_en;
   wire				  p2_r_en;
   wire				  p_r_en;
   wire				  p_val_sel;
   wire				  img_addr_sel;
   wire				  sub_p1_p2_en;
   wire				  p_mult_en;
   wire				  dsqw_irq;

   //================================================================================//

   deskew_control_path#(.REG_ADDR_WIDTH(REG_ADDR_WIDTH))
    u_deskew_control_path (
  					     .clk(clk),
					     .rst_n(resetn),
   					     .x_cnt(x_cnt),
					     .y_cnt(y_cnt),
					     .x_cnt_xp(x_cnt_xp),
					     .y_cnt_xp(y_cnt_xp),
					     .xp_r(xp_r),
					     .x_fifo_full(x_fifo_full),
					     .y_fifo_full(y_fifo_full),
					     .p_fifo_full(p_fifo_full),
					     .skew_vld_in(skew_vld_in),
					     .skew_dvd_rdy(skew_dvd_rdy),
					     .skew_dvs_rdy(skew_dvs_rdy),
					     .div_res_vld(div_res_vld),
					     .img_dim(img_dim),
					     .in_img_start_addr(in_img_start_addr),
					     .out_img_start_addr(out_img_start_addr),
					     .sclr(sclr),
					     .x_fifo_wr(x_fifo_wr),
					     .y_fifo_wr(y_fifo_wr),
					     .bram_en(bram_en),
					     .bram_wr(bram_wr),
					     .addr_gen_en(addr_gen_en),
					     .x_fifo_rd(x_fifo_rd),
					     .y_fifo_rd(y_fifo_rd),
					     .p_fifo_rd(p_fifo_rd),
					     .m00_en(m00_en),
					     .m01_en(m01_en),
					     .m10_en(m10_en),
					     .m00_r_en(m00_r_en),
					     .m01_r_en(m01_r_en),
					     .m10_r_en(m10_r_en),
					     .div_sel(div_sel),
					     .dividend_valid(dividend_valid),
					     .divisor_valid(divisor_valid),
					     .x_mc_en(x_mc_en),
					     .y_mc_en(y_mc_en),
					     .mu11_mac_enable_en(mu11_mac_enable_en),
					     .mu02_mac_enable_en(mu02_mac_enable_en),
					     .mu11_r_en(mu11_r_en),
					     .mu02_r_en(mu02_r_en),
					     .skew_dividend_vld(skew_dividend_vld),
					     .skew_divisor_vld(skew_divisor_vld),
					     .skew_r_en(skew_r_en),
					     .m02_mult_en(m02_mult_en),
					     .m02_r_en(m02_r_en),
					     .bram_addr_sel(bram_addr_sel),
					     .xp_gen_en(xp_gen_en),
					     .xp_r_en(xp_r_en),
					     .py_r_en(py_r_en),
    					     .p2_addr_en(p2_addr_en),
					     .p1_addr_en(p1_addr_en),
					     .p_rd_addr_sel(p_rd_addr_sel),
					     .calc_p1_addr_en(calc_p1_addr_en),
					     .p1_r_en(p1_r_en),
					     .p2_r_en(p2_r_en),
					     .p_r_en(p_r_en),
					     .p_val_sel(p_val_sel),
					     .img_addr_sel(img_addr_sel),
					     .sub_p1_p2_en(sub_p1_p2_en),
					     .p_mult_en(p_mult_en),
      
					     .dsqw_irq(deskew_irq),
      
					     .axis_waddr_ready(axis_waddr_ready),
					     .axis_wdata_ready(axis_wdata_ready),
					     .axis_bresp(axis_bresp),
					     .axis_bresp_valid(axis_bresp_valid),
					     .axis_raddr_ready(axis_raddr_ready),
					     .axis_rdata(axis_rdata),
					     .axis_rdata_valid(axis_rdata_valid),
					     .axis_rresp(axis_rresp),
					     .axis_waddr(axis_waddr),
					     .axis_waddr_valid(axis_waddr_valid),
					     .axis_wdata(axis_wdata),
					     .axis_wdata_valid(axis_wdata_valid),
					     .axis_bresp_ready(axis_bresp_ready),
					     .axis_raddr(axis_raddr),
					     .axis_raddr_valid(axis_raddr_valid),
					     .axis_rdata_ready(axis_rdata_ready)
					     );
   

   deskew_datapath_top u_deskew_datapath_top(
					     .clk(clk),
					     .rst_n(resetn),
					     .img_dim(img_dim),
					     .in_img_start_addr(in_img_start_addr),
					     .out_img_start_addr(out_img_start_addr),
					     .sclr(sclr),
   					     .x_fifo_wr(x_fifo_wr),
					     .y_fifo_wr(y_fifo_wr),
					     .bram_en(bram_en),
					     .bram_wr(bram_wr),
					     .addr_gen_en(addr_gen_en),
					     .x_fifo_rd(x_fifo_rd),
					     .y_fifo_rd(y_fifo_rd),
					     .p_fifo_rd(p_fifo_rd),
					     .m00_en(m00_en),
					     .m01_en(m01_en),
					     .m10_en(m10_en),
					     .m00_r_en(m00_r_en),
					     .m01_r_en(m01_r_en),
					     .m10_r_en(m10_r_en),
					     .div_sel(div_sel),
					     .dividend_valid(dividend_valid),
					     .divisor_valid(divisor_valid),
					     .x_mc_en(x_mc_en),
					     .y_mc_en(y_mc_en),
					     .mu11_mac_enable_en(mu11_mac_enable_en),
					     .mu02_mac_enable_en(mu02_mac_enable_en),
					     .mu11_r_en(mu11_r_en),
					     .mu02_r_en(mu02_r_en),
					     .skew_dividend_vld(skew_dividend_vld),
					     .skew_divisor_vld(skew_divisor_vld),
					     .skew_r_en(skew_r_en),
					     .m02_mult_en(m02_mult_en),
					     .m02_r_en(m02_r_en),
					     .bram_addr_sel(bram_addr_sel),
					     .xp_gen_en(xp_gen_en),
					     .xp_r_en(xp_r_en),
					     .p2_addr_en(p2_addr_en),
					     .p1_addr_en(p1_addr_en),
					     .p_rd_addr_sel(p_rd_addr_sel),
					     .calc_p1_addr_en(calc_p1_addr_en),
					     .p1_r_en(p1_r_en),
					     .p2_r_en(p2_r_en),
					     .py_r_en(py_r_en),					     
					     .p_r_en(p_r_en),
					     .p_val_sel(p_val_sel),
					     .img_addr_sel(img_addr_sel),
					     .sub_p1_p2_en(sub_p1_p2_en),
					     .p_mult_en(p_mult_en),
					     .x_cnt_out(x_cnt),
					     .y_cnt_out(y_cnt),
					     .xp_x_cnt_out(x_cnt_xp),
					     .xp_y_cnt_out(y_cnt_xp),
					     .x_fifo_full(x_fifo_full),
					     .y_fifo_full(y_fifo_full),
					     .p_fifo_full(p_fifo_full),
					     .xp_r_out(xp_r),
					     .skew_vld(skew_vld_in),
					     .skew_dvd_rdy_out(skew_dvd_rdy),
					     .skew_dvs_rdy_out(skew_dvs_rdy),
					     .div_res_vld(div_res_vld),
      					     .rdata(prdata),
					     .enb(pen),
					     .web(pwen),
					     .wdata(pwdata),
					     .addr(paddr)
					     );

   assign bram_clk = clk;
   assign bram_resetn = ~resetn;
   
endmodule // deskew_top





`endif
