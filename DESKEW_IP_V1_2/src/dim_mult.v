(* use_dsp = "yes" *) module dim_mult //USE_DSP - vivado synth attribute
#(parameter A_IN_WIDTH = 9,
  parameter B_IN_WIDTH = 9)
        (
	     clk,
	     rst_n,
	     
	     a_in,
	     b_in,
	     
	     en,
	     done,

	     p_out
	     );

  

   localparam P_OUT_WIDTH = A_IN_WIDTH + B_IN_WIDTH;


   input      clk;
   input      rst_n;

   input      en;
   output     done;
   
   input [A_IN_WIDTH - 1 : 0] a_in;
   input [B_IN_WIDTH - 1 : 0] b_in;

   output [P_OUT_WIDTH - 1 : 0] p_out;


   //========================================//

   reg					 en_r;
   reg					 en_2r;
   reg					 en_3r;
   reg					 en_4r;   

   reg					 mult_result_r;
   reg					 mult_result_2r;
   reg					 mult_result_3r;

   reg [A_IN_WIDTH-1 : 0]		 a_in_reg;
   reg [B_IN_WIDTH-1 : 0]		 b_in_reg;   

   always @ (posedge clk)
     begin
	if(~rst_n) begin
	   en_r 	  <= 0;
	   en_2r 	  <= 0;
	   en_3r 	  <= 0;
	   en_4r 	  <= 0;	   
	   mult_result_r  <= 0;
	   mult_result_2r <= 0;
	   mult_result_3r <= 0;
	   a_in_reg 	  <= 0;
	   b_in_reg 	  <= 0;

	end
	else begin

	   a_in_reg <= a_in;
	   b_in_reg <= b_in;
	   
	   en_r <= en;
	   en_2r <= en_r;
	   en_3r <= en_2r;
	   en_4r <= en_3r;

	   mult_result_3r <= mult_result_2r;	   
	   mult_result_2r <= mult_result_r;
	   mult_result_r <= a_in_reg * b_in_reg;

	end
     end

   assign p_out = mult_result_3r;
   assign done = en_4r;
   
endmodule // dim_mult
