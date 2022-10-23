`ifndef __DSQW_CTRL_V__
 `define __DSQW_CTRL_V__

module dsqw_ctrl(
		 //CRM IF
		 clk,
		 rst_n,

		 //REG_BLK IF

		 //inputs:
		 img_dim,
		 in_img_start_addr,
		 out_img_start_addr,

		 dsqw_done_ack,
		 err_size_ack,
		 mem_acc_err_ack,

		 start_dsqw,
		 soft_rst,

		 //outputs:
		 dsqw_idle,
		 dsqw_done,
		 err_size,
		 mem_acc_err,

		 //INTERRUPT IF

		 //output:
		 dsqw_irq,

		 //DATAPATH CONTROL:

		 //inputs
		 x_cnt,
		 y_cnt,
		 x_cnt_xp,
		 y_cnt_xp,
		 xp_r,
		 x_fifo_full,
		 y_fifo_full,
		 p_fifo_full,
		 skew_vld_in,
		 skew_dvd_rdy,
		 skew_dvs_rdy,
		 div_res_vld,
		 
		 //outputs
		 sclr,
		 x_fifo_wr,
		 y_fifo_wr,
		 bram_en,
		 bram_wr,
		 addr_gen_en,
		 x_fifo_rd,
		 y_fifo_rd,
		 p_fifo_rd,
		 m00_en,
		 m01_en,
		 m10_en,
		 m00_r_en,
		 m01_r_en,
		 m10_r_en,
		 div_sel,
		 dividend_valid,
		 divisor_valid,
		 x_mc_en,
		 y_mc_en,
		 mu11_mac_enable_en,
		 mu02_mac_enable_en,
		 mu11_r_en,
		 mu02_r_en,
		 skew_dividend_vld,
		 skew_divisor_vld,
		 skew_r_en,
		 m02_mult_en,
		 m02_r_en,
		 bram_addr_sel,
		 xp_gen_en,
		 xp_r_en,
		 py_r_en,
		 p2_addr_en,
		 p1_addr_en,
		 p_rd_addr_sel,
		 calc_p1_addr_en,
		 p1_r_en,
		 p2_r_en,
		 p_r_en,
		 p_val_sel,
		 img_addr_sel,
		 sub_p1_p2_en,
		 p_mult_en
		 );

   //CRM IF
   input  clk;
   input  rst_n;


   input signed [14:0] xp_r;   
   input [8:0]	       img_dim;
   input [16:0]	       in_img_start_addr;
   input [16:0]	       out_img_start_addr;
   input	       dsqw_done_ack;
   input	       err_size_ack;
   input	       mem_acc_err_ack;
   input	       start_dsqw;
   input	       soft_rst;

   input [8:0]	       x_cnt;
   input [8:0]	       y_cnt;
   input [8:0]	       x_cnt_xp;
   input [8:0]	       y_cnt_xp;

   input	       x_fifo_full;
   input	       y_fifo_full;
   input	       p_fifo_full;

   input	       skew_vld_in;
   input	       skew_dvd_rdy;
   input	       skew_dvs_rdy;
   input	       div_res_vld;
   
   //outputs:
   output	       dsqw_idle;
   output	       dsqw_done;
   output	       err_size;
   output	       mem_acc_err;
   output	       dsqw_irq;
   output	       sclr;
   output	       x_fifo_wr;
   output	       y_fifo_wr;
   output	       bram_en;
   output	       bram_wr;
   output	       addr_gen_en;
   output	       x_fifo_rd;
   output	       y_fifo_rd;
   output	       p_fifo_rd;
   output	       m00_en;
   output	       m01_en;
   output	       m10_en;
   output	       m00_r_en;
   output	       m01_r_en;
   output	       m10_r_en;
   output	       div_sel;
   output	       dividend_valid;
   output	       divisor_valid;
   output	       x_mc_en;
   output	       y_mc_en;
   output	       mu11_mac_enable_en;
   output	       mu02_mac_enable_en;
   output	       mu11_r_en;
   output	       mu02_r_en;
   output	       skew_dividend_vld;
   output	       skew_divisor_vld;
   output	       skew_r_en;
   output	       m02_mult_en;
   output	       m02_r_en;
   output	       bram_addr_sel;
   output	       xp_gen_en;
   output	       xp_r_en;
   output	       py_r_en;
   output	       p2_addr_en;
   output	       p1_addr_en;
   output	       p_rd_addr_sel;
   output	       calc_p1_addr_en;
   output	       p1_r_en;
   output	       p2_r_en;
   output	       p_r_en;
   output	       p_val_sel;
   output	       img_addr_sel;
   output	       sub_p1_p2_en;
   output	       p_mult_en;


   //----------------------------------------//
   //Internal signals:

   //err size : from cfg_fsm 2 (irq & output)
   wire		       err_size_w;

   //start_dskw_fsm : from cfg_fsm 2 (deskew_fsm)
   wire		       start_deskew_fsm;

   //DONE indication:
   wire		       dsqw_done_w;
   wire		       dsqw_done_out_w;

   //MEM_ACC_ERR - Fifo buffer overflow during read
   wire		       mem_acc_err_w;

   
   //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
   //Sub-components:

   //CFG_CHECK FSM:

   cfg_fsm u_cfg_fsm(
		     .clk(clk),
		     .rst_n(rst_n),
      
		     .dskw_start_in(start_dsqw),
		     .soft_rst(soft_rst),
		     
		     .dskw_done_in(dsqw_done_out_w), //TODO : WIRE 2 DESKEW_FSM

		     .in_img_start_addr(in_img_start_addr),
		     .out_img_start_addr(out_img_start_addr),
		     .img_dim(img_dim),
		     
		     .err_size(err_size_w), //TODO : Connect to IRQ and Output
		     .dskw_start_out(start_deskew_fsm), //TODO : Connect to DESKEW_FSM
		     .idle(dsqw_idle)
		     );

   //Interrupts controller:
   dsqw_irq_ctrl u_irq_ctrl(
			    .clk(clk),
			    .rst_n(rst_n),

			    .dsqw_done(dsqw_done_w),
			    .err_size(err_size_w),
			    .mem_acc_err(mem_acc_err_w),
			    
			    .dsqw_done_out(dsqw_done_out_w),
			    .err_size_out(err_size),
			    .mem_acc_err_out(mem_acc_err),
			    .dsqw_irq(dsqw_irq),
			    
			    .dsqw_done_ack(dsqw_done_ack),
			    .err_size_ack(err_size_ack),
			    .mem_acc_err_ack(mem_acc_err_ack)
			    );
   //DONE interrupt
   assign dsqw_done = dsqw_done_out_w;   

   //MEM ACC ERR generation:
   assign mem_acc_err_w = x_fifo_full | y_fifo_full | p_fifo_full;
   
   //CONTROL PATH FSM intantiation
   deskew_fsm deskew_fsm_i(
			   //CRM 
			   .clk(clk),
			   .rst_n(rst_n),

			   //Inputs:
			   //--from regs & internal
			   .img_dim(img_dim),
			   .start_deskew(start_deskew_fsm),

			   //--from Datapath
			   .x_cnt(x_cnt),
			   .y_cnt(y_cnt),
			   .x_cnt_xp(x_cnt_xp),
			   .y_cnt_xp(y_cnt_xp),
			   .xp_r(xp_r),
			   .skew_vld_in(skew_vld_in),
			   .skew_dvd_rdy(skew_dvd_rdy),
			   .skew_dvs_rdy(skew_dvs_rdy),
			   .div_res_vld(div_res_vld),
			   

			   //Outputs
			   //--to internal logic
			   .deskew_done_out(dsqw_done_w),

			   //--to datapath
			   .sclr_out(sclr),
			   .x_fifo_wr_out(x_fifo_wr),
			   .y_fifo_wr_out(y_fifo_wr),
			   .bram_en_out(bram_en),
			   .bram_wr_out(bram_wr),
			   .addr_gen_en_out(addr_gen_en),
			   .x_fifo_rd_out(x_fifo_rd),
			   .y_fifo_rd_out(y_fifo_rd),
			   .p_fifo_rd_out(p_fifo_rd),
			   .m00_en_out(m00_en),
			   .m01_en_out(m01_en),
			   .m10_en_out(m10_en),
			   .m00_r_en_out(m00_r_en),
			   .m01_r_en_out(m01_r_en),
			   .m10_r_en_out(m10_r_en),
			   .div_sel_out(div_sel),
			   .dividend_valid_out(dividend_valid),
			   .divisor_valid_out(divisor_valid),
			   .x_mc_en_out(x_mc_en),
			   .y_mc_en_out(y_mc_en),
			   .mu11_mac_enable_en_out(mu11_mac_enable_en),
			   .mu02_mac_enable_en_out(mu02_mac_enable_en),
			   .mu11_r_en_out(mu11_r_en),
			   .mu02_r_en_out(mu02_r_en),
			   .skew_dividend_vld_out(skew_dividend_vld),
			   .skew_divisor_vld_out(skew_divisor_vld),
			   .skew_r_en_out(skew_r_en),
			   .m02_mult_en_out(m02_mult_en),
			   .m02_r_en_out(m02_r_en),
			   .bram_addr_sel_out(bram_addr_sel),
			   .xp_gen_en_out(xp_gen_en),
			   .xp_r_en_out(xp_r_en),
			   .py_r_en_out(py_r_en),
			   .p2_addr_en_out(p2_addr_en),
			   .p1_addr_en_out(p1_addr_en),
			   .p_rd_addr_sel_out(p_rd_addr_sel),
			   .calc_p1_addr_en_out(calc_p1_addr_en),
			   .p1_r_en_out(p1_r_en),
			   .p2_r_en_out(p2_r_en),
			   .p_r_en_out(p_r_en),
			   .p_val_sel_out(p_val_sel),
			   .img_addr_sel_out(img_addr_sel),
			   .sub_p1_p2_en_out(sub_p1_p2_en),
			   .p_mult_en_out(p_mult_en)
			   );
   
   

endmodule // dsqw_ctrl




`endif
