`ifndef __AXI_LITE_BRIDGE__
 `define __AXI_LITE_BRIDGE__

module axi_lite_bridge #(parameter REG_ADDR_WIDTH = 32)(
                                                        //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
                                                        //AXI LITE INTERFACE

                                                        //Sync:
                                                        axis_clk,
                                                        axis_rst_n,

                                                        //Write addr channel:
                                                        axis_waddr,
                                                        axis_waddr_valid,
                                                        axis_waddr_ready,

                                                        //Write data channel:
                                                        axis_wdata,
                                                        axis_wdata_valid,
                                                        axis_wdata_ready,

                                                        //Write response channel:
                                                        axis_bresp,
                                                        axis_bresp_valid,
                                                        axis_bresp_ready,

                                                        //Read addr channel:
                                                        axis_raddr,
                                                        axis_raddr_valid,
                                                        axis_raddr_ready,

                                                        //Read data channel:
                                                        axis_rdata,
                                                        axis_rdata_valid,
                                                        axis_rdata_ready,
                                                        axis_rresp,

                                                        //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//
                                                        //REG BLOCK INTERFACE

                                                        write_reg,
                                                        read_reg,
                                                        reg_wdata,
                                                        reg_rdata,
                                                        reg_waddr,
                                                        reg_raddr
                                                        );

   //Generics/parameters list:

   localparam                        REG_DATA_WIDTH = 32;


   localparam                        BRAM_ADDR_WIDTH = 17;
   localparam                        BRAM_DATA_WIDTH = 8;

   localparam [1:0]                  //3 states overall:
                                     WAIT_WREQ = 2'b00,
                                     WAIT_WDATA = 2'b01,
                                     SEND_BRESP = 2'b10,
                                     AXI_WR_BOOT = 2'b11;

   localparam [1:0]                  //4 states overall:
                                     WAIT_RREQ = 2'b00,
                                     WAIT_RDATA = 2'b01,
                                     SEND_RRESP = 2'b10,
                                     AXI_RD_BOOT = 2'b11;




   //==============================//
                                     //        I N P U T S           //
                                     //==============================//

   //AXI LITE INTERFACE

   input                             axis_clk;
   input                             axis_rst_n;

   input [REG_ADDR_WIDTH-1 : 0]      axis_waddr;
   input                             axis_waddr_valid;

   input [REG_DATA_WIDTH-1 : 0]      axis_wdata;
   input                             axis_wdata_valid;

   input                             axis_bresp_ready;

   input [REG_ADDR_WIDTH-1 : 0]      axis_raddr;
   input                             axis_raddr_valid;

   input                             axis_rdata_ready;



   //REG BLOCK INTERFACE

   input [REG_DATA_WIDTH-1 : 0]      reg_rdata;



   //==============================//
   //       O U T P U T S          //
   //==============================//

   //AXI LITE INTERFACE

   output reg                        axis_waddr_ready;

   output reg                        axis_wdata_ready;

   output reg [1:0]                  axis_bresp;
   output reg                        axis_bresp_valid;

   output reg                        axis_raddr_ready;

   output [REG_DATA_WIDTH-1: 0]      axis_rdata;
   output reg                        axis_rdata_valid;
   output reg [1:0]                  axis_rresp;

   //REG BLOCK INTERFACE

   output reg                        read_reg;
   output reg                        write_reg;
   output reg [REG_DATA_WIDTH-1 : 0] reg_wdata;
   output reg [REG_ADDR_WIDTH-1 : 0] reg_waddr;
   output reg [REG_ADDR_WIDTH-1 : 0] reg_raddr;


   //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

   //Internal variables/signals

   //Read Data pass
   wire [REG_DATA_WIDTH-1 : 0]       rdata_w;

   //Control signals:

   ////////////////////////////////////////
   //           State machines           //
   ////////////////////////////////////////

   //WRITE FSM
   reg [1:0]                         axi_w_ns; //Next state
   reg [1:0]                         axi_w_cs; //Current state

   //READ FSM
   reg [1:0]                         axi_r_ns; //Next state
   reg [1:0]                         axi_r_cs; //Current state


   //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
   //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
   //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

   //-------------------//
   //* R E A D   F S M *//
   //-------------------//
   ////////////////////////////////////////
   //STATE REGISTER
   always @(posedge axis_clk or negedge axis_rst_n)
     begin
        if(~axis_rst_n)
          axi_r_cs <= AXI_RD_BOOT;
        else
          axi_r_cs <= axi_r_ns;
     end

   ////////////////////////////////////////
   //Next state gen logic:
   always@(*)
     if(~axis_rst_n)
       axi_r_ns = WAIT_RREQ;
     else
       begin
          case(axi_r_cs)

            WAIT_RREQ:
              begin
                 if(axis_raddr_valid)
                   axi_r_ns = WAIT_RDATA;
                 else
                   axi_r_ns = WAIT_RREQ;
              end

            WAIT_RDATA:
              begin
                 if(reg_raddr[1:0] == 2'b00 && reg_raddr < 16'h11)
                   axi_r_ns = SEND_RRESP;
                 else if(axis_rdata_ready)
                   axi_r_ns = WAIT_RREQ;
                 else
                   axi_r_ns = WAIT_RDATA;
              end

            SEND_RRESP:
              begin
                 if(axis_rdata_ready)
                   axi_r_ns = WAIT_RREQ;
                 else
                   axi_r_ns = SEND_RRESP;
              end

            default:
              axi_r_ns = WAIT_RREQ;

          endcase // case (axi_w_cs)
       end // always@ (*)

   ////////////////////////////////////////
   //Output gen logic

   always @(posedge axis_clk or negedge axis_rst_n)
     begin

        if(~axis_rst_n)
          begin
             axis_rdata_valid <= 0;
             axis_raddr_ready <= 1;
             axis_rresp <= 0;
             read_reg <= 0;
             reg_raddr <= 0;
          end
        else
          begin
             case (axi_r_cs)

               WAIT_RREQ:
                 begin
                    axis_rdata_valid <= 0;
                    if(axis_raddr_valid)
		      begin
			 axis_raddr_ready <= 0;
			 reg_raddr <= axis_raddr;
		      end
                    read_reg <= 0;
                 end

               WAIT_RDATA:
                 begin

                    if(axis_raddr[1:0] == 2'b00 && axis_raddr < 16'h11)
                      read_reg <= 1;
                    else begin
                       axis_rresp <= 2'b10;
                       axis_rdata_valid <= 1;
                    end
                 end // case: WAIT_RDATA

               SEND_RRESP:
                 begin
                    axis_rresp <= 2'b00;
                    axis_rdata_valid <= 1;
                    read_reg <= 1'b0;
                    if(axis_rdata_ready)
                      axis_raddr_ready <= 1'b1;
                 end

               default:
                 begin
                    axis_rdata_valid <= 0;
                    axis_raddr_ready <= 1;
                 end

             endcase // case (axi_r_cs)

          end

     end

   //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
   //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
   //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

   //----------------------//
   //* W R I T E    F S M *// // MEALY (depends on inputs)
   //----------------------//
   ////////////////////////////////////////
   //STATE REGISTER:
   always @(posedge axis_clk or negedge axis_rst_n)
     begin
        if(~axis_rst_n)
          axi_w_cs <= AXI_WR_BOOT;
        else
          axi_w_cs <= axi_w_ns;
     end

   ////////////////////////////////////////
   //Next state gen logic:
   always @(*)

     if(~axis_rst_n)
       axi_w_ns = AXI_WR_BOOT;
     else
       begin

          case (axi_w_cs)

            WAIT_WREQ:
              begin
                 if(axis_waddr_valid == 1)
                   if(axis_wdata_valid == 1)
                     axi_w_ns = SEND_BRESP;
                   else
                     axi_w_ns = WAIT_WDATA;
                 else
                   axi_w_ns = WAIT_WREQ;
              end

            WAIT_WDATA:
              begin
                 if(axis_wdata_valid)
                   axi_w_ns = SEND_BRESP;
                 else
                   axi_w_ns = WAIT_WDATA;
              end

            SEND_BRESP:
              begin
                 if(axis_bresp_ready)
                   axi_w_ns = WAIT_WREQ;
                 else
                   axi_w_ns = SEND_BRESP;
              end

            default:
              axi_w_ns = WAIT_WREQ;

          endcase // case axi_w_cs
       end

   ////////////////////////////////////////
   //Output logic:

   always @(posedge axis_clk)
     if(~axis_rst_n)
       begin

          axis_waddr_ready <= 0;
          axis_wdata_ready <= 0;
          axis_bresp <= 0;
          axis_bresp_valid <= 0;

          write_reg <= 0;
          reg_wdata <= 0;
          reg_waddr <= 0;
       end
     else

       begin

	  //Default section:
          axis_waddr_ready <= 0;
          axis_wdata_ready <= 0;
          axis_bresp <= 0;
          axis_bresp_valid <= 0;

          write_reg <= 0;
	  
          case(axi_w_cs)
            WAIT_WREQ:
              begin

                 if(axis_waddr_valid)
                   begin
                      reg_waddr <= axis_waddr;
                      axis_waddr_ready <= 1'b1;

                      if(axis_wdata_valid) begin
                         reg_wdata <= axis_wdata;
                         axis_wdata_ready <= 1'b1;
                      end
                   end
              end

            WAIT_WDATA:
              begin
                 if(axis_wdata_valid) begin
                    reg_wdata <= axis_wdata;
                    axis_wdata_ready <= 1;
                 end
              end

            SEND_BRESP:
              begin

                 axis_bresp_valid <= 1'b1;

                 if(reg_waddr[1:0] == 2'b00 && reg_waddr < 8'h11)
                   begin
                      axis_bresp <= 2'b00;
                      write_reg <= 1'b1;
                   end
                 else
                   begin
                      axis_bresp <= 2'b10;
                   end
              end // case: SEND_BRESP

            default:
              begin
                 axis_waddr_ready <= 1'b0;
                 axis_bresp_valid <= 1'b0;
                 axis_wdata_ready <= 1'b0;
              end

          endcase // case (axi_w_cs)
       end

   assign axis_rdata = reg_rdata;



endmodule // axi_lite_bridge








`endif
