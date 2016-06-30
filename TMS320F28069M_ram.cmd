/*
 * Copyright (c) 2013, Texas Instruments Incorporated
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * *  Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * *  Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * *  Neither the name of Texas Instruments Incorporated nor the names of
 *    its contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
/*
 *  Source FIle: ======== TMS320F28069M.cmd ========
 *  Define the memory block start/length for the F28069M
 */

/* 
 *  PAGE 0 will be used to organize program sections
 *  PAGE 1 will be used to organize data sections
 *
 *  Notes:
 *      Memory blocks on F2806x are uniform (ie same
 *      physical memory) in both PAGE 0 and PAGE 1.
 *      That is the same memory region should not be
 *      defined for both PAGE 0 and PAGE 1.
 *      Doing so will result in corruption of program
 *      and/or data.
 */

/*****************************************************************
	For RTOS + Motorware integrated project.
		Runs all from RAM / ROM ( no flash needed) for debugging.
  6-28-16:

Notes:

1)
RTOS declarations below take up absolute declared memory.
Thy must not overlap ram sections or should be put in their own section.

abs   00000001  _xdc_runtime_Startup__EXECFXN__C
abs   00000001  _xdc_runtime_Startup__RESETFXN__C

xdc.meta   0    00000000    0000012a     COPY SECTION
                00000000    0000012a     app_p28L.o28L (xdc.meta)

xdc.noload
*          0    00000000    00000000     COPY SECTION

00000000       0 (00000000)     ___ISA__
00000011       0 (00000000)     ___TARG__
00000035       0 (00000000)     ___PLAT__
0000005b       1 (00000040)     ___TRDR__
00000082       2 (00000080)     ___ASM__

Check the .map file for the above if in doubt.

2)
it appears that .ebss must be < 0x00010000 or program fails.
partial (before / after) seconds for this were not tried, just all above or below 0x10000.
is this a jump address that does not cross pages ???
If this is violated, debugger starts but never makes it to main.


*/

MEMORY
{
PAGE 0 :   /* Program Memory */

/*    M0SARAM   : origin = 0x000050, length = 0x0003B0*/	/* normal TI designation. */
    L01_xSARAM    : origin = 0x008000, length = 0x001500    /* on-chip RAM block L0-L1x */

    OTP         : origin = 0x3D7800, length = 0x000400     /* on-chip OTP */

/* if using flash for anything, uncomment it below.        */
/*    FLASH       : origin = 0x3D8000, length = 0x01FF80 */    /* on-chip FLASH */

    CSM_RSVD    : origin = 0x3F7F80, length = 0x000076     /* Program with all 0x0000 when CSM is in use. */
    BEGIN       : origin = 0x3F7FF6, length = 0x000002     /* Used for "boot to Flash" bootloader mode. */
    CSM_PWL     : origin = 0x3F7FF8, length = 0x000008     /* CSM password locations in FLASH */


	L_SARAM      : origin 0x009500, length = 0x008300	/* rest of ram to spin tac.*/
/*	L_SARAM      : origin 0x009500, length = 0x00A300	*//* rest of ram to spin tac.*/

	/* ROM tables *******************************************/
	/* use the desired tables and comment out the improper ones for the chip.

	/*  F28069M with instaspin: */
   FPUTABLES   : origin = 0x3FD590, length = 0x0006A0
   IQTABLES    : origin = 0x3FDC30, length = 0x000B50
   IQTABLES2   : origin = 0x3FE780, length = 0x00008C
   IQTABLES3   : origin = 0x3FE80C, length = 0x0000AA

  /* F28069 no M / no instaspin		*/
/*
    FPUTABLES   : origin = 0x3FD860, length = 0x0006A0
    IQTABLES    : origin = 0x3FDF00, length = 0x000B50
    IQTABLES2   : origin = 0x3FEA50, length = 0x00008C
    IQTABLES3   : origin = 0x3FEADC, length = 0x0000AA
*/
	/* end ROM table.  ***************************************/

    
	ROM         : origin = 0x3FF3B0, length = 0x000C10     /* Boot ROM */
    RESET       : origin = 0x3FFFC0, length = 0x000002     /* part of boot ROM  */
    VECTORS     : origin = 0x3FFFC2, length = 0x00003E     /* part of boot ROM  */

PAGE 1 :   /* Data Memory */

    M01SARAM    : origin = 0x000200, length = 0x000600     /* on-chip RAM block 1/2 of M0 + all of M1 */
    PIEVECT     : origin = 0xD00,    length = 0x100		   /* PIE for BIOS */

}

/*
 *  Allocate sections to memory blocks.
 *  Note:
 *      codestart   user defined section in DSP28_CodeStartBranch.asm
 *                  used to redirect code execution when booting to flash
 *
 *      ramfuncs    user defined section to store functions that will be
 *                  copied from Flash into RAM
 */ 
 
SECTIONS
{
    /* Allocate program areas: */
    .cinit              : > L_SARAM     PAGE = 0

	.pinit              : > L_SARAM 	PAGE = 0
    .text               : > L_SARAM     PAGE = 0
    codestart           : > BEGIN       PAGE = 0

/* if needed, uncomment out ramfuncs.
Normally for a RAM build, items don't get coppied to RAM from ram. */

/*
    ramfuncs            : LOAD = FLASH      PAGE = 0,
                          RUN  = L_SARAM   PAGE = 0,
                          LOAD_START(_RamfuncsLoadStart),
                          LOAD_SIZE(_RamfuncsLoadSize),
                          LOAD_END(_RamfuncsLoadEnd),
                          RUN_START(_RamfuncsRunStart)
*/

	ramfuncs            : > L_SARAM    PAGE = 0
    csmpasswds          : > CSM_PWL    PAGE = 0
    csm_rsvd            : > CSM_RSVD   PAGE = 0

    /* Allocate uninitalized data sections: */
    .stack              : > M01SARAM   PAGE = 1
	/* .ebss has: mainly app_p28L.028L   (.ebss:taskStackSection).
	   if .ebss is > 0x10000, it seems to fail.
	   additional experimenting has shown .ebss to work with align(4).
	 */

	 .ebss               : > L01_xSARAM   PAGE = 0,  ALIGN(4)


    .esysmem            : > L_SARAM 	PAGE = 0
    .cio                : > L_SARAM 	PAGE = 0

    /* Initalized sections go in Flash */
    /* For SDFlash to program these, they must be allocated to page 0 */
    .econst             : > L_SARAM     PAGE = 0
    .switch             : > L_SARAM     PAGE = 0
    .args               : > L_SARAM     PAGE = 0

    /* Allocate IQ math areas: */
    IQmath              : > L_SARAM     PAGE = 0            /* Math Code */
    IQmathTables        : > IQTABLES    PAGE = 0, TYPE = NOLOAD

    /* Allocate FPU math areas: */
    FPUmathTables       : > FPUTABLES   PAGE = 0, TYPE = NOLOAD

    /*
     *  Uncomment the section below if calling the IQNexp() or IQexp()
     *  functions from the IQMath.lib library in order to utilize the 
     *  relevant IQ Math table in Boot ROM (This saves space and Boot ROM 
     *  is 1 wait-state). If this section is not uncommented, IQmathTables2
     *  will be loaded into other memory (SARAM, Flash, etc.) and will take
     *  up space, but 0 wait-state is possible.
     */
    /*
    IQmathTables2       : > IQTABLES2   PAGE = 0, TYPE = NOLOAD
    {
        IQmath.lib<IQNexpTable.obj> (IQmathTablesRam)
    }
	*/

    /*
     *  Uncomment the section below if calling the IQNasin() or IQasin()
     *  functions from the IQMath.lib library in order to utilize the
     *  relevant IQ Math table in Boot ROM (This saves space and Boot ROM
     *  is 1 wait-state). If this section is not uncommented, IQmathTables2
     *  will be loaded into other memory (SARAM, Flash, etc.) and will take
     *  up space, but 0 wait-state is possible.
     */
    /*
    IQmathTables3       : > IQTABLES3   PAGE = 0, TYPE = NOLOAD
    {
        IQmath.lib<IQNasinTable.obj> (IQmathTablesRam)
    }
    */
}
