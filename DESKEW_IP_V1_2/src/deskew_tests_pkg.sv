`ifndef __DESKEW_TESTS_PKG_SV__
 `define __DESKEW_TESTS_PKG_SV__

package deskew_tests_pkg;
   import uvm_pkg::*;
 `include "uvm_macros.svh"

   import axi_lite_master_vip_pkg::*;

 `include "deskew_base_test.sv"
 `include "reg_access_test.sv"
   
endpackage // deskew_tests_pkg
   


`endif
