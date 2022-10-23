`ifndef __AXI_LITE_MASTER_VIP_PKG_SV___
 `define __AXI_LITE_MASTER_VIP_PKG_SV___

package axi_lite_master_vip_pkg;

   import uvm_pkg::*;
 `include "uvm_macros.svh"

 `include "axi_lite_master_types_and_defines.sv"
 `include "axi_lite_master_cfg.sv"
 `include "axi_lite_master_seq_item.sv"
 `include "axi_lite_master_sqr.sv"
 `include "axi_lite_master_drv.sv"
 `include "axi_lite_master_agent.sv"

 `include "seq_lib/axi_lite_master_base_seq.sv"
   
endpackage // axi_lite_master_vip_pkg
   



`endif
