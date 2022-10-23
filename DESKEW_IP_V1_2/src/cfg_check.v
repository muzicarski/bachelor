module cfg_check
  #(parameter IMG_DIM_WIDTH = 9,
    parameter ADDR_WIDTH = 17)
   
        (
	     clk,
	     rst_n,

	     img_dim,
	     in_img_start_addr,
	     out_img_start_addr,

	     cfg_check_en,
	     
	     cfg_ok,
	     cfg_check_done
	     );

   input clk;
   input rst_n;

   input [IMG_DIM_WIDTH-1 : 0]	img_dim;
   input [ADDR_WIDTH-1 : 0]	in_img_start_addr;
   input [ADDR_WIDTH-1 : 0]	out_img_start_addr;
   input cfg_check_en;

   output reg cfg_ok;
   output reg cfg_check_done;

   //FSM MODEL
   localparam IDLE = 0,
	      WAIT_MULT = 1,
	      CHECK_CFG = 2;

   reg [1:0]  cfg_ns;
   reg [1:0]  cfg_cs;


   //MULTIPLIER INTERFACE
   reg	      mult_en;
   wire	      mult_done;
   wire [IMG_DIM_WIDTH*2-1:0] p_out;
   reg  [IMG_DIM_WIDTH*2-1:0] img_len_r;
   
   

   always @ (posedge clk or negedge rst_n)
     begin
	if(~rst_n)
	  cfg_cs <= IDLE;
	else
	  cfg_cs <= cfg_ns;
     end


   always @ (*) begin
     
	   cfg_check_done = 0;
	   cfg_ok = 0;
	   cfg_ns = IDLE;
	   mult_en = 0;

	   case (cfg_cs)

	     IDLE:
	       begin

		  cfg_check_done = 0;
		  
		  if(cfg_check_en)
		    begin
		       mult_en = 1;
		       cfg_ns = WAIT_MULT;
		    end
		  else
		    cfg_ns = IDLE;
	       end

	     WAIT_MULT:
	       begin
		  mult_en = 0;
		  
		  if(mult_done) begin
		     cfg_ns = CHECK_CFG;
		  end
		  else begin
		     cfg_ns = WAIT_MULT;
		  end
	       end

	     CHECK_CFG:
	       begin
		  if( (img_dim < 16)                                              ||  //NOT TESTED FOR LESS
		      ( in_img_start_addr == out_img_start_addr)                  ||
		      (in_img_start_addr + img_len_r  > ({ADDR_WIDTH{1'b1}} + 1)) ||
		      (out_img_start_addr + img_len_r > ({ADDR_WIDTH{1'b1}} + 1))
		      )
		    
		    cfg_ok = 0;
		  
		  else if (in_img_start_addr < out_img_start_addr)
		    begin
		       if(in_img_start_addr + img_len_r >= out_img_start_addr)
			 cfg_ok = 0;
		       else
			 cfg_ok = 1;
		    end
		  
		  else if (in_img_start_addr > out_img_start_addr)
		    begin
		       if(out_img_start_addr + img_len_r >= in_img_start_addr)
			 cfg_ok = 0;
		       else
			 cfg_ok = 1;
		    end
		  
		  else
		    cfg_ok = 1;

		  cfg_check_done = 1;
		  cfg_ns = IDLE;
		  
	       end // case: CHECK_CFG
	       
	       default: 
	       begin
	           cfg_check_done = 0;
	           cfg_ok = 0;
	           cfg_ns = IDLE;
	           mult_en = 0;
	       end

	   endcase // case (cfg_cs)
	
     end // always @ (*)


   ////////////////////////////////////////

   always @ (posedge clk or negedge rst_n)
     begin
	if (~rst_n)
	  img_len_r = 0;
	else if (mult_done)
	  img_len_r = p_out;
	else
	  img_len_r = img_len_r;
     end

   ////////////////////////////////////////
   
   dim_mult #(.A_IN_WIDTH(IMG_DIM_WIDTH),
	      .B_IN_WIDTH(IMG_DIM_WIDTH))
   mult_i (
	   .clk(clk),
	   .rst_n(rst_n),
	   .a_in(img_dim),
	   .b_in(img_dim),
	   .p_out(p_out),
	   .en(mult_en),
	   .done(mult_done)
	   );
   ////////////////////////////////////////
   
endmodule // cfg_check

     

