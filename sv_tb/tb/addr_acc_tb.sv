`ifndef __ADDR_GEN_TB_SV__
 `define __ADDR_GEN_TB_SV__

module addr_gen_tb();


   logic clk = 0;
   logic rst_n = 0;


   logic en = 0;
   logic sclr = 0;


   logic [8:0] img_dim = 16;

   logic [16:0]	addr_out;

   logic [7:0]	x_cnt, y_cnt;

   addr_gen u_dut (.clk(clk),
		   .rst_n(rst_n),
		   .en(en),
		   .sclr(sclr),
		   .img_dim(img_dim),
		   .addr_out(addr_out),
		   .x_cnt(x_cnt),
		   .y_cnt(y_cnt)
		   );


   always #10ns clk = ~clk;


   initial begin

      #7ns;
      rst_n = 0;

      #23ns;

      rst_n = 1;
   end


   initial begin

      @(posedge rst_n);

      repeat(3) @(posedge clk);

      img_dim <= 16;
      en <= 1;

      repeat(255) @(posedge clk);

      sclr <= 1'b1;

      @(posedge clk);

      en <= 1'b0;

      repeat(5) @(posedge clk);

      $finish;
      
      
   end
   
   
  




   
endmodule // addr_gen_tb





`endif
