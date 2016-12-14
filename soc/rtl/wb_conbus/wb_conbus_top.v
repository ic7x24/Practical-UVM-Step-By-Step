//////////////////////////////////////////////////////////////////////
////                                                              ////
////  WISHBONE Connection Bus Top Level		                  ////
////                                                              ////
////                                                              ////
////  Author: Johny Chi			                          ////
////          chisuhua@yahoo.com.cn                               ////
////  Modified to include or1200 boot instructions (jb@orsoc.se)  ////
////                                                              ////
////  Downloaded from: http://opencores.org/project,wb_conbus     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
//  Description
//	1. Up to 8 masters and 8 slaves share bus Wishbone connection
//	2. no priorty arbitor , 8 masters are processed in a round
//	   robin way,
//	3. if WB_USE_TRISTATE was defined, the share bus is a tristate
//	   bus, and use less logic resource.
//	4. wb_conbus was synthesis to XC2S100-5-PQ208 using synplify,
//     Max speed >60M , and 374 SLICE if using Multiplexor bus
//		or 150 SLICE if using tri-state bus.
//

//`define 		WB_USE_TRISTATE

module wb_conbus_top(
		     clk_i, rst_i,

		     // Master 0 Interface
		     m0_dat_i, m0_dat_o, m0_adr_i, m0_sel_i, m0_we_i, m0_cyc_i,
		     m0_stb_i, m0_ack_o, m0_err_o, m0_rty_o, m0_cab_i,

		     // Master 1 Interface
		     m1_dat_i, m1_dat_o, m1_adr_i, m1_sel_i, m1_we_i, m1_cyc_i,
		     m1_stb_i, m1_ack_o, m1_err_o, m1_rty_o, m1_cab_i,

		     // Master 2 Interface
		     m2_dat_i, m2_dat_o, m2_adr_i, m2_sel_i, m2_we_i, m2_cyc_i,
		     m2_stb_i, m2_ack_o, m2_err_o, m2_rty_o, m2_cab_i,

		     // Master 3 Interface
		     m3_dat_i, m3_dat_o, m3_adr_i, m3_sel_i, m3_we_i, m3_cyc_i,
		     m3_stb_i, m3_ack_o, m3_err_o, m3_rty_o, m3_cab_i,

		     // Master 4 Interface
		     m4_dat_i, m4_dat_o, m4_adr_i, m4_sel_i, m4_we_i, m4_cyc_i,
		     m4_stb_i, m4_ack_o, m4_err_o, m4_rty_o, m4_cab_i,

		     // Master 5 Interface
		     m5_dat_i, m5_dat_o, m5_adr_i, m5_sel_i, m5_we_i, m5_cyc_i,
		     m5_stb_i, m5_ack_o, m5_err_o, m5_rty_o, m5_cab_i,

		     // Master 6 Interface
		     m6_dat_i, m6_dat_o, m6_adr_i, m6_sel_i, m6_we_i, m6_cyc_i,
		     m6_stb_i, m6_ack_o, m6_err_o, m6_rty_o, m6_cab_i,

		     // Master 7 Interface
		     m7_dat_i, m7_dat_o, m7_adr_i, m7_sel_i, m7_we_i, m7_cyc_i,
		     m7_stb_i, m7_ack_o, m7_err_o, m7_rty_o, m7_cab_i,

		     // Slave 0 Interface
		     s0_dat_i, s0_dat_o, s0_adr_o, s0_sel_o, s0_we_o, s0_cyc_o,
		     s0_stb_o, s0_ack_i, s0_err_i, s0_rty_i, s0_cab_o,

		     // Slave 1 Interface
		     s1_dat_i, s1_dat_o, s1_adr_o, s1_sel_o, s1_we_o, s1_cyc_o,
		     s1_stb_o, s1_ack_i, s1_err_i, s1_rty_i, s1_cab_o,

		     // Slave 2 Interface
		     s2_dat_i, s2_dat_o, s2_adr_o, s2_sel_o, s2_we_o, s2_cyc_o,
		     s2_stb_o, s2_ack_i, s2_err_i, s2_rty_i, s2_cab_o,

		     // Slave 3 Interface
		     s3_dat_i, s3_dat_o, s3_adr_o, s3_sel_o, s3_we_o, s3_cyc_o,
		     s3_stb_o, s3_ack_i, s3_err_i, s3_rty_i, s3_cab_o,

		     // Slave 4 Interface
		     s4_dat_i, s4_dat_o, s4_adr_o, s4_sel_o, s4_we_o, s4_cyc_o,
		     s4_stb_o, s4_ack_i, s4_err_i, s4_rty_i, s4_cab_o,

		     // Slave 5 Interface
		     s5_dat_i, s5_dat_o, s5_adr_o, s5_sel_o, s5_we_o, s5_cyc_o,
		     s5_stb_o, s5_ack_i, s5_err_i, s5_rty_i, s5_cab_o,

		     // Slave 6 Interface
		     s6_dat_i, s6_dat_o, s6_adr_o, s6_sel_o, s6_we_o, s6_cyc_o,
		     s6_stb_o, s6_ack_i, s6_err_i, s6_rty_i, s6_cab_o,

		     // Slave 7 Interface
		     s7_dat_i, s7_dat_o, s7_adr_o, s7_sel_o, s7_we_o, s7_cyc_o,
		     s7_stb_o, s7_ack_i, s7_err_i, s7_rty_i, s7_cab_o

		     );


`include "../common/wb_conbus_defines.v"

   ////////////////////////////////////////////////////////////////////
   //
   // Module Parameters
   //
   parameter		s0_addr_w = 4 ;			// slave 0 address decode width
   parameter		s0_addr = 4'h0;			// slave 0 address
   parameter		s1_addr_w = 4 ;			// slave 1 address decode width
   parameter		s1_addr = 4'h1;			// slave 1 address 
   parameter		s27_addr_w = 8 ;		// slave 2 to slave 7 address decode width
   parameter		s2_addr = 8'h92;		// slave 2 address
   parameter		s3_addr = 8'h93;		// slave 3 address
   parameter		s4_addr = 8'h94;		// slave 4 address
   parameter		s5_addr = 8'h95;		// slave 5 address
   parameter		s6_addr = 8'h96;		// slave 6 address
   parameter		s7_addr = 8'h97;		// slave 7 address

   
   ////////////////////////////////////////////////////////////////////
   //
   // Module IOs
   //

   input		clk_i, rst_i;

   // Master 0 Interface
   input [`dw-1:0] 	m0_dat_i;
   output [`dw-1:0] 	m0_dat_o;
   input [`aw-1:0] 	m0_adr_i;
   input [`sw-1:0] 	m0_sel_i;
   input 		m0_we_i;
   input 		m0_cyc_i;
   input 		m0_stb_i;
   input 		m0_cab_i;
   output 		m0_ack_o;
   output 		m0_err_o;
   output 		m0_rty_o;

   // Master 1 Interface
   input [`dw-1:0] 	m1_dat_i;
   output [`dw-1:0] 	m1_dat_o;
   input [`aw-1:0] 	m1_adr_i;
   input [`sw-1:0] 	m1_sel_i;
   input 		m1_we_i;
   input 		m1_cyc_i;
   input 		m1_stb_i;
   input 		m1_cab_i;
   output 		m1_ack_o;
   output 		m1_err_o;
   output 		m1_rty_o;

   // Master 2 Interface
   input [`dw-1:0] 	m2_dat_i;
   output [`dw-1:0] 	m2_dat_o;
   input [`aw-1:0] 	m2_adr_i;
   input [`sw-1:0] 	m2_sel_i;
   input 		m2_we_i;
   input 		m2_cyc_i;
   input 		m2_stb_i;
   input 		m2_cab_i;
   output 		m2_ack_o;
   output 		m2_err_o;
   output 		m2_rty_o;

   // Master 3 Interface
   input [`dw-1:0] 	m3_dat_i;
   output [`dw-1:0] 	m3_dat_o;
   input [`aw-1:0] 	m3_adr_i;
   input [`sw-1:0] 	m3_sel_i;
   input 		m3_we_i;
   input 		m3_cyc_i;
   input 		m3_stb_i;
   input 		m3_cab_i;
   output 		m3_ack_o;
   output 		m3_err_o;
   output 		m3_rty_o;

   // Master 4 Interface
   input [`dw-1:0] 	m4_dat_i;
   output [`dw-1:0] 	m4_dat_o;
   input [`aw-1:0] 	m4_adr_i;
   input [`sw-1:0] 	m4_sel_i;
   input 		m4_we_i;
   input 		m4_cyc_i;
   input 		m4_stb_i;
   input 		m4_cab_i;
   output 		m4_ack_o;
   output 		m4_err_o;
   output 		m4_rty_o;

   // Master 5 Interface
   input [`dw-1:0] 	m5_dat_i;
   output [`dw-1:0] 	m5_dat_o;
   input [`aw-1:0] 	m5_adr_i;
   input [`sw-1:0] 	m5_sel_i;
   input 		m5_we_i;
   input 		m5_cyc_i;
   input 		m5_stb_i;
   input 		m5_cab_i;
   output 		m5_ack_o;
   output 		m5_err_o;
   output 		m5_rty_o;

   // Master 6 Interface
   input [`dw-1:0] 	m6_dat_i;
   output [`dw-1:0] 	m6_dat_o;
   input [`aw-1:0] 	m6_adr_i;
   input [`sw-1:0] 	m6_sel_i;
   input 		m6_we_i;
   input 		m6_cyc_i;
   input 		m6_stb_i;
   input 		m6_cab_i;
   output 		m6_ack_o;
   output 		m6_err_o;
   output 		m6_rty_o;

   // Master 7 Interface
   input [`dw-1:0] 	m7_dat_i;
   output [`dw-1:0] 	m7_dat_o;
   input [`aw-1:0] 	m7_adr_i;
   input [`sw-1:0] 	m7_sel_i;
   input 		m7_we_i;
   input 		m7_cyc_i;
   input 		m7_stb_i;
   input 		m7_cab_i;
   output 		m7_ack_o;
   output 		m7_err_o;
   output 		m7_rty_o;

   // Slave 0 Interface
   input [`dw-1:0] 	s0_dat_i;
   output [`dw-1:0] 	s0_dat_o;
   output [`aw-1:0] 	s0_adr_o;
   output [`sw-1:0] 	s0_sel_o;
   output 		s0_we_o;
   output 		s0_cyc_o;
   output 		s0_stb_o;
   output 		s0_cab_o;
   input 		s0_ack_i;
   input 		s0_err_i;
   input 		s0_rty_i;

   // Slave 1 Interface
   input [`dw-1:0] 	s1_dat_i;
   output [`dw-1:0] 	s1_dat_o;
   output [`aw-1:0] 	s1_adr_o;
   output [`sw-1:0] 	s1_sel_o;
   output 		s1_we_o;
   output 		s1_cyc_o;
   output 		s1_stb_o;
   output 		s1_cab_o;
   input 		s1_ack_i;
   input 		s1_err_i;
   input 		s1_rty_i;

   // Slave 2 Interface
   input [`dw-1:0] 	s2_dat_i;
   output [`dw-1:0] 	s2_dat_o;
   output [`aw-1:0] 	s2_adr_o;
   output [`sw-1:0] 	s2_sel_o;
   output 		s2_we_o;
   output 		s2_cyc_o;
   output 		s2_stb_o;
   output 		s2_cab_o;
   input 		s2_ack_i;
   input 		s2_err_i;
   input 		s2_rty_i;

   // Slave 3 Interface
   input [`dw-1:0] 	s3_dat_i;
   output [`dw-1:0] 	s3_dat_o;
   output [`aw-1:0] 	s3_adr_o;
   output [`sw-1:0] 	s3_sel_o;
   output 		s3_we_o;
   output 		s3_cyc_o;
   output 		s3_stb_o;
   output 		s3_cab_o;
   input 		s3_ack_i;
   input 		s3_err_i;
   input 		s3_rty_i;

   // Slave 4 Interface
   input [`dw-1:0] 	s4_dat_i;
   output [`dw-1:0] 	s4_dat_o;
   output [`aw-1:0] 	s4_adr_o;
   output [`sw-1:0] 	s4_sel_o;
   output 		s4_we_o;
   output 		s4_cyc_o;
   output 		s4_stb_o;
   output 		s4_cab_o;
   input 		s4_ack_i;
   input 		s4_err_i;
   input 		s4_rty_i;

   // Slave 5 Interface
   input [`dw-1:0] 	s5_dat_i;
   output [`dw-1:0] 	s5_dat_o;
   output [`aw-1:0] 	s5_adr_o;
   output [`sw-1:0] 	s5_sel_o;
   output 		s5_we_o;
   output 		s5_cyc_o;
   output 		s5_stb_o;
   output 		s5_cab_o;
   input 		s5_ack_i;
   input 		s5_err_i;
   input 		s5_rty_i;

   // Slave 6 Interface
   input [`dw-1:0] 	s6_dat_i;
   output [`dw-1:0] 	s6_dat_o;
   output [`aw-1:0] 	s6_adr_o;
   output [`sw-1:0] 	s6_sel_o;
   output 		s6_we_o;
   output 		s6_cyc_o;
   output 		s6_stb_o;
   output 		s6_cab_o;
   input 		s6_ack_i;
   input 		s6_err_i;
   input 		s6_rty_i;

   // Slave 7 Interface
   input [`dw-1:0] 	s7_dat_i;
   output [`dw-1:0] 	s7_dat_o;
   output [`aw-1:0] 	s7_adr_o;
   output [`sw-1:0] 	s7_sel_o;
   output 		s7_we_o;
   output 		s7_cyc_o;
   output 		s7_stb_o;
   output 		s7_cab_o;
   input 		s7_ack_i;
   input 		s7_err_i;
   input 		s7_rty_i;


   ////////////////////////////////////////////////////////////////////
   //
   // Local wires
   //

   wire [`mselectw -1:0] i_gnt_arb;
   wire [2:0] 		 gnt/* verilator public */;
   reg [`sselectw -1:0]  i_ssel_dec;
`ifdef	WB_USE_TRISTATE
   wire [`mbusw -1:0] 	 i_bus_m;
`else
   reg [`mbusw -1:0] 	 i_bus_m;		// internal share bus, master data and control to slave
`endif
   wire [`dw -1:0] 	 i_dat_s;	// internal share bus , slave data to master
   wire [`sbusw -1:0] 	 i_bus_s;			// internal share bus , slave control to master

   wire [7:0] 		 addr_err; // Generate an error signal when no slave is selected
   reg 			 addr_err_r;
   wire 		 addr_err_out;

   ////////////////////////////////////////////////////////////////////
   //
   // OR1200 reset boot instruction generation
   //
`ifdef OR1200_BOOT_LOGIC
   // Presumes OR1200 instruction bus is master 0
   reg [2:0] 		 count;
   reg 			 proc_init;
   reg 			 proc_init_ack_o;
   reg [31:0] 		 proc_init_dat_o;
 `define OR1200_BOOT_LOGIC_NUM_INSNS 4

   always @(posedge clk_i or posedge rst_i)
     begin
	if (rst_i)
	  begin
	     proc_init <= 1'b1;
	     count <= 0;
	     proc_init_ack_o <= 1'b0;
	  end
	else
	  begin
	     if (proc_init)
	       begin
		  // Advance counter when de asserting ack
		  if (m0_cyc_i & m0_stb_i & proc_init_ack_o)
		    begin
		       proc_init_ack_o <= 1'b0;
		       
		       if (count < `OR1200_BOOT_LOGIC_NUM_INSNS)
			 count <= count + 1;
		    end
		  
		  // Assert ack
		  if (m0_cyc_i & m0_stb_i & ~proc_init_ack_o)
		    proc_init_ack_o <= 1'b1;

		  // Finish this init logic when we've output all insns
		  if (count == `OR1200_BOOT_LOGIC_NUM_INSNS)
		    proc_init <= 1'b0;
	       end // if (proc_init)
	  end // else: !if(rst_i)
     end // always @ (posedge clk_i or posedge rst_i)
   //`define ARB_BOOT_TOP_WORD f000
   //`define ARB_BOOT_BTM_WORD 0100
   
   always @(count)
     begin
	case (count)
	  //	  0: proc_init_dat_o <= 32'h1820_`ARB_BOOT_TOP_WORD; //l.movhi r1,0xf000
	  //	  1: proc_init_dat_o <= 32'ha821_`ARB_BOOT_BTM_WORD; //l.ori r1,r1,0x100
	  0: proc_init_dat_o = 32'h1820_f000; //l.movhi r1,0xf000
	  1: proc_init_dat_o = 32'ha821_0100; //l.ori r1,r1,0x100

	  2: proc_init_dat_o = 32'h44000800; //l.jr r1
	  3: proc_init_dat_o = 32'h15000000; //l.nop 0x0
	  4: proc_init_dat_o = 32'h15000000; //l.nop 0x0
	endcase // case (count)
     end
   


   ////////////////////////////////////////////////////////////////////
   //
   // Master output Interfaces
   //
   
   // master0
   assign	m0_dat_o =  proc_init ? proc_init_dat_o : i_dat_s;
   assign  {m0_ack_o, m0_err_o, m0_rty_o} = proc_init ? {proc_init_ack_o, 2'b00}  :
					    i_bus_s & {3{i_gnt_arb[0]}};
   
`else // !`ifdef OR1200_BOOT_LOGIC
   
   // master0
   assign	m0_dat_o = i_dat_s;
   assign  {m0_ack_o, m0_err_o, m0_rty_o} = i_bus_s & {3{i_gnt_arb[0]}};
`endif // !`ifdef OR1200_BOOT_LOGIC

   // master1
   assign	m1_dat_o = i_dat_s;
   assign  {m1_ack_o, m1_err_o, m1_rty_o} = i_bus_s & {3{i_gnt_arb[1]}};

   // master2

   assign	m2_dat_o = i_dat_s;
   assign  {m2_ack_o, m2_err_o, m2_rty_o} = i_bus_s & {3{i_gnt_arb[2]}};

   // master3

   assign	m3_dat_o = i_dat_s;
   assign  {m3_ack_o, m3_err_o, m3_rty_o} = i_bus_s & {3{i_gnt_arb[3]}};

   // master4

   assign	m4_dat_o = i_dat_s;
   assign  {m4_ack_o, m4_err_o, m4_rty_o} = i_bus_s & {3{i_gnt_arb[4]}};

   // master5

   assign	m5_dat_o = i_dat_s;
   assign  {m5_ack_o, m5_err_o, m5_rty_o} = i_bus_s & {3{i_gnt_arb[5]}};

   // master6

   assign	m6_dat_o = i_dat_s;
   assign  {m6_ack_o, m6_err_o, m6_rty_o} = i_bus_s & {3{i_gnt_arb[6]}};

   // master7

   assign	m7_dat_o = i_dat_s;
   assign  {m7_ack_o, m7_err_o, m7_rty_o} = i_bus_s & {3{i_gnt_arb[7]}};

   // Now containing additional no-existing slave select err bit -- jb 090905
   assign  i_bus_s = {s0_ack_i | s1_ack_i | s2_ack_i | s3_ack_i | s4_ack_i | s5_ack_i | s6_ack_i | s7_ack_i ,
		      s0_err_i | s1_err_i | s2_err_i | s3_err_i | s4_err_i | s5_err_i | s6_err_i | s7_err_i | addr_err_out,
		      s0_rty_i | s1_rty_i | s2_rty_i | s3_rty_i | s4_rty_i | s5_rty_i | s6_rty_i | s7_rty_i };

   ////////////////////////////////
   //	Slave output interface
   //
   // slave0
   assign  {s0_adr_o, s0_sel_o, s0_dat_o, s0_we_o, s0_cab_o,s0_cyc_o} = i_bus_m[`mbusw -1:1];
`ifdef OR1200_BOOT_LOGIC
   assign	s0_stb_o = i_bus_m[1] & i_bus_m[0] & i_ssel_dec[0] & ~proc_init;  // stb_o = cyc_i & stb_i & i_ssel_dec
`else   
   assign	s0_stb_o = i_bus_m[1] & i_bus_m[0] & i_ssel_dec[0];  // stb_o = cyc_i & stb_i & i_ssel_dec
`endif

   // slave1

   assign  {s1_adr_o, s1_sel_o, s1_dat_o, s1_we_o, s1_cab_o, s1_cyc_o} = i_bus_m[`mbusw -1:1];
   assign	s1_stb_o = i_bus_m[1] & i_bus_m[0] & i_ssel_dec[1];

   // slave2

   assign  {s2_adr_o, s2_sel_o, s2_dat_o, s2_we_o, s2_cab_o, s2_cyc_o} = i_bus_m[`mbusw -1:1];
   assign	s2_stb_o = i_bus_m[1] & i_bus_m[0] & i_ssel_dec[2];

   // slave3

   assign  {s3_adr_o, s3_sel_o, s3_dat_o, s3_we_o, s3_cab_o, s3_cyc_o} = i_bus_m[`mbusw -1:1];
   assign	s3_stb_o = i_bus_m[1] & i_bus_m[0] & i_ssel_dec[3];

   // slave4

   assign  {s4_adr_o, s4_sel_o, s4_dat_o, s4_we_o, s4_cab_o, s4_cyc_o} = i_bus_m[`mbusw -1:1];
   assign	s4_stb_o = i_bus_m[1] & i_bus_m[0] & i_ssel_dec[4];

   // slave5

   assign  {s5_adr_o, s5_sel_o, s5_dat_o, s5_we_o, s5_cab_o, s5_cyc_o} = i_bus_m[`mbusw -1:1];
   assign	s5_stb_o = i_bus_m[1] & i_bus_m[0] & i_ssel_dec[5];

   // slave6

   assign  {s6_adr_o, s6_sel_o, s6_dat_o, s6_we_o, s6_cab_o, s6_cyc_o} = i_bus_m[`mbusw -1:1];
   assign	s6_stb_o = i_bus_m[1] & i_bus_m[0] & i_ssel_dec[6];

   // slave7

   assign  {s7_adr_o, s7_sel_o, s7_dat_o, s7_we_o, s7_cab_o, s7_cyc_o} = i_bus_m[`mbusw -1:1];
   assign	s7_stb_o = i_bus_m[1] & i_bus_m[0] & i_ssel_dec[7];

   ///////////////////////////////////////
   //	Master and Slave input interface
   //

`ifdef	WB_USE_TRISTATE
   // input from master interface
   assign	i_bus_m = i_gnt_arb[0] ? {m0_adr_i, m0_sel_i, m0_dat_i, m0_we_i, m0_cab_i, m0_cyc_i, m0_stb_i} : 72'bz ;
   assign	i_bus_m = i_gnt_arb[1] ? {m1_adr_i, m1_sel_i, m1_dat_i, m1_we_i, m1_cab_i,m1_cyc_i, m1_stb_i} : 72'bz ;
   assign	i_bus_m = i_gnt_arb[2] ? {m2_adr_i, m2_sel_i, m2_dat_i,  m2_we_i, m2_cab_i, m2_cyc_i, m2_stb_i} : 72'bz ;
   assign	i_bus_m = i_gnt_arb[3] ? {m3_adr_i, m3_sel_i, m3_dat_i,  m3_we_i, m3_cab_i, m3_cyc_i, m3_stb_i} : 72'bz ;
   assign	i_bus_m = i_gnt_arb[4] ? {m4_adr_i, m4_sel_i, m4_dat_i,  m4_we_i, m4_cab_i, m4_cyc_i, m4_stb_i} : 72'bz ;
   assign	i_bus_m = i_gnt_arb[5] ? {m5_adr_i, m5_sel_i, m5_dat_i, m5_we_i, m5_cab_i, m5_cyc_i,  m5_stb_i} : 72'bz ;
   assign	i_bus_m = i_gnt_arb[6] ? {m6_adr_i, m6_sel_i, m6_dat_i, m6_we_i, m6_cab_i, m6_cyc_i, m6_stb_i} : 72'bz ;
   assign	i_bus_m = i_gnt_arb[7] ? {m7_adr_i, m7_sel_i, m7_dat_i, m7_we_i, m7_cab_i, m7_cyc_i,m7_stb_i} : 72'bz ;
   // input from slave interface
   assign  i_dat_s = i_ssel_dec[0] ? s0_dat_i: 32'bz;
   assign  i_dat_s = i_ssel_dec[1] ? s1_dat_i: 32'bz;
   assign  i_dat_s = i_ssel_dec[2] ? s2_dat_i: 32'bz;
   assign  i_dat_s = i_ssel_dec[3] ? s3_dat_i: 32'bz;
   assign  i_dat_s = i_ssel_dec[4] ? s4_dat_i: 32'bz;
   assign  i_dat_s = i_ssel_dec[5] ? s5_dat_i: 32'bz;
   assign  i_dat_s = i_ssel_dec[6] ? s6_dat_i: 32'bz;
   assign  i_dat_s = i_ssel_dec[7] ? s7_dat_i: 32'bz;

`else

   always @(gnt , m0_adr_i, m0_sel_i, m0_dat_i, m0_we_i, m0_cab_i, m0_cyc_i,m0_stb_i,
	    m1_adr_i, m1_sel_i, m1_dat_i, m1_we_i, m1_cab_i, m1_cyc_i,m1_stb_i,
	    m2_adr_i, m2_sel_i, m2_dat_i, m2_we_i, m2_cab_i, m2_cyc_i,m2_stb_i,
	    m3_adr_i, m3_sel_i, m3_dat_i, m3_we_i, m3_cab_i, m3_cyc_i,m3_stb_i,
	    m4_adr_i, m4_sel_i, m4_dat_i, m4_we_i, m4_cab_i, m4_cyc_i,m4_stb_i,
	    m5_adr_i, m5_sel_i, m5_dat_i, m5_we_i, m5_cab_i, m5_cyc_i,m5_stb_i,
	    m6_adr_i, m6_sel_i, m6_dat_i, m6_we_i, m6_cab_i, m6_cyc_i,m6_stb_i,
	    m7_adr_i, m7_sel_i, m7_dat_i, m7_we_i, m7_cab_i, m7_cyc_i,m7_stb_i)
     case(gnt)
       /* verilator lint_off WIDTHCONCAT */
       3'h0:	i_bus_m = {m0_adr_i, m0_sel_i, m0_dat_i, m0_we_i, m0_cab_i, m0_cyc_i,m0_stb_i};
       3'h1:	i_bus_m = {m1_adr_i, m1_sel_i, m1_dat_i, m1_we_i, m1_cab_i, m1_cyc_i,m1_stb_i};
       3'h2:	i_bus_m = {m2_adr_i, m2_sel_i, m2_dat_i, m2_we_i, m2_cab_i, m2_cyc_i,m2_stb_i};
       3'h3:	i_bus_m = {m3_adr_i, m3_sel_i, m3_dat_i, m3_we_i, m3_cab_i, m3_cyc_i,m3_stb_i};
       3'h4:	i_bus_m = {m4_adr_i, m4_sel_i, m4_dat_i, m4_we_i, m4_cab_i, m4_cyc_i,m4_stb_i};
       3'h5:	i_bus_m = {m5_adr_i, m5_sel_i, m5_dat_i, m5_we_i, m5_cab_i, m5_cyc_i,m5_stb_i};
       3'h6:	i_bus_m = {m6_adr_i, m6_sel_i, m6_dat_i, m6_we_i, m6_cab_i, m6_cyc_i,m6_stb_i};
       3'h7:	i_bus_m = {m7_adr_i, m7_sel_i, m7_dat_i, m7_we_i, m7_cab_i, m7_cyc_i,m7_stb_i};
       default:i_bus_m =  72'b0;//{m0_adr_i, m0_sel_i, m0_dat_i, m0_we_i, m0_cab_i, m0_cyc_i,m0_stb_i};
       /* verilator lint_on WIDTHCONCAT */
     endcase			

   assign	i_dat_s = i_ssel_dec[0] ? s0_dat_i :
			  i_ssel_dec[1] ? s1_dat_i :
			  i_ssel_dec[2] ? s2_dat_i :
			  i_ssel_dec[3] ? s3_dat_i :
			  i_ssel_dec[4] ? s4_dat_i :
			  i_ssel_dec[5] ? s5_dat_i :
			  i_ssel_dec[6] ? s6_dat_i :
			  i_ssel_dec[7] ? s7_dat_i : {`dw{1'b0}}; 
`endif
   //
   // arbitor 
   //
   assign i_gnt_arb[0] = (gnt == 3'd0);
   assign i_gnt_arb[1] = (gnt == 3'd1);
   assign i_gnt_arb[2] = (gnt == 3'd2);
   assign i_gnt_arb[3] = (gnt == 3'd3);
   assign i_gnt_arb[4] = (gnt == 3'd4);
   assign i_gnt_arb[5] = (gnt == 3'd5);
   assign i_gnt_arb[6] = (gnt == 3'd6);
   assign i_gnt_arb[7] = (gnt == 3'd7);

   wire arb_rst;
`ifdef OR1200_BOOT_LOGIC
   assign arb_rst = rst_i | proc_init;
`else
   assign arb_rst = rst_i;
`endif
   wb_conbus_arb	wb_conbus_arb(
				      .clk(clk_i), 
				      .rst(arb_rst),
				      .req({	m7_cyc_i,
						m6_cyc_i,
						m5_cyc_i,
						m4_cyc_i,
						m3_cyc_i,
						m2_cyc_i,
						m1_cyc_i,
						m0_cyc_i}),
				      .gnt(gnt)
				      );

   //////////////////////////////////
   // 		address decode logic
   //
   wire [7:0] m0_ssel_dec, m1_ssel_dec, m2_ssel_dec, m3_ssel_dec, m4_ssel_dec, m5_ssel_dec, m6_ssel_dec, m7_ssel_dec ;
   always @(gnt, m0_ssel_dec, m1_ssel_dec, m2_ssel_dec, m3_ssel_dec, m4_ssel_dec, m5_ssel_dec, m6_ssel_dec, m7_ssel_dec)
     case(gnt)
       3'h0: i_ssel_dec = m0_ssel_dec;
       3'h1: i_ssel_dec = m1_ssel_dec;
       3'h2: i_ssel_dec = m2_ssel_dec;
       3'h3: i_ssel_dec = m3_ssel_dec;
       3'h4: i_ssel_dec = m4_ssel_dec;
       3'h5: i_ssel_dec = m5_ssel_dec;
       3'h6: i_ssel_dec = m6_ssel_dec;
       3'h7: i_ssel_dec = m7_ssel_dec;
       default: i_ssel_dec = 7'b0;
     endcase // case (gnt)

   // Generate error signals if address requested does not exist
   //wire [7:0] 		addr_err;
   // This goes high when we've granted bus to this master, but its addresss does not select
   // any valid master, and it's requesting the bus.
   assign addr_err[0] = ((gnt == 3'h0) & !(|m0_ssel_dec) & m0_cyc_i);
   assign addr_err[1] = ((gnt == 3'h1) & !(|m1_ssel_dec) & m1_cyc_i);
   assign addr_err[2] = ((gnt == 3'h2) & !(|m2_ssel_dec) & m2_cyc_i);
   assign addr_err[3] = ((gnt == 3'h3) & !(|m3_ssel_dec) & m3_cyc_i);
   assign addr_err[4] = ((gnt == 3'h4) & !(|m4_ssel_dec) & m4_cyc_i);
   assign addr_err[5] = ((gnt == 3'h5) & !(|m5_ssel_dec) & m5_cyc_i);
   assign addr_err[6] = ((gnt == 3'h6) & !(|m6_ssel_dec) & m6_cyc_i);
   assign addr_err[7] = ((gnt == 3'h7) & !(|m7_ssel_dec) & m7_cyc_i);

   always @(posedge clk_i)
     begin
	addr_err_r <= addr_err[gnt];
     end

   assign addr_err_out = addr_err_r & i_bus_m[1]; // AND it with the CYC input of the master also
   
   
   
   
   
   //
   //	decode all master address before arbitor for running faster
   //	
   assign m0_ssel_dec[0] = (m0_adr_i[`aw -1 : `aw - s0_addr_w ] == s0_addr);
   assign m0_ssel_dec[1] = (m0_adr_i[`aw -1 : `aw - s1_addr_w ] == s1_addr);
   assign m0_ssel_dec[2] = (m0_adr_i[`aw -1 : `aw - s27_addr_w ] == s2_addr);
   assign m0_ssel_dec[3] = (m0_adr_i[`aw -1 : `aw - s27_addr_w ] == s3_addr);
   assign m0_ssel_dec[4] = (m0_adr_i[`aw -1 : `aw - s27_addr_w ] == s4_addr);
   assign m0_ssel_dec[5] = (m0_adr_i[`aw -1 : `aw - s27_addr_w ] == s5_addr);
   assign m0_ssel_dec[6] = (m0_adr_i[`aw -1 : `aw - s27_addr_w ] == s6_addr);
   assign m0_ssel_dec[7] = (m0_adr_i[`aw -1 : `aw - s27_addr_w ] == s7_addr);

   assign m1_ssel_dec[0] = (m1_adr_i[`aw -1 : `aw - s0_addr_w ] == s0_addr);
   assign m1_ssel_dec[1] = (m1_adr_i[`aw -1 : `aw - s1_addr_w ] == s1_addr);
   assign m1_ssel_dec[2] = (m1_adr_i[`aw -1 : `aw - s27_addr_w ] == s2_addr);
   assign m1_ssel_dec[3] = (m1_adr_i[`aw -1 : `aw - s27_addr_w ] == s3_addr);
   assign m1_ssel_dec[4] = (m1_adr_i[`aw -1 : `aw - s27_addr_w ] == s4_addr);
   assign m1_ssel_dec[5] = (m1_adr_i[`aw -1 : `aw - s27_addr_w ] == s5_addr);
   assign m1_ssel_dec[6] = (m1_adr_i[`aw -1 : `aw - s27_addr_w ] == s6_addr);
   assign m1_ssel_dec[7] = (m1_adr_i[`aw -1 : `aw - s27_addr_w ] == s7_addr);

   assign m2_ssel_dec[0] = (m2_adr_i[`aw -1 : `aw - s0_addr_w ] == s0_addr);
   assign m2_ssel_dec[1] = (m2_adr_i[`aw -1 : `aw - s1_addr_w ] == s1_addr);
   assign m2_ssel_dec[2] = (m2_adr_i[`aw -1 : `aw - s27_addr_w ] == s2_addr);
   assign m2_ssel_dec[3] = (m2_adr_i[`aw -1 : `aw - s27_addr_w ] == s3_addr);
   assign m2_ssel_dec[4] = (m2_adr_i[`aw -1 : `aw - s27_addr_w ] == s4_addr);
   assign m2_ssel_dec[5] = (m2_adr_i[`aw -1 : `aw - s27_addr_w ] == s5_addr);
   assign m2_ssel_dec[6] = (m2_adr_i[`aw -1 : `aw - s27_addr_w ] == s6_addr);
   assign m2_ssel_dec[7] = (m2_adr_i[`aw -1 : `aw - s27_addr_w ] == s7_addr);

   assign m3_ssel_dec[0] = (m3_adr_i[`aw -1 : `aw - s0_addr_w ] == s0_addr);
   assign m3_ssel_dec[1] = (m3_adr_i[`aw -1 : `aw - s1_addr_w ] == s1_addr);
   assign m3_ssel_dec[2] = (m3_adr_i[`aw -1 : `aw - s27_addr_w ] == s2_addr);
   assign m3_ssel_dec[3] = (m3_adr_i[`aw -1 : `aw - s27_addr_w ] == s3_addr);
   assign m3_ssel_dec[4] = (m3_adr_i[`aw -1 : `aw - s27_addr_w ] == s4_addr);
   assign m3_ssel_dec[5] = (m3_adr_i[`aw -1 : `aw - s27_addr_w ] == s5_addr);
   assign m3_ssel_dec[6] = (m3_adr_i[`aw -1 : `aw - s27_addr_w ] == s6_addr);
   assign m3_ssel_dec[7] = (m3_adr_i[`aw -1 : `aw - s27_addr_w ] == s7_addr);

   assign m4_ssel_dec[0] = (m4_adr_i[`aw -1 : `aw - s0_addr_w ] == s0_addr);
   assign m4_ssel_dec[1] = (m4_adr_i[`aw -1 : `aw - s1_addr_w ] == s1_addr);
   assign m4_ssel_dec[2] = (m4_adr_i[`aw -1 : `aw - s27_addr_w ] == s2_addr);
   assign m4_ssel_dec[3] = (m4_adr_i[`aw -1 : `aw - s27_addr_w ] == s3_addr);
   assign m4_ssel_dec[4] = (m4_adr_i[`aw -1 : `aw - s27_addr_w ] == s4_addr);
   assign m4_ssel_dec[5] = (m4_adr_i[`aw -1 : `aw - s27_addr_w ] == s5_addr);
   assign m4_ssel_dec[6] = (m4_adr_i[`aw -1 : `aw - s27_addr_w ] == s6_addr);
   assign m4_ssel_dec[7] = (m4_adr_i[`aw -1 : `aw - s27_addr_w ] == s7_addr);

   assign m5_ssel_dec[0] = (m5_adr_i[`aw -1 : `aw - s0_addr_w ] == s0_addr);
   assign m5_ssel_dec[1] = (m5_adr_i[`aw -1 : `aw - s1_addr_w ] == s1_addr);
   assign m5_ssel_dec[2] = (m5_adr_i[`aw -1 : `aw - s27_addr_w ] == s2_addr);
   assign m5_ssel_dec[3] = (m5_adr_i[`aw -1 : `aw - s27_addr_w ] == s3_addr);
   assign m5_ssel_dec[4] = (m5_adr_i[`aw -1 : `aw - s27_addr_w ] == s4_addr);
   assign m5_ssel_dec[5] = (m5_adr_i[`aw -1 : `aw - s27_addr_w ] == s5_addr);
   assign m5_ssel_dec[6] = (m5_adr_i[`aw -1 : `aw - s27_addr_w ] == s6_addr);
   assign m5_ssel_dec[7] = (m5_adr_i[`aw -1 : `aw - s27_addr_w ] == s7_addr);

   assign m6_ssel_dec[0] = (m6_adr_i[`aw -1 : `aw - s0_addr_w ] == s0_addr);
   assign m6_ssel_dec[1] = (m6_adr_i[`aw -1 : `aw - s1_addr_w ] == s1_addr);
   assign m6_ssel_dec[2] = (m6_adr_i[`aw -1 : `aw - s27_addr_w ] == s2_addr);
   assign m6_ssel_dec[3] = (m6_adr_i[`aw -1 : `aw - s27_addr_w ] == s3_addr);
   assign m6_ssel_dec[4] = (m6_adr_i[`aw -1 : `aw - s27_addr_w ] == s4_addr);
   assign m6_ssel_dec[5] = (m6_adr_i[`aw -1 : `aw - s27_addr_w ] == s5_addr);
   assign m6_ssel_dec[6] = (m6_adr_i[`aw -1 : `aw - s27_addr_w ] == s6_addr);
   assign m6_ssel_dec[7] = (m6_adr_i[`aw -1 : `aw - s27_addr_w ] == s7_addr);

   assign m7_ssel_dec[0] = (m7_adr_i[`aw -1 : `aw - s0_addr_w ] == s0_addr);
   assign m7_ssel_dec[1] = (m7_adr_i[`aw -1 : `aw - s1_addr_w ] == s1_addr);
   assign m7_ssel_dec[2] = (m7_adr_i[`aw -1 : `aw - s27_addr_w ] == s2_addr);
   assign m7_ssel_dec[3] = (m7_adr_i[`aw -1 : `aw - s27_addr_w ] == s3_addr);
   assign m7_ssel_dec[4] = (m7_adr_i[`aw -1 : `aw - s27_addr_w ] == s4_addr);
   assign m7_ssel_dec[5] = (m7_adr_i[`aw -1 : `aw - s27_addr_w ] == s5_addr);
   assign m7_ssel_dec[6] = (m7_adr_i[`aw -1 : `aw - s27_addr_w ] == s6_addr);
   assign m7_ssel_dec[7] = (m7_adr_i[`aw -1 : `aw - s27_addr_w ] == s7_addr);

   //assign i_ssel_dec[0] = (i_bus_m[`mbusw -1 : `mbusw - s0_addr_w ] == s0_addr);
   //assign i_ssel_dec[1] = (i_bus_m[`mbusw -1 : `mbusw - s1_addr_w ] == s1_addr);
   //assign i_ssel_dec[2] = (i_bus_m[`mbusw -1 : `mbusw - s27_addr_w ] == s2_addr);
   //assign i_ssel_dec[3] = (i_bus_m[`mbusw -1 : `mbusw - s27_addr_w ] == s3_addr);
   //assign i_ssel_dec[4] = (i_bus_m[`mbusw -1 : `mbusw - s27_addr_w ] == s4_addr);
   //assign i_ssel_dec[5] = (i_bus_m[`mbusw -1 : `mbusw - s27_addr_w ] == s5_addr);
   //assign i_ssel_dec[6] = (i_bus_m[`mbusw -1 : `mbusw - s27_addr_w ] == s6_addr);
   //assign i_ssel_dec[7] = (i_bus_m[`mbusw -1 : `mbusw - s27_addr_w ] == s7_addr);


`ifdef verilator
   // Access functions for verilator,  hardcoded to dw=32, aw=32

   // Master Signal Access functions
   
   wire [`dw-1:0] 		m_dat_i[0:`mselectw-1] /* verilator public */;
   assign m_dat_i[0] = m0_dat_i;
   assign m_dat_i[1] = m1_dat_i;
   assign m_dat_i[2] = m2_dat_i;
   assign m_dat_i[3] = m3_dat_i;
   assign m_dat_i[4] = m4_dat_i;
   assign m_dat_i[5] = m5_dat_i;
   assign m_dat_i[6] = m6_dat_i;
   assign m_dat_i[7] = m7_dat_i;
   
   wire [`dw-1:0] 		m_dat_o[0:`mselectw-1]/* verilator public */;
   assign m_dat_o[0] = m0_dat_o;
   assign m_dat_o[1] = m1_dat_o;
   assign m_dat_o[2] = m2_dat_o;
   assign m_dat_o[3] = m3_dat_o;
   assign m_dat_o[4] = m4_dat_o;
   assign m_dat_o[5] = m5_dat_o;
   assign m_dat_o[6] = m6_dat_o;
   assign m_dat_o[7] = m7_dat_o;
   
   
   wire [`aw-1:0] 	m_adr_i[0:`mselectw-1]/* verilator public */;
   assign m_adr_i[0] = m0_adr_i;
   assign m_adr_i[1] = m1_adr_i;
   assign m_adr_i[2] = m2_adr_i;
   assign m_adr_i[3] = m3_adr_i;
   assign m_adr_i[4] = m4_adr_i;
   assign m_adr_i[5] = m5_adr_i;
   assign m_adr_i[6] = m6_adr_i;
   assign m_adr_i[7] = m7_adr_i;
   
   wire [`sw-1:0] 	m_sel_i[0:`mselectw-1]/* verilator public */;
   assign m_sel_i[0] = m0_sel_i;
   assign m_sel_i[1] = m1_sel_i;
   assign m_sel_i[2] = m2_sel_i;
   assign m_sel_i[3] = m3_sel_i;
   assign m_sel_i[4] = m4_sel_i;
   assign m_sel_i[5] = m5_sel_i;
   assign m_sel_i[6] = m6_sel_i;
   assign m_sel_i[7] = m7_sel_i;
   
   wire [`mselectw-1:0] 		m_we_i/* verilator public */;
   assign m_we_i[0] = m0_we_i;
   assign m_we_i[1] = m1_we_i;
   assign m_we_i[2] = m2_we_i;
   assign m_we_i[3] = m3_we_i;
   assign m_we_i[4] = m4_we_i;
   assign m_we_i[5] = m5_we_i;
   assign m_we_i[6] = m6_we_i;
   assign m_we_i[7] = m7_we_i;
   
   wire [`mselectw-1:0]	m_cyc_i/* verilator public */;
   assign m_cyc_i[0] = m0_cyc_i;
   assign m_cyc_i[1] = m1_cyc_i;
   assign m_cyc_i[2] = m2_cyc_i;
   assign m_cyc_i[3] = m3_cyc_i;
   assign m_cyc_i[4] = m4_cyc_i;
   assign m_cyc_i[5] = m5_cyc_i;
   assign m_cyc_i[6] = m6_cyc_i;
   assign m_cyc_i[7] = m7_cyc_i;
   
   wire [`mselectw-1:0] 	m_stb_i/* verilator public */;
   assign m_stb_i[0] = m0_stb_i;
   assign m_stb_i[1] = m1_stb_i;
   assign m_stb_i[2] = m2_stb_i;
   assign m_stb_i[3] = m3_stb_i;
   assign m_stb_i[4] = m4_stb_i;
   assign m_stb_i[5] = m5_stb_i;
   assign m_stb_i[6] = m6_stb_i;
   assign m_stb_i[7] = m7_stb_i;
   
   wire [`mselectw-1:0] 	m_ack_o/* verilator public */;
   assign m_ack_o[0] = m0_ack_o;
   assign m_ack_o[1] = m1_ack_o;
   assign m_ack_o[2] = m2_ack_o;
   assign m_ack_o[3] = m3_ack_o;
   assign m_ack_o[4] = m4_ack_o;
   assign m_ack_o[5] = m5_ack_o;
   assign m_ack_o[6] = m6_ack_o;
   assign m_ack_o[7] = m7_ack_o;
   
   wire [`mselectw-1:0] m_err_o/* verilator public */;
   assign m_err_o[0] = m0_err_o;
   assign m_err_o[1] = m1_err_o;
   assign m_err_o[2] = m2_err_o;
   assign m_err_o[3] = m3_err_o;
   assign m_err_o[4] = m4_err_o;
   assign m_err_o[5] = m5_err_o;
   assign m_err_o[6] = m6_err_o;
   assign m_err_o[7] = m7_err_o;

   wire [7:0] 	       m_ssel_dec [0:7]/* verilator public*/;
   assign m_ssel_dec[0] = m0_ssel_dec;
   assign m_ssel_dec[1] = m1_ssel_dec;
   assign m_ssel_dec[2] = m2_ssel_dec;
   assign m_ssel_dec[3] = m3_ssel_dec;
   assign m_ssel_dec[4] = m4_ssel_dec;
   assign m_ssel_dec[5] = m5_ssel_dec;
   assign m_ssel_dec[6] = m6_ssel_dec;
   assign m_ssel_dec[7] = m7_ssel_dec;

   // Arbiter's grant signal
   function [2:0] get_gnt;
      // verilator public
      get_gnt = gnt;
   endfunction

   function [31:0] get_m_dat_i;
      // verilator public
      input [2:0] 		mast_no;
      get_m_dat_i = m_dat_i[mast_no];
   endfunction // get_m_dat_i   
   function [31:0] get_m_dat_o;
      // verilator public
      input [2:0] 		mast_no;
      get_m_dat_o = m_dat_o[mast_no];
   endfunction // get_m_dat_o   
   function [31:0] get_m_adr_i;
      // verilator public
      input [2:0] 		mast_no;
      get_m_adr_i = m_adr_i[mast_no];
   endfunction // get_m_adr_i   
   function [3:0] get_m_sel_i;
      // verilator public
      input [2:0] 		mast_no;
      get_m_sel_i = m_sel_i[mast_no];
   endfunction // get_m_sel_i
   function get_m_we_i;
      // verilator public
      input [2:0] 		mast_no;
      get_m_we_i = m_we_i[mast_no];
   endfunction // get_m_we_i
   function get_m_cyc_i;
      // verilator public
      input [2:0] 		mast_no;
      get_m_cyc_i = m_cyc_i[mast_no];
   endfunction // get_m_cyc_i
   function get_m_stb_i;
      // verilator public
      input [2:0] 		mast_no;
      get_m_stb_i = m_stb_i[mast_no];
   endfunction // get_m_stb_i
   function get_m_ack_o;
      // verilator public
      input [2:0] 		mast_no;
      get_m_ack_o = m_ack_o[mast_no];
   endfunction // get_m_ack_o
   function get_m_err_o;
      // verilator public
      input [2:0] 		mast_no;
      get_m_err_o = m_err_o[mast_no];
   endfunction // get_m_err_o
   
   // Decoded slave for each master's access
   function [7:0] get_m_ssel_dec;
      // verilator public
      input [2:0] 		mast_no;
      get_m_ssel_dec = m_ssel_dec[mast_no];
   endfunction
   
   `endif   
endmodule