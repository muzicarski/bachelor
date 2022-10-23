`ifndef __DESKEW_CONTROL_PATH_V__
 `define __DESKEW_CONTROL_PATH_V__ 

module deskew_control_path #(parameter REG_ADDR_WIDTH = 8)
            (
			    //CLK RST IF
			    clk,
			    rst_n,

			    //--------------------//
			    //DATAPATH IF

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

			    // -- from REG to DataPath
			    img_dim,
			    in_img_start_addr,
			    out_img_start_addr,

			    // -- from FSM to Datapath
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
			    p_mult_en,

			    //--------------------//
			    //INTERRUPTS IF

			    //output:
			    dsqw_irq,


			    //--------------------//
			    //AXI LITE IF

			    //outputs

			    //Write addr channel:
                            axis_waddr_ready,
                            //Write data channel:
			    axis_wdata_ready,
                            //Write response channel:
                            axis_bresp,
                            axis_bresp_valid,
                            //Read addr channel:			    
                            axis_raddr_ready,
                            //Read data channel:
                            axis_rdata,
                            axis_rdata_valid,
                            axis_rresp,


			    //inputs

                            //Write addr channel:
                            axis_waddr,
                            axis_waddr_valid,
                            //Write data channel:
                            axis_wdata,
                            axis_wdata_valid,
			    //Write response channel
                            axis_bresp_ready,
                            //Read addr channel:
                            axis_raddr,
                            axis_raddr_valid,
                            //Read data channel:
                            axis_rdata_ready
			    );



   input clk;
   input rst_n;
   

   //--------------------//
	 //DATAPATH IF

   //inputs
   input [8:0] x_cnt;
   input [8:0] y_cnt;
   input [8:0] x_cnt_xp;
   input [8:0] y_cnt_xp;
   input [14:0]	xp_r;
   input	x_fifo_full;
   input	y_fifo_full;
   input	p_fifo_full;
   input	skew_vld_in;
   input	skew_dvd_rdy;
   input	skew_dvs_rdy;
   input	div_res_vld;
   

   //outputs

   output [8:0]	img_dim;
   output [16:0] in_img_start_addr;
   output [16:0] out_img_start_addr;

   output	 sclr;
   output	 x_fifo_wr;
   output	 y_fifo_wr;
   output	 bram_en;
   output	 bram_wr;
   output	 addr_gen_en;
   output	 x_fifo_rd;
   output	 y_fifo_rd;
   output	 p_fifo_rd;
   output	 m00_en;
   output	 m01_en;
   output	 m10_en;
   output	 m00_r_en;
   output	 m01_r_en;
   output	 m10_r_en;
   output	 div_sel;
   output	 dividend_valid;
   output	 divisor_valid;
   output	 x_mc_en;
   output	 y_mc_en;
   output	 mu11_mac_enable_en;
   output	 mu02_mac_enable_en;
   output	 mu11_r_en;
   output	 mu02_r_en;
   output	 skew_dividend_vld;
   output	 skew_divisor_vld;
   output	 skew_r_en;
   output	 m02_mult_en;
   output	 m02_r_en;
   output	 bram_addr_sel;
   output	 xp_gen_en;
   output	 xp_r_en;
   output	 py_r_en;
   output	 p2_addr_en;
   output	 p1_addr_en;
   output	 p_rd_addr_sel;
   output	 calc_p1_addr_en;
   output	 p1_r_en;
   output	 p2_r_en;
   output	 p_r_en;
   output	 p_val_sel;
   output	 img_addr_sel;
   output	 sub_p1_p2_en;
   output	 p_mult_en;

   //--------------------//
   //INTERRUPTS IF

   //output:
   output	 dsqw_irq;

   //--------------------//
   //AXI LITE IF

   //outputs


   output	 axis_waddr_ready;
   output	 axis_wdata_ready;
   output [1:0]	 axis_bresp;
   output	 axis_bresp_valid;
   output	 axis_raddr_ready;
   output [31:0] axis_rdata;
   output	 axis_rdata_valid;
   output [1:0]	 axis_rresp;
   

   //inputs
   input [REG_ADDR_WIDTH -1 :0]	 axis_waddr;
   input	 axis_waddr_valid;
   input [31:0]	 axis_wdata;
   input	 axis_wdata_valid;
   input	 axis_bresp_ready;
   input [REG_ADDR_WIDTH-1 :0]	 axis_raddr;
   input	 axis_raddr_valid;
   input	 axis_rdata_ready;
   

   ////////////////////////////////////////////////////////////
   ////////////////////////////////////////////////////////////
   ////////////////////////////////////////////////////////////


   //------------------------------//
   //REG_BLOCK 2 DSQW_CTRL IF
   //------------------------------//
   
   wire		 deskew_done;
   wire		 deskew_done_ack;
   wire		 deskew_idle;
   wire		 mem_acc_err;
   wire		 mem_acc_err_ack;
   wire		 err_size;
   wire		 err_size_ack;

   wire [8:0]	 img_dim;
   wire [16:0]	 in_img_start_addr;
   wire [16:0]	 out_img_start_addr;
   wire		 start_deskew;
   wire		 soft_rst;
   

   //------------------------------//
   //AXI_BRIGDE 2 REG_BLOCK IF
   //------------------------------//

   wire		 read_reg;       
   wire		 write_reg;      
   wire [31:0]	 reg_wdata;      
   wire [31:0]	 reg_rdata;      
   wire [7:0]	 reg_raddr;      
   wire [7:0]	 reg_waddr;


   ////////////////////////////////////////////////////////////
   ////////////////////////////////////////////////////////////
   ////////////////////////////////////////////////////////////


   axi_lite_bridge #(.REG_ADDR_WIDTH (REG_ADDR_WIDTH ))u_axi (
			  .axis_clk(clk),
			  .axis_rst_n(rst_n),

			  .axis_waddr(axis_waddr),
			  .axis_waddr_valid(axis_waddr_valid), 
			  .axis_waddr_ready(axis_waddr_ready), 
			  .axis_wdata(      axis_wdata),       
			  .axis_wdata_valid(axis_wdata_valid), 
			  .axis_wdata_ready(axis_wdata_ready), 
			  .axis_bresp(      axis_bresp),       
			  .axis_bresp_valid(axis_bresp_valid), 
			  .axis_bresp_ready(axis_bresp_ready), 
			  .axis_raddr(      axis_raddr),       
			  .axis_raddr_valid(axis_raddr_valid), 
			  .axis_raddr_ready(axis_raddr_ready), 
			  .axis_rdata(      axis_rdata),       
			  .axis_rdata_valid(axis_rdata_valid), 
			  .axis_rdata_ready(axis_rdata_ready), 
			  .axis_rresp(      axis_rresp),

			  //Reg block:
			  .write_reg(write_reg),
			  .read_reg( read_reg), 
			  .reg_wdata(reg_wdata),
			  .reg_rdata(reg_rdata),
			  .reg_waddr(reg_waddr),
			  .reg_raddr(reg_raddr)
			  );

   //============================================================//

   deskew_reg_block u_reg_blk (
			       .clk(      clk),             
			       .rst_n(    rst_n),          
			       .read_reg( read_reg),       
			       .write_reg(write_reg),      
			       .reg_wdata(reg_wdata),      
			       .reg_rdata(reg_rdata),      
			       .reg_raddr(reg_raddr),      
			       .reg_waddr(reg_waddr),      
      
			       .mem_acc_err(mem_acc_err),    
			       .err_size(err_size),       
			       .done(deskew_done),           
			       .idle(deskew_idle),           
			       .mem_acc_err_ack(mem_acc_err_ack),
			       .err_size_ack(err_size_ack),   
			       .done_ack(deskew_done_ack),       
      
			       .img_w_l(img_dim),        
   			       .start_addr_in(in_img_start_addr),  
   			       .start_addr_out(out_img_start_addr), 
     			       .start_deskew(start_deskew),   
   			       .soft_rst(soft_rst)
			       );
   
   //============================================================//
     dsqw_ctrl u_dsqw_ctrl (
			    .clk(clk),
			    .rst_n(rst_n),
			    .img_dim(img_dim),
			    .in_img_start_addr(in_img_start_addr),
			    .out_img_start_addr(out_img_start_addr),
			    .dsqw_done_ack(deskew_done_ack),
			    .err_size_ack(err_size_ack),
			    .mem_acc_err_ack(mem_acc_err_ack),
			    .start_dsqw(start_deskew),
			    .soft_rst(soft_rst),
			    .dsqw_idle(deskew_idle),
			    .dsqw_done(deskew_done),
			    .err_size(err_size),
			    .mem_acc_err(mem_acc_err),
			    .dsqw_irq(dsqw_irq),
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
			    .p_mult_en(p_mult_en)  
			    );
   

endmodule // deskew_control_path

`endif
