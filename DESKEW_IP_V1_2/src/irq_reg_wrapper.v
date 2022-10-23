`ifndef __IRQ_REG_WRAPPER__
 `define __IRQ_REG_WRAPPER__


module irq_reg_wrapper
  #(parameter ACK_REG_ADDR = 0, parameter REG_ADDR_WIDTH = 8)

   (clk,
    rst_n,

    set,
    ack_in,

    write_en,
    addr_in,

    data_out,
    ack_out);

   //----------------------------------------//
   
   //INPUTS

   input			clk;
   input			rst_n;

   input			set;
   input			ack_in;

   input			write_en;
   input [REG_ADDR_WIDTH-1 : 0]	addr_in;

   output 			data_out;
   output			ack_out;

   //================================================================================//


  wire				comp_addr_out;
  wire				ack_en;
  wire				clr;

  reg				data_out_r;
   

   //Address comparison:
   assign comp_addr_out = (addr_in == ACK_REG_ADDR) ? 1 : 0;

   //Acknowlegde enable
   assign ack_en = write_en & comp_addr_out;

   //reg data clear condition
   assign clr = ack_en && ack_in;

   //ACK to Control unit:
   assign ack_out = comp_addr_out && clr;

   //Signal for pulse detection:
   always @(posedge clk or negedge rst_n)
     if(~rst_n)
       data_out_r <= 1'b0;
     else 
       begin
	  if(clr)
	    data_out_r <= 1'b0;
	  else if(set)
	    data_out_r <= 1'b1;
	  else
	    data_out_r <= data_out_r;
       end

   assign data_out = data_out_r;


endmodule // irq_reg_wrapper








`endif
