module cfg_fsm (
		clk,
		rst_n,

		dskw_start_in,
		dskw_done_in,
		
		soft_rst,

		in_img_start_addr,
		out_img_start_addr,
		img_dim,
		
		err_size,
		dskw_start_out,
		idle
		);

   //inputs
   input clk;
   input rst_n;
   input dskw_start_in;
   input soft_rst;
   input dskw_done_in;
   
   input [16:0] in_img_start_addr;
   input [16:0] out_img_start_addr;
   input [8:0]	img_dim;

   output reg err_size;
   output reg dskw_start_out;
   output reg idle;

   //FSM MODEL   
   localparam WAIT_START = 0,
	      CONFIG_CHECK = 1,
	      DSKW_START = 2,
	      DSKW_DONE = 3,
	      DEAD = 7;

   reg [2:0]  ctrl_ns;
   reg [2:0]  ctrl_cs;

   //CFG_CHECK wires:
   wire	      cfg_ok;
   wire	      cfg_check_done;
   reg	      cfg_check_en;   
   


   //STATE REGISTER
   always @(posedge clk or negedge rst_n)
     begin
	if(~rst_n)
	  ctrl_cs <= WAIT_START;
	else
	  ctrl_cs <= ctrl_ns;
     end

   //NEXT STATE AND OUTPUT LOGIC
   always @ (*)
     begin
	
	     /*
	      DEFAULT ASSIGNMENT SECTION
	      */
	     ctrl_ns = ctrl_cs;
	     cfg_check_en = 0;
	     err_size = 0;
	     dskw_start_out = 0;
	     idle = 0;

	     /*
	      END OF DEFAULT ASSIGNMENT SECTION
	      */
	     
	     case(ctrl_cs)

	       WAIT_START:
		 begin

		    idle = 1;
		    
		    if(~dskw_done_in & dskw_start_in)
		      begin
			 cfg_check_en = 1;
			 ctrl_ns = CONFIG_CHECK;
		      end
		    else
		      begin
			 ctrl_ns = WAIT_START;
		      end
		 end // case: WAIT_START

	       
	       CONFIG_CHECK:
		 begin
		    
		    idle = 0;
		    
		    if(cfg_check_done)
		      begin
			 cfg_check_en = 0;

			 if(cfg_ok)
			   begin
			      ctrl_ns = DSKW_START;
			   end
			 else
			   begin
			      ctrl_ns = DEAD;
			      err_size = 1;
			   end
		      end
		 end // case: CONFIG_CHECK

	       DSKW_START:
		 begin
		    dskw_start_out = 1;
		    ctrl_ns = DSKW_DONE;
		 end

	       DSKW_DONE:
		 begin
		    dskw_start_out = 0;
		    if(dskw_done_in)
		      begin
			 ctrl_ns = WAIT_START;
			 
		      end
		 end

	       DEAD:
		 begin
		    idle = 1;
		    if(soft_rst)
		      ctrl_ns = WAIT_START;
		    else
		      ctrl_ns = DEAD;
		 end

	       default:
		 begin
		    ctrl_ns = DEAD;
		 end
	       
	     endcase // case (ctrl_cs)
     end // always @ (*)

   
   ////////////////////////////////////////
   ////////////////////////////////////////
   ////////////////////////////////////////
   //CFG CHECK instance:

   cfg_check #(.IMG_DIM_WIDTH (9),
	       .ADDR_WIDTH (17))
   cfg_check_i(
	       .clk(clk),
	       .rst_n(rst_n),
	       .img_dim(img_dim),
	       .in_img_start_addr(in_img_start_addr),
	       .out_img_start_addr(out_img_start_addr),
	       .cfg_check_en(cfg_check_en),
	       .cfg_ok(cfg_ok),
	       .cfg_check_done(cfg_check_done)
	       );
   
   ////////////////////////////////////////
   ////////////////////////////////////////
   ////////////////////////////////////////
   

endmodule // cfg_check_fsm
