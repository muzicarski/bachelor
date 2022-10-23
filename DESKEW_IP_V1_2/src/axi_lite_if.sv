`ifndef __AXI_LITE_IF_SV__
 `define __AXI_LITE_IF_SV__

interface axi_lite_if (input clk, input rst_n);

   parameter			  AXI_ADDR_WIDTH = 32;
   parameter			  AXI_DATA_WIDTH = 32;
   

   logic			  waddr_valid;
   logic			  waddr_ready;
   logic [AXI_ADDR_WIDTH - 1 : 0] waddr;

   logic			  wdata_valid;
   logic			  wdata_ready;
   logic [AXI_DATA_WIDTH - 1 : 0] wdata;

   logic [1:0]			  bresp;
   logic			  bresp_valid;
   logic			  bresp_ready;
   
   logic			  raddr_valid;
   logic			  raddr_ready;
   logic [AXI_ADDR_WIDTH - 1 : 0] raddr;

   logic			  rdata_valid;
   logic			  rdata_ready;
   logic [AXI_DATA_WIDTH - 1 : 0] rdata;
   logic [1:0]			  rresp;
				  
				  
endinterface // axi_lite_if




`endif
   
