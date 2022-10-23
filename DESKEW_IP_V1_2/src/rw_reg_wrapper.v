`ifndef __RW_REG__
 `define __RW_REG__

module rw_reg_wrapper  
  #(parameter REG_ADDR = 8'h00, parameter RST_DATA = 0)
  
   (//Sync
    clk,
    rst_n,
   
    //Data
    data_in,
    write_en,
    data_out,

    //Addr
    addr_in
    );


   localparam REG_DATA_WIDTH = 32;
   localparam REG_ADDR_WIDTH = 8;

   
   //INPUTS
   input clk;
   input rst_n;

   input write_en;

   input [REG_ADDR_WIDTH-1 : 0] addr_in;
   input [REG_DATA_WIDTH-1 : 0] data_in;
   
   //OUTPUTS
   output reg [REG_DATA_WIDTH-1 : 0] data_out;


   //========================================//

   wire comp_addr_out;
   wire en;

   //Address comparison:
   assign comp_addr_out = (addr_in == REG_ADDR) ? 1 : 0;

   //Reg Write enable
   assign en = write_en & comp_addr_out;
     
   always @(posedge clk or negedge rst_n)
     begin
       if (~rst_n)
	 data_out <= RST_DATA;
       else if (en)
	 data_out <= data_in;
     end

   

   
endmodule // rw_reg_wrapper



	       
	       
  


`endif
