`ifndef __TOP_TB_SV__
 `define __TOP_TB_SV__

 `timescale 1ns/100ps

module top_tb;

   import uvm_pkg::*;
 `include "uvm_macros.svh"
   
   import axi_lite_master_vip_pkg::*;
   import bram_uvm_pkg::*;
   import deskew_tests_pkg::*;

   logic clk;
   logic rst_n;
   
   logic irq;
   
   bram_monitor_c m_monitor;
   
   wire bram_clk;
   wire bram_resetn;
   wire [7:0]  wdata;
   wire [7:0]  rdata;
   wire [16:0] addr;
   wire	       enb;
   wire	       web;


   bram_if i_bram_if (bram_clk, bram_resetn);

   assign i_bram_if.wdata = wdata;
   assign i_bram_if.rdata= rdata;
   assign i_bram_if.addr = addr; 
   assign i_bram_if.enb  = enb;  
   assign i_bram_if.web  = web;  

   
   //Instantiate axi interface
   axi_lite_if axi_if(clk, rst_n);
   //Instantiation:
   
   deskew_top dsqw_0 
                    (.clk(clk),
		     .resetn(rst_n),

		     .axis_waddr(axi_if.waddr),       
		     .axis_waddr_valid(axi_if.waddr_valid), 
		     .axis_waddr_ready(axi_if.waddr_ready),


		     .axis_wdata(axi_if.wdata),       
		     .axis_wdata_valid(axi_if.wdata_valid), 
		     .axis_wdata_ready(axi_if.wdata_ready),


		     .axis_bresp(axi_if.bresp),       
		     .axis_bresp_valid(axi_if.bresp_valid), 
		     .axis_bresp_ready(axi_if.bresp_ready),

		     .axis_raddr(axi_if.raddr),       
		     .axis_raddr_valid(axi_if.raddr_valid), 
		     .axis_raddr_ready(axi_if.raddr_ready),

		     .axis_rdata(axi_if.rdata),       
		     .axis_rdata_valid(axi_if.rdata_valid), 
		     .axis_rdata_ready(axi_if.rdata_ready), 
		     .axis_rresp(axi_if.rresp),


		     .deskew_irq(irq),
             .bram_clk(bram_clk),
             .bram_resetn(bram_resetn),
		     .paddr(addr),
		     .pwdata(wdata),
		     .prdata(rdata),
		     .pen(enb),
		     .pwen(web)

                     );
   
      bram_gen_wrapper u_bram
     (.BRAM_PORTA_0_addr(    addr),
      .BRAM_PORTA_0_clk(	  bram_clk),
      .BRAM_PORTA_0_din(	  wdata),
      .BRAM_PORTA_0_dout(	  rdata),
      .BRAM_PORTA_0_en(	  enb),
      .BRAM_PORTA_0_we(     web)
      );

   //Testbench driving:

   initial begin
      m_monitor = bram_monitor_c::type_id::create("m_monitor", null);
      m_monitor.cfg_mon(i_bram_if,
        		       (255*255*4),
		                64);
      rst_n = 1;
      clk = 0;
      #4;
      rst_n = 0;
      #33;
      rst_n = 1;

      //$finish;
            
   end
  
   initial begin

      uvm_config_db#(virtual axi_lite_if)::set(null, "*", "axi_lite_if", axi_if);
      run_test();
   end


   always #5 clk <= ~clk;
   
   
endmodule // top_tb





`endif
