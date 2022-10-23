/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "deskew_macros.h"
#include "input_image.h"
#include "sleep.h"

/*STRUCTURES DECLARATIONS*/
static XScuGic INTCInst;
int DSQW_INTERRUPTS_CLEARED;

/*METHOD DECLARATIONS*/
int InitDeskewIrq(int deviceID);
static void DsqwIrqHandler(void *Callback);
u32 get_next_wdata(unsigned int a_addr);
void ProgramDeskewIp(u32 in_img_ptr, u32 out_img_ptr, u32 img_dim);
void load_input_image(u32 a_in_img_ptr, u32 a_img_array_length);
void read_output_image(u32 out_img_ptr, u32 img_array_length);


/////////////////////////////////////////////////////////////

/*METHOD IMPLEMENTATIONS*/
int InitDeskewIrq(int deviceID)
{
	  //MORA:
		XScuGic_Config *IntcConfig;
		int Status;
		IntcConfig = XScuGic_LookupConfig(deviceID);

		//MORA:
		Status = XScuGic_CfgInitialize(&INTCInst, IntcConfig, IntcConfig->CpuBaseAddress);
		if(Status != XST_SUCCESS) return XST_FAILURE;

		//INTERAPT MORA
		Status = XScuGic_Connect(&INTCInst, DSQW_IRQ_ID, (Xil_InterruptHandler)DsqwIrqHandler, NULL);
		if (Status != XST_SUCCESS) {
			return Status;
		}
		XScuGic_Enable(&INTCInst, DSQW_IRQ_ID);

		//XScuGic_SetPriorityTriggerType(&INTCInst, DSQW_IRQ_ID, 0xA8, 0x3);

		//ZA SVAKI SLUCAJ ostavi
		Xil_ExceptionInit();
		Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			(Xil_ExceptionHandler)XScuGic_InterruptHandler,&INTCInst);
		Xil_ExceptionEnable();

		return XST_SUCCESS;
}

void ProgramDeskewIp(u32 in_img_ptr, u32 out_img_ptr, u32 img_dim)
{
	u32 tmp_out_addr, tmp_in_addr;
	u32 start_addr_reg_wdata;
	u32 rdata;

	tmp_out_addr = out_img_ptr & 0xfffffffc;
	tmp_out_addr <<= 14;

	tmp_in_addr = 0x0000ffff & in_img_ptr;
	tmp_in_addr >>= 2;

	start_addr_reg_wdata = in_img_ptr | tmp_out_addr;

	rdata = Xil_In32(DSQW_STAT_REG);

	xil_printf("Deskew STATUS register on init value : %8x\n", rdata);

	Xil_Out32(DSQW_ACK_REG, 0x0000000f); //Clear all the IRQs

	xil_printf("POST ACK\n");

	Xil_Out32(DSQW_START_ADDR_REG, start_addr_reg_wdata);
	
	xil_printf("POST START_ADDR\n");

	Xil_Out32(DSQW_IMG_DIM_REG, img_dim);

	xil_printf("POST IMG_DIM\n");

	Xil_Out32(DSQW_CFG_REG, 0x00000001); //Kick-off Deskewer

}


/*Interrupt handler method*/

static void DsqwIrqHandler(void *Callback)
{
	int rdata;

	rdata = Xil_In32(DSQW_STAT_REG);

	xil_printf("Deskew STATUS register on IRQ value : %8x\n", rdata);

	Xil_Out32(DSQW_ACK_REG, 0x0000000f); //Clear all the IRQs

	rdata = Xil_In32(DSQW_STAT_REG);

	xil_printf("Deskew STATUS register after ACK performed value : %8x\n", rdata);

	DSQW_INTERRUPTS_CLEARED = 1;

}

/*Auxiliary method - generates BRAM WDATA*/

u32 get_next_wdata(unsigned int a_addr)
{
	u32 wdata;
	u32 tmp_data;

	wdata = 0;
	wdata += input_img[a_addr];

	tmp_data = 0;
	tmp_data += input_img[a_addr + 1];
	tmp_data <<= 8;
	wdata |= tmp_data;

	tmp_data = 0;
	tmp_data += input_img[a_addr + 2];
	tmp_data <<= 16;
	wdata |= tmp_data;

	tmp_data = 0;
	tmp_data += input_img[a_addr + 3];
	tmp_data <<= 24;
	wdata |= tmp_data;

	return wdata;
}

/*Recalculates address and loads input image to BRAM*/
void load_input_image(u32 a_in_img_ptr, u32 a_img_array_length)
{
	u32 i;

	 for (i = 0; i < a_img_array_length; i += 4)
	    {
	    	Xil_Out32(	BRAM_BASE_ADDR + a_in_img_ptr + i,
	    				get_next_wdata(i));
	    	xil_printf("Wrote addr : %8x\n\r", BRAM_BASE_ADDR + a_in_img_ptr + i);
	    }

}

/*Recalculates address and reads output image from BRAM*/
void read_output_image(u32 a_out_img_ptr, u32 a_img_array_length)
{
	u32 i,j;
	u32 rdata;


    for (i = 0; i < a_img_array_length; i += 4)
    {
    	rdata = Xil_In32(BRAM_BASE_ADDR + a_out_img_ptr + i);

    	for(j = 0; j < 4; j++)
    	{
    		xil_printf("%0d ",(rdata & 0x000000ff));
    		rdata >>=8;
    	}
    }
}


////////////////////////////////////////////////////////////////////////////////
				/*			M	A	I	N				*/
////////////////////////////////////////////////////////////////////////////////

int main()
{
	int Status; //IRQ Init fucntion status
	u32 img_array_length;
	u32 in_img_ptr;
	u32 out_img_ptr;
	u32 img_dim;

	DSQW_INTERRUPTS_CLEARED = 0;

    init_platform();

    /* INITIALIZE SYSTEM INTERRUPTS*/
    Status = InitDeskewIrq(XPAR_PS7_SCUGIC_0_DEVICE_ID);
    if (Status != XST_SUCCESS)
    {
        	xil_printf("IRQ INIT FAILED. Status : %0d\n", Status);
    		return Status;
    }

    /*CONFIGURE IMAGE PARAMETERS*/
    img_array_length = 65536;
    img_dim = 256;
    in_img_ptr = 	0x00000000;
    out_img_ptr = 	0x00010000;

    /*LOAD IMAGE TO MEMORY*/
    load_input_image(in_img_ptr, img_array_length);

    /*Kick-off the Deskewer*/
    ProgramDeskewIp(in_img_ptr, out_img_ptr, img_dim);

    xil_printf("Deskew Programmed!\n");

    /*Wait for the interrupt*/
    while(DSQW_INTERRUPTS_CLEARED != 1)
      {
    	sleep(10);
      }

    DSQW_INTERRUPTS_CLEARED = 0;
    
    xil_printf("Interrupt acknowledged!\n");

    /*READ OUTPUT IMAGE FROM MEMORY*/
    read_output_image(out_img_ptr, img_array_length);

    /*Format the rest of the print*/
    xil_printf("\n\n");

    /*LOAD IMAGE TO MEMORY*/
    print("Deskew done\n\r");
    cleanup_platform();
    return 0;
}
