`ifndef __DSQW_IRQ_CTRL_V__
 `define __DSQW_IRQ_CTRL_V__

module dsqw_irq_ctrl(
		     //CRM - inputs

		     clk,
		     rst_n,

		     //IRQs
		     dsqw_done,
		     err_size,
		     mem_acc_err,

		     dsqw_done_ack,
		     err_size_ack,
		     mem_acc_err_ack,

		     //output:
		     dsqw_done_out,
		     err_size_out,
		     mem_acc_err_out,
		     dsqw_irq
		     
		     );


   input clk;
   input rst_n;

   input dsqw_done;
   input err_size;
   input mem_acc_err;

   input dsqw_done_ack;
   input err_size_ack;
   input mem_acc_err_ack;


   output reg dsqw_irq;

   output     dsqw_done_out;
   output     err_size_out;
   output     mem_acc_err_out;

   reg dsqw_done_r;
   reg err_size_r;
   reg mem_acc_err_r;


   //General output

   always @ (posedge clk or negedge rst_n)
     begin
	if(~rst_n)
	  dsqw_irq = 0;
	else
	  dsqw_irq = dsqw_done_r | err_size_r | mem_acc_err_r;
     end


   //DONE IRQ
   always @ (posedge clk or negedge rst_n)
     begin
	if(~rst_n)
	  dsqw_done_r = 0;
	else
	  begin
	     if(dsqw_done_ack)
	       dsqw_done_r = 0;
	     else if(dsqw_done)
	       dsqw_done_r = 1;
	     else
	       dsqw_done_r = dsqw_done_r;
	  end
     end


   //ERR SIZE IRQ
   always @ (posedge clk or negedge rst_n)
     begin
	if(~rst_n)
	  err_size_r = 0;
	else
	  begin
	     if(err_size_ack)
	       err_size_r = 0;
	     else if(err_size)
	       err_size_r = 1;
	     else
	       err_size_r = err_size_r;
	  end
     end // always @ (posedge clk or negedge rst_n)



   //MEM ACC ERR IRQ
   always @ (posedge clk or negedge rst_n)
     begin
	if(~rst_n)
	  mem_acc_err_r = 0;
	else
	  begin
	     if(mem_acc_err_ack)
	       mem_acc_err_r = 0;
	     else if(mem_acc_err)
	       mem_acc_err_r = 1;
	     else
	       mem_acc_err_r = mem_acc_err_r;
	  end
     end // always @ (posedge clk or negedge rst_n)


   //----------------------------------------//
   assign dsqw_done_out = dsqw_done_r;
   assign err_size_out = err_size_r;
   assign mem_acc_err_out = mem_acc_err_r;
   
   
   
endmodule // dsqw_irq_ctrl




`endif
