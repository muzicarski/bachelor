`ifndef __BRAM_IF_CTRL__
 `define __BRAM_IF_CTRL__

module bram_if_ctrl (//Sync
		     clk,
		     rst_n,

		     //Input control
		     en,
		     wr,

		     //internal 
		     rdata_rdy,
		     rdata_out,
		     wdata_in,

		     //BRAM if:
		     rdata_in,
		     enb,
		     web,
		     wdata_out,

		     addr_in,
		     addrb
		     );

   input clk;
   input rst_n;

   input wr;
   input en;

   output enb;
   output web;
   

   input [7:0] wdata_in;
   output [7:0]	wdata_out;   
   output [7:0]	rdata_out;
   output [16:0] addrb;
   input [16:0]	 addr_in;
   input [7:0]	 rdata_in;
   
   output reg	 rdata_rdy;


   assign rdata_out = rdata_in;
   assign wdata_out = wdata_in;
   assign addrb = addr_in;
   assign enb = en;
   

   wire		 read_reg;


   always @(posedge clk or negedge rst_n)
     if(~rst_n)
       rdata_rdy <= 1'b0;
     else
       rdata_rdy <= read_reg;


   assign read_reg = en & (~wr);

   assign web = wr & en;

   
endmodule // bram_if_ctrl




`endif
