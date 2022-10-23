`ifndef __XP_GEN__
 `define __XP_GEN__

module xp_gen (//Sync:
	       clk,
	       rst_n,
	       //Ctrl:
	       en,
	       sclr,
	       //Limit
	       img_dim,

	       incr_in,
	       //Output:
	       xp_out,

	       //offset
	       acc_offset,

	       //Counter values out:
	       x_cnt_xp,
	       y_cnt_xp

	       );

   ///////////////////////
  //P O R T S   L I S T//
  ///////////////////////

   input clk;
   input rst_n;

   input en;
   input sclr;

   input [8:0] img_dim;
   input [23:0]	incr_in;
   input [23:0]	acc_offset;

   output [23:0] xp_out;

   output [8:0]	 x_cnt_xp;
   output [8:0]	 y_cnt_xp;

   ///////////////////////
		 
   //  Internal wiring  //

   wire		 y_cnt_sclr;
   wire		 x_cnt_en;

   //Comparator output
   wire		 y_cmp_out;

   //Instances port connections:
   wire [8:0]	 x_cnt_out;
   wire [8:0]	 y_cnt_out;
   

   //Internal control logic:

   assign y_cmp_out = (y_cnt_out == img_dim);

   assign y_cnt_sclr = sclr | y_cmp_out;
   assign x_cnt_en = y_cmp_out;

   //Outputs:
   assign x_cnt_xp = x_cnt_out;
   assign y_cnt_xp = y_cnt_out;


   //Parts instantiation:

   //X-Coordinate counter:

   addr_counter u_x_cnt0(.clk(clk),
			 .rst_n(rst_n),
			 .en(x_cnt_en),
			 .sclr(sclr),
			 .count_out(x_cnt_out)
			 );

   addr_counter u_y_cnt0(.clk(clk),           
			 .rst_n(rst_n),       
   			 .en(en),       
   			 .sclr(y_cnt_sclr),         
   			 .count_out(y_cnt_out)
   			 );                   
   

   skew_acc u_skew_acc0 (.clk(clk),
			 .rst_n(rst_n),
			 .en(en),
			 .sclr(y_cmp_out),
			 .x_in(x_cnt_out),
			 .offset(acc_offset),
			 .incr(incr_in),
			 .acc_out(xp_out)
			 );

   
endmodule // xp_gen






`endif
