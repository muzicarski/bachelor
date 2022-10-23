`ifndef __DESKEW_REG_BLOCK__
 `define __DESKEW_REG_BLOCK__


module deskew_reg_block(
                        //SYNC:
                        clk,
                        rst_n,

                        //AXI2REG
                        read_reg,
                        write_reg,

                        reg_wdata,
                        reg_rdata,

                        reg_raddr,
                        reg_waddr,

                        //REG2CTRL
                        mem_acc_err,
                        err_size,
                        done,
                        idle,
                        mem_acc_err_ack,
                        err_size_ack,
                        done_ack,

                        img_w_l,
                        start_addr_in,
                        start_addr_out,
                        start_deskew,
                        soft_rst

                        );

   //Generic/parameters list:

   localparam                        REG_DATA_WIDTH = 32;
   localparam                        REG_ADDR_WIDTH = 8;

   //Register addresses:

   localparam                        DSQW_CFG = 8'h00;
   localparam                        START_ADDR = 8'h04;
   localparam                        IMG_DIM = 8'h08;
   localparam                        DSQW_STAT = 8'h0c;
   localparam                        DSQW_ACK = 8'h10;


   //==============================//
   //        I N P U T S           //
   //==============================//

   //REG 2 AXI
   input                             clk;
   input                             rst_n;

   input                             write_reg;
   input                             read_reg;

   input [REG_DATA_WIDTH-1 : 0]      reg_wdata;

   input [REG_ADDR_WIDTH-1 : 0]      reg_waddr;
   input [REG_ADDR_WIDTH-1 : 0]      reg_raddr;

   //REG 2 DSQW_CTRL
   input                             mem_acc_err;
   input                             err_size;
   input                             done;
   input                             idle;

   output [8 : 0]                    img_w_l;
   output [16 : 0]                   start_addr_in;
   output [16 : 0]                   start_addr_out;

   output                            start_deskew;
   output                            soft_rst;

   //==============================//
   //        O U T P U T S         //
   //==============================//

   //REG 2 AXI
   output reg [REG_DATA_WIDTH-1 : 0] reg_rdata;

   //REG 2 DSQW_CTRL
   output                         mem_acc_err_ack;
   output                         err_size_ack;
   output                         done_ack;


   //================================================================================//

   //Internal reg states:
   wire [REG_DATA_WIDTH-1 : 0]        start_addr;
   wire [REG_DATA_WIDTH-1 : 0]        img_dim;
   wire [REG_DATA_WIDTH-1 : 0]       dsqw_stat_w;
   reg [REG_DATA_WIDTH-1 : 0]        dsqw_stat;

   //Interconnection:
   wire                              reg_wdata_0;
   wire                              reg_wdata_1;

   //================================================================================//

   //Internal-External routing:
   assign reg_wdata_0 = reg_wdata[0];
   assign reg_wdata_1 = reg_wdata[1];

   //Interrupts internal:
   wire                              mem_acc_err_w;
   wire                              err_size_w;
   wire                              done_w;
   reg                               idle_r;



   //Outputs routing:
   assign img_w_l = img_dim[8:0];
   assign start_addr_in = {start_addr[14:0], 2'b00};
   assign start_addr_out = {start_addr[30:16], 2'b00};


   //==============================//
   //      R E A D   L O G I C     //
   //==============================//
   wire [REG_DATA_WIDTH-1 : 0]       mux_out;
   wire [REG_DATA_WIDTH-1 : 0]       rdata_next;

   assign mux_out    = reg_raddr == START_ADDR ? start_addr :
                       reg_raddr == IMG_DIM ? img_dim :
                       reg_raddr == DSQW_STAT ? dsqw_stat :
                       32'h00000000;

   assign rdata_next = read_reg ? mux_out : reg_rdata;

   always @(posedge clk or negedge rst_n)
     begin
        if (~rst_n)
          reg_rdata <= 32'h00000000;
        else
          reg_rdata <= rdata_next;
     end

   //====================================//
   //   W R I T E ,  S E T ,  C L E A R  //
   //             L O G I C              //
   //====================================//

   //START_ADD reg:

   rw_reg_wrapper
     #(.REG_ADDR(START_ADDR)) START_ADDR_reg (.clk(clk),
                                              .rst_n(rst_n),
                                              .data_in(reg_wdata),
                                              .write_en(write_reg),
                                              .data_out(start_addr),
                                              .addr_in(reg_waddr)
                                              );

   //IMG_DIM reg:

   rw_reg_wrapper
     #(.REG_ADDR(IMG_DIM), .RST_DATA(256)) IMG_DIM_reg (.clk(clk),
                                        .rst_n(rst_n),
                                        .data_in(reg_wdata),
                                        .write_en(write_reg),
                                        .data_out(img_dim),
                                        .addr_in(reg_waddr)
                                        );

   //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

   //DSQW_CFG -> START_DSQW field:

   cfg_reg_wrapper
     #(.REG_ADDR(DSQW_CFG)) START_DSQW_reg_field (.clk(clk),
                                                   .rst_n(rst_n),
                                                   .set(reg_wdata_0),
                                                   .write_en(write_reg),
                                                   .addr_in(reg_waddr),
                                                   .pulse_out(start_deskew)
                                                   );


   //DSQW_CFG -> START_DSQW field:

   cfg_reg_wrapper
     #(.REG_ADDR(DSQW_CFG)) SOFT_RST_reg_field (.clk(clk),
                                                 .rst_n(rst_n),
                                                 .set(reg_wdata_1),
                                                 .write_en(write_reg),
                                                 .addr_in(reg_waddr),
                                                 .pulse_out(soft_rst)
                                                 );


   //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//


   //Interrupts section:

   irq_reg_wrapper
     #(.ACK_REG_ADDR(DSQW_ACK)) MEM_ACC_ERR_reg_field(.clk(clk),
                                                      .rst_n(rst_n),
                                                      .set(mem_acc_err),
                                                      .ack_in(reg_wdata[3]),
                                                      .write_en(write_reg),
                                                      .addr_in(reg_waddr),
                                                      .data_out(mem_acc_err_w),
                                                      .ack_out(mem_acc_err_ack)
                                                      );

   irq_reg_wrapper
     #(.ACK_REG_ADDR(DSQW_ACK)) ERR_SIZE_reg_field(.clk(clk),
                                                   .rst_n(rst_n),
                                                   .set(err_size),
                                                   .ack_in(reg_wdata[2]),
                                                   .write_en(write_reg),
                                                   .addr_in(reg_waddr),
                                                   .data_out(err_size_w),
                                                   .ack_out(err_size_ack)
                                                   );

   irq_reg_wrapper
     #(.ACK_REG_ADDR(DSQW_ACK)) DONE_reg_field(.clk(clk),
                                               .rst_n(rst_n),
                                               .set(done),
                                               .ack_in(reg_wdata[2]),
                                               .write_en(write_reg),
                                               .addr_in(reg_waddr),
                                               .data_out(done_w),
                                               .ack_out(done_ack)
                                               );

   //Register value assignment:
   always @ (posedge clk or negedge rst_n)
     if(~rst_n)
       idle_r <= 1'b0;
     else
       idle_r <= idle;

   assign dsqw_stat_w = {28'h0000000,
                         mem_acc_err_w,
                         err_size_w,
                         done_w,
                         idle_r};
                         
   always @ (posedge clk)
   begin
    if(~rst_n)
        dsqw_stat <= 0;
    else
        dsqw_stat <= dsqw_stat_w;
   end


endmodule // deskew_reg_block


`endif
