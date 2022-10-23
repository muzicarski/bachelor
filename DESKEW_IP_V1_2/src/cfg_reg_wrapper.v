`ifndef __CFG_REG_WRAPPER__
 `define __CFG_REG_WRAPPER__

module cfg_reg_wrapper
  #(parameter REG_ADDR = 0, parameter REG_ADDR_WIDTH = 8)

   (clk,
    rst_n,

    set,
    write_en,

    addr_in,

    pulse_out);


   

   //INPUTS:
   input			clk;
   input			rst_n;

   input			set;
   input			write_en;

   input [REG_ADDR_WIDTH-1 : 0]	addr_in;

   //Outputs

   output 			pulse_out;
   


   //========================================//

   wire comp_addr_out;
   wire en;
   wire	next_reg_val;

   reg	reg_val;
   reg	reg_val_r; //double registered 
   

   //Address comparison:
   assign comp_addr_out = (addr_in == REG_ADDR) ? 1 : 0;

   //Reg Write enable
   assign en = write_en & comp_addr_out;

   assign next_reg_val = en && set;

   //Signal for pulse detection:
   always @(posedge clk or negedge rst_n)
     if(~rst_n)
       reg_val <= 0;
     else
       reg_val <= next_reg_val;

   //Pulse generation input 2
   always @(posedge clk or negedge rst_n)
     if(~rst_n)
       reg_val_r <= 0;
     else
       reg_val_r <= reg_val;


   //Pulse generation
   assign pulse_out = ~reg_val & reg_val_r;
   
endmodule // cfg_reg_wrapper




`endif
