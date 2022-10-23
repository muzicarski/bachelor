`ifndef __MULT_ACCUM__
 `define __MULT_ACCUM__

(* use_dsp = "yes" *) module mult_accum
  #(parameter A_IN_WIDTH = 8,
    parameter B_IN_WIDTH = 8,
    parameter ACC_OUT_WIDTH = 29)
   (
    input [A_IN_WIDTH-1 : 0]	     dataa,
    input [B_IN_WIDTH-1 : 0]	     datab,
    input			     clk, aclr, clken, sload,
    output reg [ACC_OUT_WIDTH-1 : 0] mac_out
    );

   // Declare registers and wires
   reg [A_IN_WIDTH-1 : 0]	     dataa_reg;
   reg [B_IN_WIDTH-1 : 0]	     datab_reg;
   reg				     sload_reg;
   reg [ACC_OUT_WIDTH-1 : 0]	     old_result;
   wire [ACC_OUT_WIDTH-1 : 0]	     multa;
   
   // Store the results of the operations on the current data
   assign multa = dataa_reg * datab_reg;
   
   // Store the value of the accumulation (or clear it)
   always @ (mac_out, sload_reg)
     begin
	if (sload_reg)
	  old_result <= 0;
	else
	  old_result <= mac_out;
     end
   
   // Clear or update data, as appropriate
   always @ (posedge clk or posedge aclr)
     begin
	if (aclr)
	  begin
	     dataa_reg <= 0;
	     datab_reg <= 0;
	     sload_reg <= 0;
	     mac_out <= 0;
	  end
	
	else if (clken)
	  begin
	     dataa_reg <= dataa;
	     datab_reg <= datab;
	     sload_reg <= sload;
	     mac_out <= old_result + multa;
	  end
     end
endmodule // mult_accum
`endif
