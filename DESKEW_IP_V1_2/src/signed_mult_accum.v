`ifndef __SIGNED_MULT_ACCUM__
 `define __SIGNED_MULT_ACCUM__
(* use_dsp = "yes" *) module signed_mult_accum
  #(parameter A_IN_WIDTH = 8,
    parameter B_IN_WIDTH = 8,
    parameter ACC_OUT_WIDTH = 29)
   (
    dataa,
    datab,
    clk,
    aclr,
    clken,
    mac_out
    );


   input signed [A_IN_WIDTH-1 : 0] dataa;
   
   input signed [B_IN_WIDTH-1 : 0] datab;
   
   input			   clk, aclr, clken;
   
   output signed [ACC_OUT_WIDTH-1 : 0] mac_out;
   
   // Declare registers and wires
   reg signed [A_IN_WIDTH-1 : 0]	     dataa_reg;
   reg signed [B_IN_WIDTH-1 : 0]	     datab_reg;
   reg signed [ACC_OUT_WIDTH-1 : 0]	     old_result;
   reg signed [ACC_OUT_WIDTH-1 : 0]	     mac_out_r;
   reg signed [ACC_OUT_WIDTH-1 : 0]	     mac_out_2r;
   reg signed [ACC_OUT_WIDTH-1 : 0]	     mac_out_3r;
   //wire signed [ACC_OUT_WIDTH-1 : 0]      multa;
   
   //Store the results of the operations on the current data
   //assign multa = dataa_reg * datab_reg;
   // Clear or update data, as appropriate
   always @ (posedge clk)
     begin
	if (aclr)
	  begin
	     dataa_reg <= 0;
	     datab_reg <= 0;
	     mac_out_r <= 0;
	     mac_out_2r <= 0;
	     mac_out_3r <= 0;
	  end
	
	else if (clken)
	  begin
	     dataa_reg <= dataa;
	     datab_reg <= datab;
	     mac_out_r <= mac_out_r + dataa_reg * datab_reg;//multa;	     
	     mac_out_2r <= mac_out_r;	     
	     mac_out_3r <= mac_out_2r;
	  end
     end
     
   assign mac_out = mac_out_3r;
endmodule // mult_accum
`endif
