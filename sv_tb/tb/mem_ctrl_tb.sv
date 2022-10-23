`ifndef __MEM_CTRL_TB_SV__
 `define __MEM_CTRL_TB_SV__

module mem_ctrl_tb;


   logic clk = 0;
   logic rst_n = 0;

   logic [7:0] wdata_in ;
   logic [7:0] wdata_out;

   logic [7:0] rdata_in;
   logic [7:0] rdata_out;

   logic [16:0]	addr_in;
   logic [16:0]	addrb;

   logic       web = 0, enb = 0;
   logic       wr = 0, en = 0, rdata_rdy;

   
   bram_if_ctrl u_bram_ctrl(.clk(clk),
			    .rst_n(rst_n),
			    .en(en),
			    .wr(wr),
			    .rdata_rdy(rdata_rdy),
			    .rdata_out(rdata_out),
			    .rdata_in(rdata_in),
			    .wdata_out(wdata_out),
			    .wdata_in(wdata_in),
			    .enb(enb),
			    .web(web),
			    .addr_in(addr_in),
			    .addrb(addrb)
			    );

   //Note : User must be using the generated BRAM wrapper which is not part of the src directory.
   bram_gen_wrapper u_bram_0(
			     .BRAM_PORTA_0_addr(addrb),
			     .BRAM_PORTA_0_clk(clk),
			     .BRAM_PORTA_0_din(wdata_out),
			     .BRAM_PORTA_0_dout(rdata_in),
			     .BRAM_PORTA_0_en(en),
			     .BRAM_PORTA_0_we(web)
			     );
   
   
   ////////////////////////////////////////////////////////////
   
   task read(bit [16:0] a_raddr);

      en <= 1'b1;
      wr <= 1'b0;
      addr_in <= a_raddr;
      
      @(posedge clk);
      en <= 1'b0;
   endtask // read

   ////////////////////////////////////////////////////////////

   task write(bit [16:0] a_waddr,
	      bit [7:0]	a_wdata);

      en <= 1'b1;
      wr <= 1'b1;
      addr_in <= a_waddr;
      wdata_in <= a_wdata;
      
      @(posedge clk);
      en <= 1'b0;
      wr <= 1'b0;
      
   endtask // write

   ////////////////////////////////////////////////////////////


   task testcase();

      bit [16:0] addr_q [$];

      repeat(20)
	addr_q.push_back($urandom());

      foreach(addr_q[i])
	write(addr_q[i], $urandom());

      foreach(addr_q[i])
	read(addr_q[i]);
      
   endtask // testcase

   ////////////////////////////////////////////////////////////

   initial begin

      #2ns;

      rst_n = 0;

      #27ns;

      rst_n = 1;
      
   end // initial begin

   always #10ns clk = ~clk;

   initial begin
      @(posedge rst_n);
      @(posedge clk);

      testcase();

      $finish;
      
   end
   
   
   
   

   
endmodule // mem_ctrl_tb



`endif
