`ifndef __SKEW_ACC__
 `define __SKEW_ACC__

module skew_acc (
     clk,
		 rst_n,

		 en,
		 sclr,

		 offset,
		 x_in,
		 incr,

		 acc_out
		 );


   //This is a custom addr gen and bus widths are known.

   input clk;
   input rst_n;
   input en;
   input sclr;

   input [23:0] incr;
   input [7:0] x_in;
   input [23:0] offset;
   
   

   output [23:0] acc_out;


   //------------------------------//
   // Internal wires/signals

   //Adder 0 and accumulator
   reg [23:0]	     y_skew_acc;
   wire [23:0]	   adder0_out;
   wire [23:0]	   adder0_in0;

   //Ouput adder:
   wire [23:0]	   adder1_out;
   wire [23:0]	   adder2_out;
   
   
   
   assign adder0_in0 = incr;
   assign adder0_out = y_skew_acc + adder0_in0;

   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
	  y_skew_acc <= 0;
	else begin
	   if(sclr)
	     y_skew_acc <= 0;
	   else if(en)
	     y_skew_acc <= adder0_out;
	end
     end // always @ (posedge clk or negedge rst_n)

   assign adder1_out = y_skew_acc + {7'h00, x_in, 9'h000};
   assign adder2_out = adder1_out + offset;
     
   assign acc_out = adder2_out;
   
   

endmodule // skew_acc





`endif
