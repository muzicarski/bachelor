`ifndef __ADDR_ACC__
 `define __ADDR_ACC__

module addr_acc (clk,
		 rst_n,

		 en,
		 sclr,

		 offset,
		 x_in,
		 incr,

		 addr_out
		 );


   //This is a custom addr gen and bus widths are known.

   input clk;
   input rst_n;
   input en;
   input sclr;

   input [8:0] incr;
   input [8:0] x_in;
   input [16:0] offset;
   
   

   output [16:0] addr_out;


   //------------------------------//
   // Internal wires/signals

   //Adder 0 and accumulator
   reg [17:0]	     y_addr_acc;
   wire [17:0]	     adder0_out;
   wire [16:0]	     adder0_in0;

   //Ouput adder:
   wire [17:0]	     adder1_out;
   wire [17:0]	     adder2_out;
   
   
   
   assign adder0_in0 = {8'h00, incr};
   assign adder0_out = y_addr_acc[16:0] + adder0_in0;

   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
	  y_addr_acc <= 0;
	else begin
	   if(sclr)
	     y_addr_acc <= 0;
	   else if(en)
	     y_addr_acc <= adder0_out;
	end
     end // always @ (posedge clk or negedge rst_n)

   assign adder1_out = y_addr_acc[16:0] + {8'h00, x_in};
   assign adder2_out = adder1_out[16:0] + offset;
     
   assign addr_out = adder2_out[16:0];
   
   

endmodule // addr_acc





`endif
