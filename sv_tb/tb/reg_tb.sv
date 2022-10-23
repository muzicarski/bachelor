`ifndef __REG_BLOCK_TB__
 `define __REG_BLOCK_TB__

 `timescale 1ns/1ns;

module reg_tb;



   logic clk = 0;
   logic rst_n = 1;


   logic read_reg = 0;       
   logic write_reg = 0;      
   logic [31:0]	reg_wdata;      
   logic [31:0]	reg_rdata;      
   logic [7:0]	reg_raddr;      
   logic [7:0]	reg_waddr;
   
   logic [8:0]	img_w_l;
   logic [16:0]	start_addr_in;  
   logic [16:0]	start_addr_out; 
   logic	start_deskew;   
   logic	soft_rst;
   
   logic	mem_acc_err = 0;    
   logic	err_size = 0;       
   logic	done = 0;           
   logic	idle = 0;

   logic	mem_acc_err_ack;
   logic	err_size_ack;
   logic	done_ack;



   deskew_reg_block rg_blk0(
                            .clk(           clk),           
                            .rst_n(         rst_n),         

                            //AXI2REG      //AXI2REG      
                            .read_reg(      read_reg),      
                            .write_reg(     write_reg),     

                            .reg_wdata(     reg_wdata),     
                            .reg_rdata(     reg_rdata),     

                            .reg_raddr(     reg_raddr),     
                            .reg_waddr(     reg_waddr),     

                            //REG2CTRL     //REG2CTRL     
                            .mem_acc_err(   mem_acc_err),   
                            .err_size(      err_size),      
                            .done(          done),          
                            .idle(          idle),          
                            .mem_acc_err_ack(mem_acc_err_ack),
                            .err_size_ack(  err_size_ack),  
                            .done_ack(      done_ack),      
                            .img_w_l(       img_w_l),       
                            .start_addr_in( start_addr_in), 
                            .start_addr_out(start_addr_out),
                            .start_deskew(  start_deskew),  
                            .soft_rst       (soft_rst)       

                            );
   
   


   always #10 clk <= ~clk;


   initial begin : INITIAL_RESET
      #1 rst_n <= 0;
      repeat(2) @(posedge clk);

      @(negedge clk);

      rst_n <= 1;
   end  //block : INITIAL_RESET

   initial begin

      @(posedge rst_n);

      //====================//
      //Continous write:
      
      @(posedge clk);
      reg_wdata <= 32'h00000003;      //Set both fields
      write_reg <= 1'b1;
      reg_waddr <= 8'h00;
      

      repeat(15) begin
	 @(posedge clk);
	 reg_waddr <= reg_waddr + 1;
	 reg_wdata <= $urandom();
      end

      @(posedge clk);

      write_reg <= 0;

      repeat(10) @(posedge clk);

      //READ DSQW_STAT (all but IDLE should be set)
      read_reg <= 1'b1;
      reg_raddr <= 8'h0c;
      @(posedge clk);
      read_reg <= 0;
      @(posedge clk);      
      
      //Clear all interrupts: //Write to DSQW_ACK
      write_reg <= 1'b1;
      reg_waddr <= 8'h10;
      reg_wdata <= 32'h000000ff;
      @(posedge clk);
      write_reg <= 0;
      @(posedge clk);      

      //READ DSQW_STAT (all but IDLE should be set)
      read_reg <= 1'b1;
      reg_raddr <= 8'h0c;
      @(posedge clk);
      read_reg <= 0;
      @(posedge clk);      
      

      repeat(10) @(posedge clk);

      
      //==============================//
      @(posedge clk);

      reg_raddr <= 8'h00;
      read_reg  <= 1'b1;

      @(posedge clk);

      read_reg  <= 1'b0;
      //==============================//

      @(posedge clk);
      reg_raddr <= 8'h04;
      read_reg  <= 1'b1;
      @(posedge clk);
      read_reg  <= 1'b0;
      
      //==============================//
      @(posedge clk);
      reg_raddr <= 8'h05;
      read_reg  <= 1'b1;
      @(posedge clk);
      read_reg  <= 1'b0;

      //==============================//
      @(posedge clk);
      reg_raddr <= 8'h05;
      read_reg  <= 1'b1;
      @(posedge clk);
      read_reg  <= 1'b0;

      //==============================//
      @(posedge clk);
      reg_raddr <= 8'h0c;
      read_reg  <= 1'b1;
      @(posedge clk);
      read_reg  <= 1'b0;
      //==============================//

      //NOW DO A CONTINUOS READ FROM ALL ADDRESSES

      read_reg <= 1'b1;
      reg_raddr <= 8'h00;

      repeat(15) begin
	 @(posedge clk);
	 reg_raddr <= reg_raddr + 1;
      end

      @(posedge clk);

      read_reg <= 0;

      repeat(10) @(posedge clk);
      
      $finish;
   end // initial begin

   ////////////////////////////////////////////////////////////////////////////////

   //Interrupts section:

   initial begin
      @(posedge rst_n);

      @(posedge clk);

      mem_acc_err <= 1'b1;
      err_size <= 1'b1;
      idle <= 0;
      done <= 1'b1;
      
   end // initial begin

   always @(posedge mem_acc_err_ack)
     mem_acc_err <= 0;

   always @(posedge err_size_ack)
     err_size <= 0;

   always @(posedge done_ack)
     done <= 0;

   
endmodule




`endif
