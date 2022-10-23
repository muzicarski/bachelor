`ifndef __BRAM_MONITOR_SV__
 `define __BRAM_MONITOR_SV__


class bram_monitor_c extends uvm_monitor;


   `uvm_component_utils(bram_monitor_c)
   

   virtual bram_if vif;
   int unsigned	m_mem_size;
   int unsigned	m_img_dim;
   
   byte unsigned MEM_MODEL[int unsigned];

   bit		 m_done;

   function new(string name = "bram_mon", uvm_component parent = null);
      super.new(name,parent);
   endfunction // new
   
   
   function void cfg_mon(virtual bram_if a_vif,
			 int unsigned a_mem_size,
			 int unsigned a_img_dim);
      
      vif = a_vif;
      m_mem_size = a_mem_size;
      m_img_dim = a_img_dim;

      m_done = 0;
      
      $display("Monitor created");
   endfunction // new

   //========================================//

   function void build_phase (uvm_phase phase);
      super.build_phase(phase);
   endfunction // build_phase
   

   task monitor_writes();
      
      @(posedge vif.rst_n);
      @(negedge vif.rst_n);

      forever begin

	 @(negedge vif.clk iff (vif.enb === 1'b1 && vif.web === 1'b1));
	 
	 if(vif.wdata != 0) begin
	   MEM_MODEL[vif.addr[15:0]] = vif.wdata;
	   	 `uvm_info("MON_SMP", $sformatf("Sampled : %2h from addr %4h", vif.wdata, vif.addr[15:0]), UVM_HIGH)
     end
	 else if(MEM_MODEL.exists(vif.addr[15:0]))
	   MEM_MODEL.delete(vif.addr[15:0]);
	   
	 
      end
      
   endtask // monitor_writes


   //========================================//

   function void write_output_img();

      int v_out_image;
      int unsigned v_img_len;
      string	   out_string;


      v_img_len = m_img_dim*m_img_dim;

      v_out_image = $fopen("out_image.dat", "w");

      for (int i = 0; i < v_img_len; i++) begin
	 if(MEM_MODEL.exists(i))
	   $fwrite(v_out_image, $sformatf("%0d ", MEM_MODEL[i]));
	 else
	   $fwrite(v_out_image, "0 ");
      end
   `uvm_info(get_name(), "Wrote output file.", UVM_LOW)   
   endfunction // write_output_img

   //========================================//

   task run_phase(uvm_phase phase);
      super.run_phase(phase);
      monitor_writes();
   endtask // run_phase


   function void check_phase (uvm_phase phase);
      super.check_phase(phase);
      write_output_img();
   endfunction // check_phase
   

   task run();

      fork
	 
	 fork begin
	    
	    fork
	       monitor_writes();
	    join_none

	    wait(m_done == 1);
	    m_done = 0;

	    disable fork; //disables monitor_writes();

	    write_output_img();
	    
	 end join // fork begin
	 
      join_none
      
   endtask // run

   //========================================//

   function void set_done();
      m_done = 1;
   endfunction // set_done
   
   
   
   
   
endclass // bram_monitor_c




`endif
