`ifndef __DESKEW_FSM__
 `define __DESKEW_FSM__

module deskew_fsm(
                  //Inputs
                  clk,
                  rst_n,

                  img_dim,
                  start_deskew,

                  x_cnt,
                  y_cnt,
                  x_cnt_xp,
                  y_cnt_xp,
                  xp_r,
                  skew_vld_in,
		  skew_dvd_rdy,
		  skew_dvs_rdy,
                  div_res_vld,

                  //Outputs:
                  //to control
                  deskew_done_out,

                  //to Datapath
                  sclr_out,
                  x_fifo_wr_out,
                  y_fifo_wr_out,
                  bram_en_out,
                  bram_wr_out,
                  addr_gen_en_out,
                  x_fifo_rd_out,
                  y_fifo_rd_out,
                  p_fifo_rd_out,
                  m00_en_out,
                  m01_en_out,
                  m10_en_out,
                  m00_r_en_out,
                  m01_r_en_out,
                  m10_r_en_out,
                  div_sel_out,
                  dividend_valid_out,
                  divisor_valid_out,
                  x_mc_en_out,
                  y_mc_en_out,
                  mu11_mac_enable_en_out,
                  mu02_mac_enable_en_out,
                  mu11_r_en_out,
                  mu02_r_en_out,
                  skew_dividend_vld_out,
                  skew_divisor_vld_out,
                  skew_r_en_out,
                  m02_mult_en_out,
                  m02_r_en_out,
                  bram_addr_sel_out,
                  xp_gen_en_out,
                  xp_r_en_out,
                  py_r_en_out,
                  p1_addr_en_out,
                  p2_addr_en_out,
                  p_rd_addr_sel_out,
                  calc_p1_addr_en_out,
                  p1_r_en_out,
                  p2_r_en_out,
                  p_r_en_out,
                  p_val_sel_out,
                  img_addr_sel_out,
                  sub_p1_p2_en_out,
                  p_mult_en_out
                  );

   input          clk;
   input          rst_n;
   input [8 : 0]  img_dim;
   input          start_deskew;
   input          skew_vld_in;
   input	  skew_dvd_rdy;
   input	  skew_dvs_rdy;
	
   input signed [14:0] xp_r;
   input               div_res_vld;
   input [8 : 0]       x_cnt;
   input [8 : 0]       y_cnt;
   input [8 : 0]       x_cnt_xp;
   input [8 : 0]       y_cnt_xp;
   
   output              deskew_done_out;
   
   output           sclr_out;
   output           x_fifo_wr_out;
   output           y_fifo_wr_out;
   output           bram_en_out;
   output           bram_wr_out;
   output           addr_gen_en_out;
   output           x_fifo_rd_out;
   output           y_fifo_rd_out;
   output           p_fifo_rd_out;
   output           m00_en_out;
   output           m01_en_out;
   output           m10_en_out;
   output           m00_r_en_out;
   output           m01_r_en_out;
   output           m10_r_en_out;
   output           div_sel_out;
   output           dividend_valid_out;
   output           divisor_valid_out;
   output           x_mc_en_out;
   output           y_mc_en_out;
   output           mu11_mac_enable_en_out;
   output           mu02_mac_enable_en_out;
   output           mu11_r_en_out;
   output           mu02_r_en_out;
   output           skew_dividend_vld_out;
   output           skew_divisor_vld_out;
   output           skew_r_en_out;
   output           m02_mult_en_out;
   output           m02_r_en_out;
   output           bram_addr_sel_out;
   output           xp_gen_en_out;
   output           xp_r_en_out;
   output           py_r_en_out;
   output           p2_addr_en_out;
   output           p1_addr_en_out;
   output           p_rd_addr_sel_out;
   output           calc_p1_addr_en_out;
   output           p1_r_en_out;
   output           p2_r_en_out;
   output           p_r_en_out;
   output           p_val_sel_out;
   output           img_addr_sel_out;
   output           sub_p1_p2_en_out;
   output           p_mult_en_out;

   reg           sclr_reg;
   reg           x_fifo_wr_reg;
   reg           y_fifo_wr_reg;
   reg           bram_en_reg;
   reg           bram_wr_reg;
   reg           addr_gen_en_reg;
   reg           x_fifo_rd_reg;
   reg           y_fifo_rd_reg;
   reg           p_fifo_rd_reg;
   reg           m00_en_reg;
   reg           m01_en_reg;
   reg           m10_en_reg;
   reg           m00_r_en_reg;
   reg           m01_r_en_reg;
   reg           m10_r_en_reg;
   reg           div_sel_reg;
   reg           dividend_valid_reg;
   reg           divisor_valid_reg;
   reg           x_mc_en_reg;
   reg           y_mc_en_reg;
   reg           mu11_mac_enable_en_reg;
   reg           mu02_mac_enable_en_reg;
   reg           mu11_r_en_reg;
   reg           mu02_r_en_reg;
   reg           skew_dividend_vld_reg;
   reg           skew_divisor_vld_reg;
   reg           skew_r_en_reg;
   reg           m02_mult_en_reg;
   reg           m02_r_en_reg;
   reg           bram_addr_sel_reg;
   reg           xp_gen_en_reg;
   reg           xp_r_en_reg;
   reg           py_r_en_reg;
   reg           p2_addr_en_reg;
   reg           p1_addr_en_reg;
   reg           p_rd_addr_sel_reg;
   reg           calc_p1_addr_en_reg;
   reg           p1_r_en_reg;
   reg           p2_r_en_reg;
   reg           p_r_en_reg;
   reg           p_val_sel_reg;
   reg           img_addr_sel_reg;
   reg           sub_p1_p2_en_reg;
   reg           p_mult_en_reg;
   
   reg          deskew_done_reg;

   reg           sclr;
   reg           x_fifo_wr;
   reg           y_fifo_wr;
   reg           bram_en;
   reg           bram_wr;
   reg           addr_gen_en;
   reg           x_fifo_rd;
   reg           y_fifo_rd;
   reg           p_fifo_rd;
   reg           m00_en;
   reg           m01_en;
   reg           m10_en;
   reg           m00_r_en;
   reg           m01_r_en;
   reg           m10_r_en;
   reg           div_sel;
   reg           dividend_valid;
   reg           divisor_valid;
   reg           x_mc_en;
   reg           y_mc_en;
   reg           mu11_mac_enable_en;
   reg           mu02_mac_enable_en;
   reg           mu11_r_en;
   reg           mu02_r_en;
   reg           skew_dividend_vld;
   reg           skew_divisor_vld;
   reg           skew_r_en;
   reg           m02_mult_en;
   reg           m02_r_en;
   reg           bram_addr_sel;
   reg           xp_gen_en;
   reg           xp_r_en;
   reg           py_r_en;
   reg           p2_addr_en;
   reg           p1_addr_en;
   reg           p_rd_addr_sel;
   reg           calc_p1_addr_en;
   reg           p1_r_en;
   reg           p2_r_en;
   reg           p_r_en;
   reg           p_val_sel;
   reg           img_addr_sel;
   reg           sub_p1_p2_en;
   reg           p_mult_en;



   reg                 deskew_done;

   localparam [5 : 0]  // 41 states:
                       WAIT_START       = 0,
                       START_ADDR_GEN   = 1,
                       RD0_NULL         = 2,
                       FEED_DATA        = 3,
                       ACCUMULATE       = 4,
                       RD_DONE          = 5,
                       WAIT_FIFO_RD     = 6,
                       FEED_DONE        = 7,
                       M00_DONE         = 8,
                       M00_OUT          = 9,
                       WAIT_0           = 10,
                       M_DONE           = 11,
                       ALL_DONE         = 12,
                       X_MC_START       = 13,
                       Y_MC_START       = 14,
                       WAIT_X_MC        = 15,
                       WAIT_Y_MC        = 16,
                       Y_MC_DONE        = 17,
                       MU_READ          = 18,
                       FEED_SUB         = 19,
                       RD1_NULL         = 20,
                       RD2_NULL         = 21,
                       RD3_NULL         = 22,
                       RD4_NULL         = 23,
                       MU_ACC           = 24,
                       MU_RD_DONE       = 25,
                       SUB_FEED_DONE    = 26,
                       MU_DLY0          = 27,
                       MU_DLY1          = 28,
                       MU_DLY2          = 29,
                       MU_LAST          = 30,
                       WAIT_MU0         = 31,
                       WAIT_MU1         = 32,
                       WAIT_MU2         = 33,
                       MU_CALC_DONE     = 34,
                       MU_VALID         = 35,
                       WAIT_SKEW_DONE   = 36,
                       WAIT_SKEW_INVERT = 37,
                       M02_MULT_EN      = 38,
                       M02_MULT_NULL0   = 39,
                       M02_MULT_NULL1   = 40,
                       M02_MULT_NULL2   = 41,
                       STORE_M02        = 42,
                       M02_DONE         = 43,
                       NEXT_XP          = 44,
                       NEXT_P_ADDR      = 45,
                       P1_P2_ADDR       = 46,
                       READ_P1          = 47,
                       READ_P2          = 48,
                       GET_P1_P2        = 49,
                       GET_P1_DONE      = 50,
                       GET_P2_DONE      = 51,
                       GET_P1_P2_DONE   = 52,
                       CALC_NEXT_P      = 53,
                       WAIT_P_MULT_0    = 54,
                       WAIT_P_MULT_1    = 55,
                       NEXT_P_RDY       = 56,
                       WRITE_NEXT_P     = 57,
                       NEXT_P_IN_IMG    = 58;
                       


   reg [5 : 0]         dskw_cs;  // current state
   reg [5 : 0]         dskw_ns;  // next state

 `ifndef DSKW_SYNTH
   //`include "fsm_debug_states.sv"
 `endif


   // State register
   always @(posedge clk or negedge rst_n)
     begin
        if(~rst_n)
          dskw_cs <= WAIT_START;
        else
          dskw_cs <= dskw_ns;
     end

   always @(posedge clk or negedge rst_n)
     begin
      if(~rst_n)
        begin
          sclr_reg <= 0;
          x_fifo_wr_reg <= 0;
          y_fifo_wr_reg <= 0;
          bram_en_reg <= 0;
          bram_wr_reg <= 0;
          addr_gen_en_reg <= 0;
          x_fifo_rd_reg <= 0;
          y_fifo_rd_reg <= 0;
          p_fifo_rd_reg <= 0;
          m00_en_reg <= 0;
          m01_en_reg <= 0;
          m10_en_reg <= 0;
          m00_r_en_reg <= 0;
          m01_r_en_reg <= 0;
          m10_r_en_reg <= 0;
          div_sel_reg <= 0;
          dividend_valid_reg <= 0;
          divisor_valid_reg <= 0;
          x_mc_en_reg <= 0;
          y_mc_en_reg <= 0;
          mu11_mac_enable_en_reg <= 0;
          mu02_mac_enable_en_reg <= 0;
          mu11_r_en_reg <= 0;
          mu02_r_en_reg <= 0;
          skew_dividend_vld_reg <= 0;
          skew_divisor_vld_reg <= 0;
          skew_r_en_reg <= 0;
          m02_mult_en_reg <= 0;
          m02_r_en_reg <= 0;
          bram_addr_sel_reg <= 0;
          xp_gen_en_reg <= 0;
          xp_r_en_reg <= 0;
          py_r_en_reg <= 0;
          p2_addr_en_reg <= 0;
          p1_addr_en_reg <= 0;
          p_rd_addr_sel_reg <= 0;
          calc_p1_addr_en_reg <= 0;
          p1_r_en_reg <= 0;
          p2_r_en_reg <= 0;
          p_r_en_reg <= 0;
          p_val_sel_reg <= 0;
          img_addr_sel_reg <= 0;
          sub_p1_p2_en_reg <= 0;
          p_mult_en_reg <= 0; 
          deskew_done_reg <= 0;
        end
    else
      begin
        sclr_reg <=                   sclr;
        x_fifo_wr_reg <=              x_fifo_wr;
        y_fifo_wr_reg <=              y_fifo_wr;
        bram_en_reg <=                bram_en;
        bram_wr_reg <=                bram_wr;
        addr_gen_en_reg <=            addr_gen_en;
        x_fifo_rd_reg <=              x_fifo_rd;
        y_fifo_rd_reg <=              y_fifo_rd;
        p_fifo_rd_reg <=              p_fifo_rd;
        m00_en_reg <=                 m00_en;
        m01_en_reg <=                 m01_en;
        m10_en_reg <=                 m10_en;
        m00_r_en_reg <=               m00_r_en;
        m01_r_en_reg <=               m01_r_en;
        m10_r_en_reg <=               m10_r_en;
        div_sel_reg <=                div_sel;
        dividend_valid_reg <=         dividend_valid;
        divisor_valid_reg <=          divisor_valid;
        x_mc_en_reg <=                x_mc_en;
        y_mc_en_reg <=                y_mc_en;
        mu11_mac_enable_en_reg <=     mu11_mac_enable_en;
        mu02_mac_enable_en_reg <=     mu02_mac_enable_en;
        mu11_r_en_reg <=              mu11_r_en;
        mu02_r_en_reg <=              mu02_r_en;
        skew_dividend_vld_reg <=      skew_dividend_vld;
        skew_divisor_vld_reg <=       skew_divisor_vld;
        skew_r_en_reg <=              skew_r_en;
        m02_mult_en_reg <=            m02_mult_en;
        m02_r_en_reg <=               m02_r_en;
        bram_addr_sel_reg <=          bram_addr_sel;
        xp_gen_en_reg <=              xp_gen_en;
        xp_r_en_reg <=                xp_r_en;
        py_r_en_reg <=                py_r_en;
        p2_addr_en_reg <=             p2_addr_en;
        p1_addr_en_reg <=             p1_addr_en;
        p_rd_addr_sel_reg <=          p_rd_addr_sel;
        calc_p1_addr_en_reg <=        calc_p1_addr_en;
        p1_r_en_reg <=                p1_r_en;
        p2_r_en_reg <=                p2_r_en;
        p_r_en_reg <=                 p_r_en;
        p_val_sel_reg <=              p_val_sel;
        img_addr_sel_reg <=           img_addr_sel;
        sub_p1_p2_en_reg <=           sub_p1_p2_en;
        p_mult_en_reg <=              p_mult_en;
        deskew_done_reg  <= deskew_done;
     
      end

     end

   // Output & next state logic
   always @(*)
     begin
        dskw_ns = dskw_cs;
        sclr =                   sclr_reg;
        x_fifo_wr =              x_fifo_wr_reg;
        y_fifo_wr =              y_fifo_wr_reg;
        bram_en =                bram_en_reg;
        bram_wr =                bram_wr_reg;
        addr_gen_en =            addr_gen_en_reg;
        x_fifo_rd =              x_fifo_rd_reg;
        y_fifo_rd =              y_fifo_rd_reg;
        p_fifo_rd =              p_fifo_rd_reg;
        m00_en =                 m00_en_reg;
        m01_en =                 m01_en_reg;
        m10_en =                 m10_en_reg;
        m00_r_en =               m00_r_en_reg;
        m01_r_en =               m01_r_en_reg;
        m10_r_en =               m10_r_en_reg;
        div_sel =                div_sel_reg;
        dividend_valid =         dividend_valid_reg;
        divisor_valid =          divisor_valid_reg;
        x_mc_en =                x_mc_en_reg;
        y_mc_en =                y_mc_en_reg;
        mu11_mac_enable_en =     mu11_mac_enable_en_reg;
        mu02_mac_enable_en =     mu02_mac_enable_en_reg;
        mu11_r_en =              mu11_r_en_reg;
        mu02_r_en =              mu02_r_en_reg;
        skew_dividend_vld =      skew_dividend_vld_reg;
        skew_divisor_vld =       skew_divisor_vld_reg;
        skew_r_en =              skew_r_en_reg;
        m02_mult_en =            m02_mult_en_reg;
        m02_r_en =               m02_r_en_reg;
        bram_addr_sel =          bram_addr_sel_reg;
        xp_gen_en =              xp_gen_en_reg;
        xp_r_en =                xp_r_en_reg;
        py_r_en =                py_r_en_reg;
        p2_addr_en =             p2_addr_en_reg;
        p1_addr_en =             p1_addr_en_reg;
        p_rd_addr_sel =          p_rd_addr_sel_reg;
        calc_p1_addr_en =        calc_p1_addr_en_reg;
        p1_r_en =                p1_r_en_reg;
        p2_r_en =                p2_r_en_reg;
        p_r_en =                 p_r_en_reg;
        p_val_sel =              p_val_sel_reg;
        img_addr_sel =           img_addr_sel_reg;
        sub_p1_p2_en =           sub_p1_p2_en_reg;
        p_mult_en =              p_mult_en_reg;
        deskew_done =            0;
        case(dskw_cs)

          WAIT_START:
            begin
               deskew_done = 0;


               if(start_deskew == 1)
                 begin
                    sclr = 1;
                    bram_addr_sel = 0;
                    dskw_ns = START_ADDR_GEN;
                 end
               else
                 dskw_ns = WAIT_START;
            end

          START_ADDR_GEN:
            begin
               sclr = 0;
               x_fifo_wr = 1;
               y_fifo_wr = 1;
               bram_en = 1;
               addr_gen_en = 1;
               img_addr_sel = 0;
               dskw_ns = RD0_NULL;
            end

          RD0_NULL:
            begin
               dskw_ns = FEED_DATA;
            end

          FEED_DATA:
            begin
               x_fifo_rd = 1;
               y_fifo_rd = 1;
               p_fifo_rd = 1;

               dskw_ns = ACCUMULATE;
            end

          ACCUMULATE:
            begin
               m00_en = 1;
               m01_en = 1;
               m10_en = 1;
               m00_r_en = 1;
               m01_r_en = 1;
               m10_r_en = 1;

               if(x_cnt == (img_dim-1) && y_cnt == (img_dim-2))
                 dskw_ns = RD_DONE;
               else
                 dskw_ns = ACCUMULATE;
            end

          RD_DONE:
            begin
               bram_en = 0;
               addr_gen_en = 0;
               x_fifo_wr = 0;
               y_fifo_wr = 0;

               dskw_ns = WAIT_FIFO_RD;
            end

          WAIT_FIFO_RD:
            begin
               dskw_ns = FEED_DONE;
            end

          FEED_DONE:
            begin
               x_fifo_rd = 0;
               y_fifo_rd = 0;
               p_fifo_rd = 0;

               dskw_ns = M00_DONE;
            end

          M00_DONE:
            begin
               m00_en = 0;

               dskw_ns = M00_OUT;
            end

          M00_OUT:
            begin
               m00_r_en = 0;

               dskw_ns = WAIT_0;
            end

          WAIT_0:
            begin
               dskw_ns = M_DONE;
            end

          M_DONE:
            begin
               m01_en = 0;
               m10_en = 0;

               dskw_ns = ALL_DONE;
            end

          ALL_DONE:
            begin
               m01_r_en = 0;
               m10_r_en = 0;

               dskw_ns = X_MC_START;
            end

          X_MC_START:
            begin
               div_sel = 0;
               dividend_valid = 1;
               divisor_valid = 1;

               dskw_ns = Y_MC_START;
            end

          Y_MC_START:
            begin
               div_sel = 1;

               dskw_ns = WAIT_X_MC;
            end

          WAIT_X_MC:
            begin
               dividend_valid = 0;
               divisor_valid = 0;

               if (div_res_vld)
                 begin
                    x_mc_en = 1;
                    dskw_ns = WAIT_Y_MC;
                 end
               else
                 dskw_ns = WAIT_X_MC;
            end

          WAIT_Y_MC:
            begin
               x_mc_en = 0;
               y_mc_en = 1;

               dskw_ns = Y_MC_DONE;
            end

          Y_MC_DONE:
            begin
               y_mc_en = 0;
               sclr = 1;
               dskw_ns = MU_READ;
            end

          MU_READ:
            begin
               sclr = 0;
               x_fifo_wr = 1;
               y_fifo_wr = 1;
               bram_en = 1;
               addr_gen_en = 1;

               dskw_ns = FEED_SUB;
            end

          FEED_SUB:
            begin
               x_fifo_rd = 1;
               y_fifo_rd = 1;

               dskw_ns = RD1_NULL;
            end

          RD1_NULL:
            begin
               dskw_ns = RD2_NULL;
            end

          RD2_NULL:
            begin
               dskw_ns = RD3_NULL;
            end

          RD3_NULL:
            begin
               dskw_ns = RD4_NULL;
            end

          RD4_NULL:
            begin
               p_fifo_rd = 1;

               dskw_ns = MU_ACC;
            end

          MU_ACC:
            begin
               mu11_mac_enable_en = 1;
               mu02_mac_enable_en = 1;
               mu11_r_en = 1;
               mu02_r_en = 1;

               if(x_cnt == (img_dim-1) && y_cnt == (img_dim-2))
                 dskw_ns = MU_RD_DONE;
               else
                 dskw_ns = MU_ACC;
            end

          MU_RD_DONE:
            begin
               bram_en = 0;
               addr_gen_en = 0;
               x_fifo_wr = 0;
               y_fifo_wr = 0;

               dskw_ns = SUB_FEED_DONE;
            end

          SUB_FEED_DONE:
            begin
               x_fifo_rd = 0;
               y_fifo_rd = 0;

               dskw_ns = MU_DLY0;
            end

          MU_DLY0:
            begin
               dskw_ns = MU_DLY1;
            end

          MU_DLY1:
            begin
               dskw_ns = MU_DLY2;
            end

          MU_DLY2:
            begin
               dskw_ns = MU_LAST;
            end

          MU_LAST:
            begin
               p_fifo_rd = 0;

               dskw_ns = WAIT_MU0;
            end

          WAIT_MU0:
            begin
               dskw_ns = WAIT_MU1;
            end

          WAIT_MU1:
            begin
               dskw_ns = WAIT_MU2;
            end

          WAIT_MU2:
            begin
               dskw_ns = MU_CALC_DONE;
            end

          MU_CALC_DONE:
            begin
               mu11_mac_enable_en = 0;
               mu02_mac_enable_en = 0;

               dskw_ns = MU_VALID;
            end

          MU_VALID:
            begin
               mu11_r_en = 0;
               mu02_r_en = 0;
               skew_dividend_vld = 1;
               skew_divisor_vld  = 1;

	       if(skew_dvs_rdy & skew_dvd_rdy)
		 dskw_ns = WAIT_SKEW_DONE;
	       else
		 dskw_ns = MU_VALID;
            end

          WAIT_SKEW_DONE:
            begin
               skew_dividend_vld = 0;
               skew_divisor_vld  = 0;

               if(skew_vld_in == 1)
                 begin
                    dskw_ns = WAIT_SKEW_INVERT;
                    skew_r_en = 1;
                 end
               else
                 dskw_ns = WAIT_SKEW_DONE;
            end

          WAIT_SKEW_INVERT:
            begin
               skew_r_en = 0;

               dskw_ns = M02_MULT_EN;
            end

          M02_MULT_EN:
            begin
               m02_mult_en = 1;
               dskw_ns = M02_MULT_NULL0;
            end

          M02_MULT_NULL0:
            begin
               dskw_ns = M02_MULT_NULL1;
            end

          M02_MULT_NULL1:
            begin
               dskw_ns = M02_MULT_NULL2;
            end

          M02_MULT_NULL2:
            begin
               dskw_ns = STORE_M02;
            end

          STORE_M02:
            begin
               m02_mult_en = 0;
               m02_r_en = 1;
               dskw_ns = M02_DONE;
            end

          M02_DONE:
            begin
               m02_r_en = 0;
               sclr = 1;
               img_addr_sel = 1;
               dskw_ns = NEXT_XP;
            end

          NEXT_XP:
            begin
               xp_gen_en = 1;
               xp_r_en = 1;
               py_r_en = 1;
               addr_gen_en = 0;
               sclr = 0;
               bram_en = 0;
               bram_wr = 0;
               bram_addr_sel = 1;

               dskw_ns = NEXT_P_ADDR;

            end

          NEXT_P_ADDR:
            begin
               xp_gen_en = 0;
               xp_r_en = 0;
               py_r_en = 0;
               dskw_ns = NEXT_P_IN_IMG;
            end

          NEXT_P_IN_IMG:
            begin
               if(xp_r < (img_dim-1) && xp_r[14] != 1) // img_dim>xp>0
                 begin
                    calc_p1_addr_en = 1;
                    dskw_ns = P1_P2_ADDR;
                 end
               else
                 begin
                    p_val_sel = 0;
                    p_r_en = 1;
                    dskw_ns = WRITE_NEXT_P;
                 end
            end

          P1_P2_ADDR:
            begin
               calc_p1_addr_en = 0;
               p1_addr_en = 1;
               p2_addr_en = 1;
               p_rd_addr_sel = 0;
               dskw_ns = READ_P1;
            end

          READ_P1:
            begin
               p1_addr_en = 0;
               p2_addr_en = 0;
               bram_en = 1;
               dskw_ns = READ_P2;
            end

          READ_P2:
            begin
               p_rd_addr_sel = 1;
               dskw_ns = GET_P1_P2;
            end

          GET_P1_P2:
            begin
               bram_en = 0;
               p_fifo_rd = 1;
               dskw_ns = GET_P1_DONE;
            end

          GET_P1_DONE:
            begin
               p1_r_en = 1;
               dskw_ns = GET_P2_DONE;
            end

          GET_P2_DONE:
            begin
               p1_r_en = 0;
               p2_r_en = 1;
               p_fifo_rd = 0;
               dskw_ns = GET_P1_P2_DONE;
            end

          GET_P1_P2_DONE:
            begin
               p2_r_en = 0;
               sub_p1_p2_en = 1;
               dskw_ns = CALC_NEXT_P;
            end

          CALC_NEXT_P:
            begin
               sub_p1_p2_en = 0;
               p_mult_en = 1;
               dskw_ns = WAIT_P_MULT_0;
            end

          WAIT_P_MULT_0:
            begin
               dskw_ns = WAIT_P_MULT_1;
            end

          WAIT_P_MULT_1:
            begin
               dskw_ns = NEXT_P_RDY;
            end

          NEXT_P_RDY:
            begin
               p_mult_en = 0;
               p_val_sel = 1;
               p_r_en = 1;
               dskw_ns = WRITE_NEXT_P;
            end

          WRITE_NEXT_P:
            begin

               p_r_en = 0;

               if(x_cnt_xp == (img_dim-1) && y_cnt_xp == (img_dim-2)) begin
                  dskw_ns = WAIT_START; // Report interrupts and go to idle
                  deskew_done = 1;
               end
               else begin
                  dskw_ns = NEXT_XP;

                  bram_en = 1;
                  bram_wr = 1;
                  bram_addr_sel = 0;
                  addr_gen_en = 1;

               end

            end

          default:
            begin
               dskw_ns            = WAIT_START;
               deskew_done        = 0;
               sclr               = 0;
               x_fifo_wr          = 0;
               y_fifo_wr          = 0;
               bram_en            = 0;
               bram_wr            = 0;
               addr_gen_en        = 0;
               x_fifo_rd          = 0;
               y_fifo_rd          = 0;
               p_fifo_rd          = 0;
               m00_en             = 0;
               m01_en             = 0;
               m10_en             = 0;
               m00_r_en           = 0;
               m01_r_en           = 0;
               m10_r_en           = 0;
               div_sel            = 0;
               dividend_valid     = 0;
               divisor_valid      = 0;
               x_mc_en            = 0;
               y_mc_en            = 0;
               mu11_mac_enable_en = 0;
               mu02_mac_enable_en = 0;
               skew_dividend_vld  = 0;
               skew_divisor_vld   = 0;
               skew_r_en          = 0;
               mu11_r_en          = 0;
               mu02_r_en          = 1;
               m02_mult_en        = 0;
               m02_r_en           = 0;
               bram_addr_sel      = 0;
               xp_gen_en          = 0;
               xp_r_en            = 0;
               py_r_en            = 0;
               p2_addr_en         = 0;
               p1_addr_en         = 0;
               p_rd_addr_sel      = 0;
               calc_p1_addr_en    = 0;
               p1_r_en            = 0;
               p2_r_en            = 0;
               p_r_en             = 0;
               p_val_sel          = 0;
               img_addr_sel       = 0;
               sub_p1_p2_en       = 0;
               p_mult_en          = 0;
            end


        endcase // dskw_cs
     end

   assign deskew_done_out = deskew_done_reg;
   
   assign sclr_out =                 sclr_reg;        
   assign x_fifo_wr_out =            x_fifo_wr_reg;        
   assign y_fifo_wr_out =            y_fifo_wr_reg;        
   assign bram_en_out =              bram_en_reg;        
   assign bram_wr_out =              bram_wr_reg;        
   assign addr_gen_en_out =          addr_gen_en_reg;        
   assign x_fifo_rd_out =            x_fifo_rd_reg;        
   assign y_fifo_rd_out =            y_fifo_rd_reg;        
   assign p_fifo_rd_out =            p_fifo_rd_reg;        
   assign m00_en_out =               m00_en_reg;        
   assign m01_en_out =               m01_en_reg;        
   assign m10_en_out =               m10_en_reg;        
   assign m00_r_en_out =             m00_r_en_reg;        
   assign m01_r_en_out =             m01_r_en_reg;        
   assign m10_r_en_out =             m10_r_en_reg;        
   assign div_sel_out =              div_sel_reg;        
   assign dividend_valid_out =       dividend_valid_reg;        
   assign divisor_valid_out =        divisor_valid_reg;        
   assign x_mc_en_out =              x_mc_en_reg;        
   assign y_mc_en_out =              y_mc_en_reg;        
   assign mu11_mac_enable_en_out =   mu11_mac_enable_en_reg;        
   assign mu02_mac_enable_en_out =   mu02_mac_enable_en_reg;        
   assign mu11_r_en_out =            mu11_r_en_reg;        
   assign mu02_r_en_out =            mu02_r_en_reg;        
   assign skew_dividend_vld_out =    skew_dividend_vld_reg;        
   assign skew_divisor_vld_out =     skew_divisor_vld_reg;        
   assign skew_r_en_out =            skew_r_en_reg;        
   assign m02_mult_en_out =          m02_mult_en_reg;        
   assign m02_r_en_out =             m02_r_en_reg;        
   assign bram_addr_sel_out =        bram_addr_sel_reg;        
   assign xp_gen_en_out =            xp_gen_en_reg;        
   assign xp_r_en_out =              xp_r_en_reg;        
   assign py_r_en_out =              py_r_en_reg;        
   assign p2_addr_en_out =           p2_addr_en_reg;        
   assign p1_addr_en_out =           p1_addr_en_reg;        
   assign p_rd_addr_sel_out =        p_rd_addr_sel_reg;        
   assign calc_p1_addr_en_out =      calc_p1_addr_en_reg;        
   assign p1_r_en_out =              p1_r_en_reg;        
   assign p2_r_en_out =              p2_r_en_reg;        
   assign p_r_en_out =               p_r_en_reg;        
   assign p_val_sel_out =            p_val_sel_reg;        
   assign img_addr_sel_out =         img_addr_sel_reg;        
   assign sub_p1_p2_en_out =         sub_p1_p2_en_reg;        
   assign p_mult_en_out =            p_mult_en_reg;        

endmodule



`endif
