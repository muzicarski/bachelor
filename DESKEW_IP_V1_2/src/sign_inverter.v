`ifndef __SIGN_INVERTER__
 `define __SIGN_INVERTER__

module sign_inverter  #(parameter WIDTH = 8) (
					      clk,
					      rst_n,
					      a_in,
					      b_out
					      );

   input clk;
   input rst_n;
   input [WIDTH-1 : 0] a_in;
   output reg [WIDTH-1 : 0] b_out;

   wire [WIDTH-1 : 0]	    a_in_inverted;

   assign a_in_inverted = ~a_in;

   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
	  b_out <= 0;
	else
	  b_out <= a_in_inverted + 1;
     end
   
endmodule // sign_inverter




`endif
