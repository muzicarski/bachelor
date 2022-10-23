`ifndef __DESKEW_DATAPATH_TOP__
 `define __DESKEW_DATAPATH_TOP__

module deskew_datapath_top(
			   //CRM
			   clk,
			   rst_n,

			   //Inputs:

			   //-- from ControlPath / Regs
			   img_dim,
			   in_img_start_addr,
			   out_img_start_addr,

			   //-- from ControlPath / FSM
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

			   //Outputs to ControlPath
			   x_cnt_out,
			   y_cnt_out,
			   xp_x_cnt_out,
			   xp_y_cnt_out,
			   x_fifo_full,
			   y_fifo_full,
			   p_fifo_full,
			   xp_r_out,
			   skew_vld,
			   skew_dvd_rdy_out,
			   skew_dvs_rdy_out,
			   div_res_vld,

			   //Input - from BRAM
			   rdata,

			   //Outputs - to BRAM
			   enb,
			   web,
			   wdata,
			   addr

			   );

   localparam	DATA_WIDTH = 8;
   localparam	ADDR_WIDTH = 17;

   //========================================//
		//INPUTS
   //========================================//
   
   input	clk;
   input	rst_n;
   //From CTRLPATH (FSM)

   input	sclr;
   input	x_fifo_wr;
   input	y_fifo_wr;
   input	bram_en;
   input	bram_wr;
   input	addr_gen_en;
   input	x_fifo_rd;
   input	y_fifo_rd;
   input	p_fifo_rd;
   input	m00_en;
   input	m01_en;
   input	m10_en;
   input	m00_r_en;
   input	m01_r_en;
   input	m10_r_en;
   input	div_sel;
   input	dividend_valid;
   input	divisor_valid;
   input	x_mc_en;
   input	y_mc_en;
   input	mu11_mac_enable_en;
   input	mu02_mac_enable_en;
   input	mu11_r_en;
   input	mu02_r_en;
   input	skew_dividend_vld;
   input	skew_divisor_vld;
   input	skew_r_en;
   input	m02_mult_en;
   input	m02_r_en;
   input	bram_addr_sel;
   input	xp_gen_en;
   input	xp_r_en;
   input	py_r_en;
   input	p2_addr_en;
   input	p1_addr_en;
   input	p_rd_addr_sel;
   input	calc_p1_addr_en;
   input	p1_r_en;
   input	p2_r_en;
   input	p_r_en;
   input	p_val_sel;
   input	img_addr_sel;
   input	sub_p1_p2_en;
   input	p_mult_en;   

   //From CTRLPATH (Regs)
   input [8 : 0] img_dim;

   input [16:0]	 in_img_start_addr;
   input [16:0]	 out_img_start_addr;

   //From BRAM
   input [DATA_WIDTH-1 : 0] rdata;   
   
   //==============================//
   //       O U T P U T S          //
   //==============================//
   
   output [DATA_WIDTH-1 : 0] wdata;
   output [16 : 0]	     addr;
   
   output		     enb;
   output		     web;

   //--------------------//
   //To Control Path:
   
   output [8:0]		     x_cnt_out;
   output [8:0]		     y_cnt_out;
   output [8:0]		     xp_x_cnt_out;
   output [8:0]		     xp_y_cnt_out;

   output [14:0]	     xp_r_out;

   output		     skew_vld;
   output		     skew_dvd_rdy_out;
   output		     skew_dvs_rdy_out;
   output		     div_res_vld;
   
   output		     x_fifo_full;
   output		     y_fifo_full;
   output		     p_fifo_full;
   

   /////////////////////////////////////////////////////////////
   ////////////////////////////////////////////////////////////
   ////////////////////////////////////////////////////////////
   
   
   wire			     rdata_rdy;
   wire [DATA_WIDTH-1 : 0]   rdata_out;
   wire [DATA_WIDTH-1 : 0]   wdata_in;
   wire [DATA_WIDTH-1 : 0]   rdata_in;
   wire			     enb_w;
   wire			     web_w;
   wire [DATA_WIDTH-1 : 0]   wdata_out;
   wire [16 : 0]	     addr_in;
   wire [16 : 0]	     addrb;
   
   wire [8 : 0]		     x_cnt;
   wire [8 : 0]		     y_cnt;
   wire [8 : 0]		     x_cnt_xp;
   wire [8 : 0]		     y_cnt_xp;
   
   wire [7 : 0]		     x_rdata;
   wire [7 : 0]		     y_rdata;

   wire [12 : 0]	     x_rdata_padded;
   wire [12 : 0]	     y_rdata_padded;
   
   wire [7:0]		     p_rdata;
   
   reg [28:0]		     m00_r;
   reg [28:0]		     m10_r;
   reg [28:0]		     m01_r;
   
   wire [28:0]		     m00;
   wire [28:0]		     m10;
   wire [28:0]		     m01;
   
   wire [31:0]		     dividend;
   wire [31:0]		     divisor;
   wire [31:0]		     divider_out;
   reg [31:0]		     divider_out_r;
   reg [12:0]		     x_mc_r;
   reg [12:0]		     y_mc_r;
   
   wire [12:0]		     x_mc_sign_inverter_out;
   wire [12:0]		     y_mc_sign_inverter_out;
   
   wire [12:0]		     subtract_out_x; //10.3 signed
   wire [12:0]		     subtract_out_y; //10.3 signed
   
   wire [25:0]		     mu11_mult_out; //20.6 signed
   wire [25:0]		     mu02_mult_out; //20.6 signed
   
   wire [8:0]		     p_rdata_mu_padded; //9.0 signed (bit [8] = 0, always, non-negative)
   
   wire [39:0]		     mu11_mac_out;
   wire [39:0]		     mu02_mac_out; 
   
   reg [33:0]		     mu11_r;
   reg [33:0]		     mu02_r;
   
   wire [39:0]		     mu11_padded;
   wire [39:0]		     mu02_padded;

   
   wire [47:0]		     skew;
   reg [23:0]		     skew_r; //15.9 -> skew [47:24]
   reg [23:0]		     skew_2r;
   wire			     skew_dvd_rdy;
   wire			     skew_dvs_rdy;
   reg			     skew_dvd_rdy_reg;
   reg			     skew_dvs_rdy_reg;
   
   wire [23:0]		     skew_half;
   wire [23:0]		     skew_sign_inverter_out;
   
   wire [32:0]		     m02_mult_out;
   
   reg [23:0]		     m02_r;
   
   wire [16:0]		     addr_mux_out;
   
   reg [23:0]		     xp_r;
   wire [23:0]		     xp_out;
   
   wire [7:0]		     x1;
   wire [7:0]		     y2;
   reg [7:0]		     py_r;
   
   
   wire [16:0]		     img_start_addr;
   
   wire [16:0]		     p1_addr_out;
   reg [16:0]		     p1_addr_out_r;

   reg [16:0]		     p1_addr_r;
   reg [16:0]		     p2_addr_r;
   
   wire signed [8:0]	     p1_padded;
   wire signed [8:0]	     p2_padded;
   
   wire [16:0]		     p_rd_addr;
   
   reg [7:0]		     p1_r;
   reg [7:0]		     p2_r;
   
   wire signed [8:0]	     p1_p2_subtracted;
   reg  signed [8:0]	     p1_p2_subtracted_r;
   
   wire [8:0]		     xp_x1;
   
   wire signed [17:0]	     p_mult_out;
   wire signed [17:0]	     p1_r_padded;
   
   wire signed [17:0]	     p_new;
   
   wire [7:0]		     p;
   
   reg [7:0]		     p_r;

   
   bram_if_ctrl 
     bram_if_ctrl_i(
  		    .clk(clk),
		    .rst_n(rst_n),
		    .en(bram_en),
		    .wr(bram_wr),
		    .rdata_rdy(rdata_rdy),
		    .rdata_out(rdata_out),
		    .wdata_in(wdata_in),
		    .rdata_in(rdata_in),
		    .enb(enb_w),
		    .web(web_w),
		    .wdata_out(wdata_out),
		    .addr_in(addr_mux_out),
		    //.addr_in(addr_in),
		    .addrb(addrb)
		    );

   ////////////////////////////////////////
   
   assign img_start_addr = img_addr_sel ? out_img_start_addr : in_img_start_addr;
   
   addr_gen 
     addr_gen_i(
		.clk(clk),
		.rst_n(rst_n),
		.en(addr_gen_en),
		.sclr(sclr),
		.img_dim(img_dim),
		.addr_offset(img_start_addr),
		.addr_out(addr_in),
		.x_cnt(x_cnt),
		.y_cnt(y_cnt)
		);

   ////////////////////////////////////////
       // addr_mux
   
   assign addr_mux_out = bram_addr_sel ? p_rd_addr : addr_in;
   // else new_pixel write addr logic gen
   
   ////////////////////////////////////////
   fifo #(.ADDR_WIDTH(3)) 
   x_fifo(
  	  .clk(clk), 
	  .rst(rst_n), 
	  .data_in(x_cnt), 
	  .rd_en(x_fifo_rd), 
	  .wr_en(x_fifo_wr), 
	  .data_out(x_rdata), 
	  .empty(), 
	  .full(x_fifo_full),
	  .sclr(sclr) 
	  );

   ////////////////////////////////////////
   
   fifo #(.ADDR_WIDTH(3)) 
   y_fifo(
   	  .clk(clk), 
	  .rst(rst_n), 
	  .data_in(y_cnt), 
	  .rd_en(y_fifo_rd), 
	  .wr_en(y_fifo_wr), 
	  .data_out(y_rdata), 
	  .empty(), 
	  .full(y_fifo_full),
	  .sclr(sclr) 
	  );

   ////////////////////////////////////////
   
   fifo #(.ADDR_WIDTH(3)) 
   p_fifo(
   	  .clk(clk), 
	  .rst(rst_n), 
	  .data_in(rdata_out), 
	  .rd_en(p_fifo_rd), 
	  .wr_en(rdata_rdy), 
	  .data_out(p_rdata), 
	  .empty(), 
	  .full(p_fifo_full),
	  .sclr(sclr)   
	  );
   
   ////////////////////////////////////////
   
   m00_acc_wrapper 
     m00_i(
	   .BYPASS_0(0),
	   .B_0(p_rdata),
	   .CE_0(m00_en),
	   .CLK_0(clk),
	   .Q_0(m00),
	   .SCLR_0(sclr) 
	   );

   ////////////////////////////////////////
   
   mult_accum #(.A_IN_WIDTH(8),
		.B_IN_WIDTH(8),
		.ACC_OUT_WIDTH(29))
   m10_i(
	 .dataa(x_rdata),
	 .datab(p_rdata),
	 .clk(clk),
	 .aclr(sclr),
	 .clken(m10_en),
	 .sload(0),
	 .mac_out(m10)
	 );
   ////////////////////////////////////////
   
   mult_accum #(.A_IN_WIDTH(8),
		.B_IN_WIDTH(8),
		.ACC_OUT_WIDTH(29))
   m01_i(
	 .dataa(y_rdata),
	 .datab(p_rdata),
	 .clk(clk),
	 .aclr(sclr),
	 .clken(m01_en),
	 .sload(0),
	 .mac_out(m01)
	 );
   ////////////////////////////////////////
   //Subtractor inputs:

   assign x_rdata_padded = {2'h0, x_rdata, 3'h0};
   assign y_rdata_padded = {2'h0, y_rdata, 3'h0};   

   ////////////////////////////////////////

   //SKEW Divider inputs
   assign mu11_padded = {{6{mu11_r[33]}}, mu11_r};
   assign mu02_padded = {{6{mu02_r[33]}}, mu02_r};

   ////////////////////////////////////////

   assign p_rdata_mu_padded = {1'b0, p_rdata};

   //TODO : In SYSC model, Skew is calculated only by
   //dividing Integer parts of MUs.
   //Provide such wiring here, and instantiate new
   //type of divider, which takes inputs of width 33 bits
   //and provides output in format 15.9 (signed)
   
   ////////////////////////////////////////
   
   assign enb = enb_w;
   assign web = web_w;
   assign wdata = wdata_out;
   assign addr = addrb;
   assign rdata_in = rdata;

   ////////////////////////////////////////

   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
	  m00_r <= 0;
	else if (m00_r_en)
	  m00_r <= m00;
	else
	  m00_r <= m00_r;
     end

   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
	  m10_r <= 0;
	else if (m10_r_en)
	  m10_r <= m10;
	else
	  m10_r <= m10_r;
     end
   
   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
	  m01_r <= 0;
	else if (m01_r_en)
	  m01_r <= m01;
	else
	  m01_r <= m01_r;
     end
   
   
   assign dividend = div_sel ? {3'h0, m01_r} : {3'h0, m10_r};
   assign divisor = {3'h0, m00_r};
   
   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
	  x_mc_r <= 0;
	else if (x_mc_en)
	  x_mc_r <= divider_out_r[28 : 0];
	else
	  x_mc_r <= x_mc_r;
     end 
   
   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
	  y_mc_r <= 0;
	else if (y_mc_en)
	  y_mc_r <= divider_out_r[28 : 0];
	else
	  y_mc_r <= y_mc_r;
     end 
   
   divider_wrapper mc_divider_i(
				.M_AXIS_DOUT_0_tdata(divider_out),
				.M_AXIS_DOUT_0_tuser(),
				.M_AXIS_DOUT_0_tvalid(div_res_vld),
				.S_AXIS_DIVIDEND_0_tdata(dividend),
				.S_AXIS_DIVIDEND_0_tvalid(dividend_valid),
				.S_AXIS_DIVISOR_0_tdata(divisor),
				.S_AXIS_DIVISOR_0_tvalid(divisor_valid),
				.aclk_0(clk)
				);
   
   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
	  divider_out_r <= 0;
	else if (div_res_vld)
	  divider_out_r <= divider_out;
	else
	  divider_out_r <= divider_out_r;
     end 
   
   sign_inverter #(.WIDTH(13)) x_mc_sign_inverter_i(
						    .clk(clk),
						    .rst_n(rst_n),
						    .a_in(x_mc_r),
						    .b_out(x_mc_sign_inverter_out)
						    );
   
   sign_inverter #(.WIDTH(13)) y_mc_sign_inverter_i(
						    .clk(clk),
						    .rst_n(rst_n),
						    .a_in(y_mc_r),
						    .b_out(y_mc_sign_inverter_out)
						    );

   subtract_wrapper subtract_x_xmc(
				   .A_0(x_rdata_padded),
				   .B_0(x_mc_sign_inverter_out),
				   .CE_0(1),
				   .CLK_0(clk),
				   .S_0(subtract_out_x)
				   );

   subtract_wrapper subtract_y_ymc(
				   .A_0(y_rdata_padded),
				   .B_0(y_mc_sign_inverter_out),
				   .CE_0(1),
				   .CLK_0(clk),
				   .S_0(subtract_out_y)
				   );
   
   signed_fixed_point_mult_wrapper mu11_mult_i(
					       .A_0(subtract_out_x),
					       .B_0(subtract_out_y),
					       .CLK_0(clk),
					       .P_0(mu11_mult_out)
					       );
   
   signed_fixed_point_mult_wrapper mu02_mult_i(
					       .A_0(subtract_out_y),
					       .B_0(subtract_out_y),
					       .CLK_0(clk),
					       .P_0(mu02_mult_out)
					       );   
   
   signed_mult_accum #(.A_IN_WIDTH(9),
		       .B_IN_WIDTH(26),
		       .ACC_OUT_WIDTH(40))
   mu11_mac_i(
              .dataa(p_rdata_mu_padded),
              .datab(mu11_mult_out),
              .clk(clk),
              .aclr(sclr),
              .clken(mu11_mac_enable_en),
              .mac_out(mu11_mac_out)
              );   
   
   signed_mult_accum #(.A_IN_WIDTH(9),
		       .B_IN_WIDTH(26),
		       .ACC_OUT_WIDTH(40))
   mu02_mac_i(
              .dataa(p_rdata_mu_padded),
              .datab(mu02_mult_out),
              .clk(clk),
              .aclr(sclr),
              .clken(mu02_mac_enable_en),
              .mac_out(mu02_mac_out)
              );

   skew_divider_wrapper skew_divider_i(
				       .M_AXIS_DOUT_0_tdata(skew),
				       .M_AXIS_DOUT_0_tvalid(skew_vld),
				       .S_AXIS_DIVIDEND_0_tdata(mu11_padded),
				       .S_AXIS_DIVIDEND_0_tvalid(skew_dividend_vld),
				       .S_AXIS_DIVISOR_0_tdata(mu02_padded),
				       .S_AXIS_DIVISOR_0_tvalid(skew_divisor_vld),
				       .S_AXIS_DIVISOR_0_tready(skew_dvs_rdy),
				       .S_AXIS_DIVIDEND_0_tready(skew_dvd_rdy),
				       .aclk_0(clk),
				       .aclken_0(1)
				       );

   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
	  begin
             skew_dvd_rdy_reg <= 0;
	     skew_dvs_rdy_reg <= 0;
	  end
	else
	  begin
             skew_dvd_rdy_reg <= skew_dvd_rdy;
	     skew_dvs_rdy_reg <= skew_dvs_rdy;
	  end
     end        

   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
          mu11_r <= 0;
	else if (mu11_r_en)
          mu11_r <= mu11_mac_out[39:6];
	else
          mu11_r <= mu11_r;
     end        
   
   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
          mu02_r <= 0;
	else if (mu02_r_en)
          mu02_r <= mu02_mac_out[39:6];
	else
          mu02_r <= mu02_r;
     end    

   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
          skew_r <= 0;
	else if(skew_vld)
	  skew_r <= skew[23:0];
	else
          skew_r <= skew_r;
     end
   
   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
	  skew_2r <= 0;
	else if (skew_r_en)
	  skew_2r <= skew_r;
	else
	  skew_2r <= skew_2r;
     end
   
   assign skew_half = {skew_2r[23], skew_2r[23:1]};
   
   sign_inverter #(.WIDTH(24)) skew_sign_inverter_i(
						    .clk(clk),
						    .rst_n(rst_n),
						    .a_in(skew_half),
						    .b_out(skew_sign_inverter_out)
						    );
   
   m02_multiplier_wrapper m02_mult_i(
				     .A_0(skew_sign_inverter_out),
				     .B_0(img_dim),
				     .CE_0(m02_mult_en),
				     .CLK_0(clk),
				     .P_0(m02_mult_out)
				     );
   
   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
          m02_r <= 0;
	else if(m02_r_en)
          m02_r <= m02_mult_out[23:0];
	else
          m02_r <= m02_r;
     end 
   
   
   xp_gen xp_gen_i(
		   .clk(clk),
		   .rst_n(rst_n),
		   .en(xp_gen_en),
		   .sclr(sclr),
		   .img_dim(img_dim),
		   .incr_in(skew_r),
		   .acc_offset(m02_r),
		   .xp_out(xp_out),
		   .x_cnt_xp(x_cnt_xp),
		   .y_cnt_xp(y_cnt_xp)   
		   );    

   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
          xp_r <= 0;
	else if(xp_r_en)   
          xp_r <= xp_out;
	else
          xp_r <= xp_r;
     end 
   
   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
          py_r <= 0;
	else if(py_r_en)   
          py_r <= y_cnt_xp;
	else
          py_r <= py_r;
     end    
   
   assign x1 = xp_r[16:9];
   assign y2 = py_r + 1;
   
   assign p1_addr_out = {9'h000, x1} + y2*img_dim;
   
   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
          p1_addr_out_r <= 0;
	else if(calc_p1_addr_en)   
          p1_addr_out_r <= p1_addr_out;
	else
          p1_addr_out_r <= p1_addr_out_r;
     end  

   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
          p1_addr_r <= 0;
	else if(p1_addr_en)
          p1_addr_r <= p1_addr_out_r;
	else
          p1_addr_r <= p1_addr_r;
     end  
   
   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
          p2_addr_r <= 0;
	else if(p2_addr_en)
          p2_addr_r <= p1_addr_out_r + 1;
	else     
          p2_addr_r <= p2_addr_r;
     end  
   
   assign p_rd_addr = ~p_rd_addr_sel ? p1_addr_r : p2_addr_r;
   
   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
          p1_r <= 0;
	else if(p1_r_en)
          p1_r <= p_rdata;
	else
          p1_r <= p1_r;
     end

   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
          p2_r <= 0;
	else if(p2_r_en)
          p2_r <= p_rdata;
	else     
          p2_r <= p2_r;
     end
   
   assign p1_padded = {1'b0, p1_r};
   assign p2_padded = {1'b0, p2_r};

   assign p1_p2_subtracted = p1_padded - p2_padded;
   
   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
          p1_p2_subtracted_r <= 0;
	else if(sub_p1_p2_en)
          p1_p2_subtracted_r <= p1_p2_subtracted;
	else     
          p1_p2_subtracted_r <= p1_p2_subtracted_r;
     end

   assign xp_x1 = xp_r[8:0];
   
   
   mult_p_wrapper mult_p_i(
			   .A_0(xp_x1),
			   .B_0(p1_p2_subtracted_r),
			   .CE_0(p_mult_en),
			   .CLK_0(clk),
			   .P_0(p_mult_out)
			   );
   
   assign p1_r_padded = {1'b0, p1_r, 9'h000};
   
   assign p_new = p_mult_out + p1_r_padded;
   
   assign p = p_val_sel ? p_new[16:9] : 8'h00;
   
   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
          p_r <= 0;
	else if(p_r_en)
          p_r <= p;
	else     
          p_r <= p_r;
     end

   assign wdata_in = p_r;


   //================================================================================//

   //OUTPUTS ASSIGNMENTS:

   assign x_cnt_out = x_cnt;
   assign y_cnt_out = y_cnt;
   assign xp_x_cnt_out = x_cnt_xp;
   assign xp_y_cnt_out = y_cnt_xp;
   assign xp_r_out = xp_r[23:9];
   assign skew_dvd_rdy_out = skew_dvd_rdy_reg;
   assign skew_dvs_rdy_out = skew_dvs_rdy_reg;   

   
   
endmodule // deskew_datapath_top 

`endif
