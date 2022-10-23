create_project deskew_dev ../work/deskew_dev -part xc7z010clg400-1 -force
set_property board_part digilentinc.com:zybo-z7-10:part0:1.1 [current_project]
set_property  ip_repo_paths  {../DESKEW_IP_V1_2 ../addr_router_32bit_align_IP} [current_project]
update_ip_catalog
create_bd_design "deskew_system"
update_compile_order -fileset sources_1
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
endgroup
set_property -dict [list CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} CONFIG.PCW_USE_FABRIC_INTERRUPT {1} CONFIG.PCW_IRQ_F2P_INTR {1}] [get_bd_cells processing_system7_0]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:user:deskew_top:1.0 deskew_top_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0
endgroup
set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM} CONFIG.Enable_32bit_Address {false} CONFIG.Use_Byte_Write_Enable {true} CONFIG.Byte_Size {8} CONFIG.Write_Width_A {32} CONFIG.Write_Depth_A {32768} CONFIG.Read_Width_A {32} CONFIG.Write_Width_B {8} CONFIG.Read_Width_B {8} CONFIG.Enable_B {Use_ENB_Pin} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Register_PortB_Output_of_Memory_Primitives {false} CONFIG.Use_RSTA_Pin {true} CONFIG.Use_RSTB_Pin {true} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Write_Rate {50} CONFIG.Port_B_Enable_Rate {100} CONFIG.use_bram_block {Stand_Alone} CONFIG.EN_SAFETY_CKT {false}] [get_bd_cells blk_mem_gen_0]
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0
endgroup
set_property -dict [list CONFIG.SINGLE_PORT_BRAM {1}] [get_bd_cells axi_bram_ctrl_0]
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:bram_cntlr -config {BRAM "Auto" }  [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/processing_system7_0/M_AXI_GP0} Slave {/axi_bram_ctrl_0/S_AXI} ddr_seg {Auto} intc_ip {/axi_interconnect_0} master_apm {0}}  [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/processing_system7_0/M_AXI_GP0} Slave {/deskew_top_0/AXI_S} ddr_seg {Auto} intc_ip {/axi_interconnect_0} master_apm {0}}  [get_bd_intf_pins deskew_top_0/AXI_S]
apply_bd_automation -rule xilinx.com:bd_rule:bram_cntlr -config {BRAM "Auto" }  [get_bd_intf_pins deskew_top_0/BRAM_M]
endgroup
connect_bd_net [get_bd_pins deskew_top_0/deskew_irq] [get_bd_pins processing_system7_0/IRQ_F2P]
set_property range 128K [get_bd_addr_segs {processing_system7_0/Data/SEG_axi_bram_ctrl_0_Mem0}]
startgroup
set_property -dict [list CONFIG.Enable_32bit_Address {false} CONFIG.Use_Byte_Write_Enable {true} CONFIG.Byte_Size {8} CONFIG.Write_Width_A {32} CONFIG.Read_Width_A {32} CONFIG.Write_Width_B {8} CONFIG.Read_Width_B {8} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Register_PortB_Output_of_Memory_Primitives {false} CONFIG.Use_RSTA_Pin {true} CONFIG.Use_RSTB_Pin {true} CONFIG.use_bram_block {Stand_Alone} CONFIG.EN_SAFETY_CKT {false}] [get_bd_cells blk_mem_gen_0]
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:user:address_router_32bit_align:1.0 address_router_32bit_0
endgroup
delete_bd_objs [get_bd_intf_nets axi_bram_ctrl_0_BRAM_PORTA]
connect_bd_net [get_bd_pins axi_bram_ctrl_0/bram_addr_a] [get_bd_pins address_router_32bit_0/in_addr]
connect_bd_net [get_bd_pins address_router_32bit_0/out_addr] [get_bd_pins blk_mem_gen_0/addra]
connect_bd_net [get_bd_pins axi_bram_ctrl_0/bram_clk_a] [get_bd_pins blk_mem_gen_0/clka]
connect_bd_net [get_bd_pins axi_bram_ctrl_0/bram_wrdata_a] [get_bd_pins blk_mem_gen_0/dina]
connect_bd_net [get_bd_pins axi_bram_ctrl_0/bram_rddata_a] [get_bd_pins blk_mem_gen_0/douta]
connect_bd_net [get_bd_pins axi_bram_ctrl_0/bram_en_a] [get_bd_pins blk_mem_gen_0/ena]
connect_bd_net [get_bd_pins axi_bram_ctrl_0/bram_rst_a] [get_bd_pins blk_mem_gen_0/rsta]
connect_bd_net [get_bd_pins axi_bram_ctrl_0/bram_we_a] [get_bd_pins blk_mem_gen_0/wea]
save_bd_design
validate_bd_design
make_wrapper -files [get_files ../work/deskew_dev/deskew_dev.srcs/sources_1/bd/deskew_system/deskew_system.bd] -top -import
launch_runs synth_1
wait_on_runs synth_1
launch_runs impl_1 -to_step write_bitstream
wait_on_runs impl_1
file mkdir ../work/exported_hw
write_hw_platform -fixed -include_bit -force -file ../work/exported_hw/deskew_system_wrapper.xsa
open_run impl_1
start_gui
