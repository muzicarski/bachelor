 `ifndef __ADDR_GEN__
 `define __ADDR_GEN__

module addr_gen (//Sync:
		 clk,
		 rst_n,
		 //Ctrl:
		 en,
		 sclr,
		 //Limit
		 img_dim,
		 //Output:
		 addr_out,

		 //offset
		 addr_offset,
		 
		 //Counter values out:
		 x_cnt,
		 y_cnt
		 
		 );

   ///////////////////////
  //P O R T S   L I S T//
  ///////////////////////

   input clk;
   input rst_n;

   input en;
   input sclr;

   input [8:0] img_dim;

   input [16:0]	addr_offset;

   output [16:0] addr_out;

   output [8:0]	 x_cnt;
   output [8:0]	 y_cnt;

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
   assign x_cnt_en = en & y_cmp_out;

   //Outputs:
   assign x_cnt = x_cnt_out;
   assign y_cnt = y_cnt_out;


   //Parts instantiation:

   //X-Coordinate counter:

   addr_counter u_x_cnt0(.clk(clk),
			 .rst_n(rst_n),
			 .en(y_cmp_out),
			 .sclr(sclr),
			 .count_out(x_cnt_out)
			 );

   addr_counter u_y_cnt0(.clk(clk),           
			 .rst_n(rst_n),       
   			 .en(en),       
   			 .sclr(y_cnt_sclr),         
   			 .count_out(y_cnt_out)
   			 );                   
   

   addr_acc u_addr_acc0 (.clk(clk),
			 .rst_n(rst_n),
			 .en(en),
			 .sclr(y_cmp_out),
			 .x_in(x_cnt_out),
			 .offset(addr_offset),
			 .incr(img_dim),
			 .addr_out(addr_out)
			 );

   
endmodule // addr_gen






`endif
