`ifndef __DATAPATH_TB__
 `define __DATAPATH_TB__

module datapath_tb();

 `include "bram_monitor.sv"
   
   bram_monitor_c m_monitor;

   logic clk = 0;

   logic rst_n = 1;


   logic [8:0] img_dim;
   logic [16:0]	in_img_addr =0;
   logic [16:0]	out_img_addr = 0;
   logic       start_calc_moments = 0;
   logic       calc_moments_done;
   logic       deskew_moments_out;
   wire [7:0]  wdata;
   wire [7:0]  rdata;
   wire [16:0] addr;
   wire	       enb;
   wire	       web;


   bram_if i_bram_if (clk, rst_n);

   assign i_bram_if.wdata = wdata;
   assign i_bram_if.rdata= rdata;
   assign i_bram_if.addr = addr; 
   assign i_bram_if.enb  = enb;  
   assign i_bram_if.web  = web;  


   deskew_datapath_top u_dut
     (.clk(               clk),
      .rst_n(             rst_n),
      .img_dim(           img_dim),
      .in_img_start_addr (in_img_addr),
      .out_img_start_addr(out_img_addr),
      .start_calc_moments(start_calc_moments),
      .calc_moments_done (calc_moments_done),
      .deskew_done_out   (deskew_done_out),
      .rdata(             rdata),
      .enb(               enb),
      .web(               web),
      .wdata(             wdata),
      .addr(              addr)
      );


   bram_gen_wrapper u_bram
     (.BRAM_PORTA_0_addr(    addr),
      .BRAM_PORTA_0_clk(	  clk),
      .BRAM_PORTA_0_din(	  wdata),
      .BRAM_PORTA_0_dout(	  rdata),
      .BRAM_PORTA_0_en(	  enb),
      .BRAM_PORTA_0_we(     web)
      );



   //Clock gen:
   always #10ns clk <= ~clk;

   initial begin

      rst_n = 1;

      #7 rst_n = 0;

      #33ns;

      rst_n = 1;
   end


   initial begin

      m_monitor = new (i_bram_if,
		       (255*255*4),
		       64);

      m_monitor.run();
            

      @(posedge rst_n);

      @(posedge clk);
      
      img_dim = 9'h040;
      in_img_addr = 17'h00000;
      out_img_addr = 17'h10000;      
      
      repeat(5) @(posedge clk);

      start_calc_moments = 1;

      @(posedge clk);
      
      start_calc_moments = 0;
      
      wait(calc_moments_done == 1);

      wait(deskew_done_out == 1);

      m_monitor.set_done();
      
      repeat(10) @(posedge clk);
      
      $finish;
      
   end // initial begin








endmodule // datapath_tb




`endif
