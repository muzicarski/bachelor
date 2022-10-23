`ifndef ADDR_COUNTER_V
 `define ADDR_COUNTER_V

//========================================//
//addr_counter//
//Used to count X and Y coordinates and
//generate next adress for the pixel to
//be read from mem or written to it.
//========================================//


module addr_counter (
		     //Inputs:
		     clk,
		     rst_n,
		     en,
		     sclr,
		     //Output:
		     count_out
		     );

   localparam CNT_WIDTH = 9;

   input      clk;
   input      rst_n;
   input      sclr;
   input      en;

   output [CNT_WIDTH-1 : 0] count_out;
   reg [CNT_WIDTH-1 : 0]    cnt_r;
   

   always @(posedge clk or negedge rst_n)
     begin
	if(rst_n == 1'b0)
	  cnt_r <= 0;
	else if(sclr == 1'b1)
	  cnt_r <= 0;
	else if(en == 1'b1)
	  cnt_r <= cnt_r + 1;
	else
	  cnt_r <= cnt_r;
     end

   assign count_out = cnt_r;
   

			 
endmodule // addr_counter




`endif
