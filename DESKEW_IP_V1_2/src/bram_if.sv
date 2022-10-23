`ifndef __BRAM_IF_SV__
 `define __BRAM_IF_SV__

interface bram_if (input clk, input rst_n);

   logic web;
   logic enb;

   logic [7:0] rdata;
   logic [7:0] wdata;

   logic [16:0]	addr;
   

endinterface // bram_if

   





`endif
