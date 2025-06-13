// Copyright (C) 2020  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details, at
// https://fpgasoftware.intel.com/eula.

// VENDOR "Altera"
// PROGRAM "Quartus Prime"
// VERSION "Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition"

// DATE "05/26/2025 18:58:56"

// 
// Device: Altera 10M50DAF484C7G Package FBGA484
// 

// 
// This greybox netlist file is for third party Synthesis Tools
// for timing and resource estimation only.
// 


module fir_compiler_ii (
	ast_sink_data,
	ast_sink_valid,
	ast_sink_error,
	ast_source_data,
	ast_source_valid,
	ast_source_error,
	clk,
	reset_n)/* synthesis synthesis_greybox=0 */;
input 	[7:0] ast_sink_data;
input 	ast_sink_valid;
input 	[1:0] ast_sink_error;
output 	[21:0] ast_source_data;
output 	ast_source_valid;
output 	[1:0] ast_source_error;
input 	clk;
input 	reset_n;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;

wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[0]~q ;
wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[1]~q ;
wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[2]~q ;
wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[3]~q ;
wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[4]~q ;
wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[5]~q ;
wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[6]~q ;
wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[7]~q ;
wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[8]~q ;
wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[9]~q ;
wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[10]~q ;
wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[11]~q ;
wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[12]~q ;
wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[13]~q ;
wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[14]~q ;
wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[15]~q ;
wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[16]~q ;
wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[17]~q ;
wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[18]~q ;
wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[19]~q ;
wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[20]~q ;
wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[21]~q ;
wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_valid~q ;
wire \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|at_source_error_s[0]~q ;
wire \ast_sink_error[1]~input_o ;
wire \clk~input_o ;
wire \reset_n~input_o ;
wire \ast_sink_valid~input_o ;
wire \ast_sink_error[0]~input_o ;
wire \ast_sink_data[0]~input_o ;
wire \ast_sink_data[1]~input_o ;
wire \ast_sink_data[2]~input_o ;
wire \ast_sink_data[3]~input_o ;
wire \ast_sink_data[4]~input_o ;
wire \ast_sink_data[5]~input_o ;
wire \ast_sink_data[6]~input_o ;
wire \ast_sink_data[7]~input_o ;


fir_compiler_ii_fir_compiler_ii_fir_compiler_ii_0 fir_compiler_ii_0(
	.data_out_0(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[0]~q ),
	.data_out_1(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[1]~q ),
	.data_out_2(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[2]~q ),
	.data_out_3(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[3]~q ),
	.data_out_4(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[4]~q ),
	.data_out_5(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[5]~q ),
	.data_out_6(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[6]~q ),
	.data_out_7(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[7]~q ),
	.data_out_8(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[8]~q ),
	.data_out_9(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[9]~q ),
	.data_out_10(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[10]~q ),
	.data_out_11(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[11]~q ),
	.data_out_12(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[12]~q ),
	.data_out_13(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[13]~q ),
	.data_out_14(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[14]~q ),
	.data_out_15(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[15]~q ),
	.data_out_16(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[16]~q ),
	.data_out_17(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[17]~q ),
	.data_out_18(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[18]~q ),
	.data_out_19(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[19]~q ),
	.data_out_20(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[20]~q ),
	.data_out_21(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[21]~q ),
	.data_valid(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_valid~q ),
	.at_source_error_s_0(\fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|at_source_error_s[0]~q ),
	.clk(\clk~input_o ),
	.reset_n(\reset_n~input_o ),
	.ast_sink_valid(\ast_sink_valid~input_o ),
	.ast_sink_error_0(\ast_sink_error[0]~input_o ),
	.ast_sink_data_0(\ast_sink_data[0]~input_o ),
	.ast_sink_data_1(\ast_sink_data[1]~input_o ),
	.ast_sink_data_2(\ast_sink_data[2]~input_o ),
	.ast_sink_data_3(\ast_sink_data[3]~input_o ),
	.ast_sink_data_4(\ast_sink_data[4]~input_o ),
	.ast_sink_data_5(\ast_sink_data[5]~input_o ),
	.ast_sink_data_6(\ast_sink_data[6]~input_o ),
	.ast_sink_data_7(\ast_sink_data[7]~input_o ));

assign \clk~input_o  = clk;

assign \reset_n~input_o  = reset_n;

assign \ast_sink_valid~input_o  = ast_sink_valid;

assign \ast_sink_error[0]~input_o  = ast_sink_error[0];

assign \ast_sink_data[0]~input_o  = ast_sink_data[0];

assign \ast_sink_data[1]~input_o  = ast_sink_data[1];

assign \ast_sink_data[2]~input_o  = ast_sink_data[2];

assign \ast_sink_data[3]~input_o  = ast_sink_data[3];

assign \ast_sink_data[4]~input_o  = ast_sink_data[4];

assign \ast_sink_data[5]~input_o  = ast_sink_data[5];

assign \ast_sink_data[6]~input_o  = ast_sink_data[6];

assign \ast_sink_data[7]~input_o  = ast_sink_data[7];

assign ast_source_data[0] = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[0]~q ;

assign ast_source_data[1] = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[1]~q ;

assign ast_source_data[2] = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[2]~q ;

assign ast_source_data[3] = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[3]~q ;

assign ast_source_data[4] = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[4]~q ;

assign ast_source_data[5] = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[5]~q ;

assign ast_source_data[6] = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[6]~q ;

assign ast_source_data[7] = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[7]~q ;

assign ast_source_data[8] = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[8]~q ;

assign ast_source_data[9] = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[9]~q ;

assign ast_source_data[10] = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[10]~q ;

assign ast_source_data[11] = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[11]~q ;

assign ast_source_data[12] = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[12]~q ;

assign ast_source_data[13] = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[13]~q ;

assign ast_source_data[14] = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[14]~q ;

assign ast_source_data[15] = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[15]~q ;

assign ast_source_data[16] = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[16]~q ;

assign ast_source_data[17] = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[17]~q ;

assign ast_source_data[18] = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[18]~q ;

assign ast_source_data[19] = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[19]~q ;

assign ast_source_data[20] = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[20]~q ;

assign ast_source_data[21] = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_out[21]~q ;

assign ast_source_valid = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|data_valid~q ;

assign ast_source_error[0] = \fir_compiler_ii_0|fir_compiler_ii_fir_compiler_ii_0_ast_inst|source|at_source_error_s[0]~q ;

assign ast_source_error[1] = gnd;

assign \ast_sink_error[1]~input_o  = ast_sink_error[1];

endmodule

module fir_compiler_ii_fir_compiler_ii_fir_compiler_ii_0 (
	data_out_0,
	data_out_1,
	data_out_2,
	data_out_3,
	data_out_4,
	data_out_5,
	data_out_6,
	data_out_7,
	data_out_8,
	data_out_9,
	data_out_10,
	data_out_11,
	data_out_12,
	data_out_13,
	data_out_14,
	data_out_15,
	data_out_16,
	data_out_17,
	data_out_18,
	data_out_19,
	data_out_20,
	data_out_21,
	data_valid,
	at_source_error_s_0,
	clk,
	reset_n,
	ast_sink_valid,
	ast_sink_error_0,
	ast_sink_data_0,
	ast_sink_data_1,
	ast_sink_data_2,
	ast_sink_data_3,
	ast_sink_data_4,
	ast_sink_data_5,
	ast_sink_data_6,
	ast_sink_data_7)/* synthesis synthesis_greybox=0 */;
output 	data_out_0;
output 	data_out_1;
output 	data_out_2;
output 	data_out_3;
output 	data_out_4;
output 	data_out_5;
output 	data_out_6;
output 	data_out_7;
output 	data_out_8;
output 	data_out_9;
output 	data_out_10;
output 	data_out_11;
output 	data_out_12;
output 	data_out_13;
output 	data_out_14;
output 	data_out_15;
output 	data_out_16;
output 	data_out_17;
output 	data_out_18;
output 	data_out_19;
output 	data_out_20;
output 	data_out_21;
output 	data_valid;
output 	at_source_error_s_0;
input 	clk;
input 	reset_n;
input 	ast_sink_valid;
input 	ast_sink_error_0;
input 	ast_sink_data_0;
input 	ast_sink_data_1;
input 	ast_sink_data_2;
input 	ast_sink_data_3;
input 	ast_sink_data_4;
input 	ast_sink_data_5;
input 	ast_sink_data_6;
input 	ast_sink_data_7;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;



fir_compiler_ii_fir_compiler_ii_fir_compiler_ii_0_ast fir_compiler_ii_fir_compiler_ii_0_ast_inst(
	.data_out_0(data_out_0),
	.data_out_1(data_out_1),
	.data_out_2(data_out_2),
	.data_out_3(data_out_3),
	.data_out_4(data_out_4),
	.data_out_5(data_out_5),
	.data_out_6(data_out_6),
	.data_out_7(data_out_7),
	.data_out_8(data_out_8),
	.data_out_9(data_out_9),
	.data_out_10(data_out_10),
	.data_out_11(data_out_11),
	.data_out_12(data_out_12),
	.data_out_13(data_out_13),
	.data_out_14(data_out_14),
	.data_out_15(data_out_15),
	.data_out_16(data_out_16),
	.data_out_17(data_out_17),
	.data_out_18(data_out_18),
	.data_out_19(data_out_19),
	.data_out_20(data_out_20),
	.data_out_21(data_out_21),
	.data_valid(data_valid),
	.at_source_error_s_0(at_source_error_s_0),
	.clk(clk),
	.reset_n(reset_n),
	.ast_sink_valid(ast_sink_valid),
	.ast_sink_error_0(ast_sink_error_0),
	.ast_sink_data_0(ast_sink_data_0),
	.ast_sink_data_1(ast_sink_data_1),
	.ast_sink_data_2(ast_sink_data_2),
	.ast_sink_data_3(ast_sink_data_3),
	.ast_sink_data_4(ast_sink_data_4),
	.ast_sink_data_5(ast_sink_data_5),
	.ast_sink_data_6(ast_sink_data_6),
	.ast_sink_data_7(ast_sink_data_7));

endmodule

module fir_compiler_ii_fir_compiler_ii_fir_compiler_ii_0_ast (
	data_out_0,
	data_out_1,
	data_out_2,
	data_out_3,
	data_out_4,
	data_out_5,
	data_out_6,
	data_out_7,
	data_out_8,
	data_out_9,
	data_out_10,
	data_out_11,
	data_out_12,
	data_out_13,
	data_out_14,
	data_out_15,
	data_out_16,
	data_out_17,
	data_out_18,
	data_out_19,
	data_out_20,
	data_out_21,
	data_valid,
	at_source_error_s_0,
	clk,
	reset_n,
	ast_sink_valid,
	ast_sink_error_0,
	ast_sink_data_0,
	ast_sink_data_1,
	ast_sink_data_2,
	ast_sink_data_3,
	ast_sink_data_4,
	ast_sink_data_5,
	ast_sink_data_6,
	ast_sink_data_7)/* synthesis synthesis_greybox=0 */;
output 	data_out_0;
output 	data_out_1;
output 	data_out_2;
output 	data_out_3;
output 	data_out_4;
output 	data_out_5;
output 	data_out_6;
output 	data_out_7;
output 	data_out_8;
output 	data_out_9;
output 	data_out_10;
output 	data_out_11;
output 	data_out_12;
output 	data_out_13;
output 	data_out_14;
output 	data_out_15;
output 	data_out_16;
output 	data_out_17;
output 	data_out_18;
output 	data_out_19;
output 	data_out_20;
output 	data_out_21;
output 	data_valid;
output 	at_source_error_s_0;
input 	clk;
input 	reset_n;
input 	ast_sink_valid;
input 	ast_sink_error_0;
input 	ast_sink_data_0;
input 	ast_sink_data_1;
input 	ast_sink_data_2;
input 	ast_sink_data_3;
input 	ast_sink_data_4;
input 	ast_sink_data_5;
input 	ast_sink_data_6;
input 	ast_sink_data_7;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;

wire \real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[0]~q ;
wire \real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[1]~q ;
wire \real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[2]~q ;
wire \real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[3]~q ;
wire \real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[4]~q ;
wire \real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[5]~q ;
wire \real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[6]~q ;
wire \real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[7]~q ;
wire \real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[8]~q ;
wire \real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[9]~q ;
wire \real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[10]~q ;
wire \real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[11]~q ;
wire \real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[12]~q ;
wire \real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[13]~q ;
wire \real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[14]~q ;
wire \real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[15]~q ;
wire \real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[18]~q ;
wire \real_passthrough:hpfircore_core|u0_m0_wo0_oseq_gated_reg_q[0]~q ;
wire \sink|packet_error_s[0]~q ;


fir_compiler_ii_fir_compiler_ii_fir_compiler_ii_0_rtl_core \real_passthrough:hpfircore_core (
	.u0_m0_wo0_mtree_add2_4_o_0(\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[0]~q ),
	.u0_m0_wo0_mtree_add2_4_o_1(\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[1]~q ),
	.u0_m0_wo0_mtree_add2_4_o_2(\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[2]~q ),
	.u0_m0_wo0_mtree_add2_4_o_3(\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[3]~q ),
	.u0_m0_wo0_mtree_add2_4_o_4(\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[4]~q ),
	.u0_m0_wo0_mtree_add2_4_o_5(\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[5]~q ),
	.u0_m0_wo0_mtree_add2_4_o_6(\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[6]~q ),
	.u0_m0_wo0_mtree_add2_4_o_7(\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[7]~q ),
	.u0_m0_wo0_mtree_add2_4_o_8(\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[8]~q ),
	.u0_m0_wo0_mtree_add2_4_o_9(\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[9]~q ),
	.u0_m0_wo0_mtree_add2_4_o_10(\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[10]~q ),
	.u0_m0_wo0_mtree_add2_4_o_11(\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[11]~q ),
	.u0_m0_wo0_mtree_add2_4_o_12(\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[12]~q ),
	.u0_m0_wo0_mtree_add2_4_o_13(\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[13]~q ),
	.u0_m0_wo0_mtree_add2_4_o_14(\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[14]~q ),
	.u0_m0_wo0_mtree_add2_4_o_15(\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[15]~q ),
	.u0_m0_wo0_mtree_add2_4_o_18(\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[18]~q ),
	.u0_m0_wo0_oseq_gated_reg_q_0(\real_passthrough:hpfircore_core|u0_m0_wo0_oseq_gated_reg_q[0]~q ),
	.clk(clk),
	.areset(reset_n),
	.xIn_v({ast_sink_valid}),
	.xIn_0({ast_sink_data_7,ast_sink_data_6,ast_sink_data_5,ast_sink_data_4,ast_sink_data_3,ast_sink_data_2,ast_sink_data_1,ast_sink_data_0}));

fir_compiler_ii_auk_dspip_avalon_streaming_source_hpfir source(
	.data_in({\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[18]~q ,\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[18]~q ,\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[18]~q ,\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[18]~q ,
\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[18]~q ,\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[18]~q ,\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[15]~q ,\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[14]~q ,
\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[13]~q ,\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[12]~q ,\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[11]~q ,\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[10]~q ,
\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[9]~q ,\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[8]~q ,\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[7]~q ,\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[6]~q ,
\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[5]~q ,\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[4]~q ,\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[3]~q ,\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[2]~q ,
\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[1]~q ,\real_passthrough:hpfircore_core|u0_m0_wo0_mtree_add2_4_o[0]~q }),
	.data_out_0(data_out_0),
	.data_out_1(data_out_1),
	.data_out_2(data_out_2),
	.data_out_3(data_out_3),
	.data_out_4(data_out_4),
	.data_out_5(data_out_5),
	.data_out_6(data_out_6),
	.data_out_7(data_out_7),
	.data_out_8(data_out_8),
	.data_out_9(data_out_9),
	.data_out_10(data_out_10),
	.data_out_11(data_out_11),
	.data_out_12(data_out_12),
	.data_out_13(data_out_13),
	.data_out_14(data_out_14),
	.data_out_15(data_out_15),
	.data_out_16(data_out_16),
	.data_out_17(data_out_17),
	.data_out_18(data_out_18),
	.data_out_19(data_out_19),
	.data_out_20(data_out_20),
	.data_out_21(data_out_21),
	.data_valid1(data_valid),
	.at_source_error_s_0(at_source_error_s_0),
	.source_valid_ctrl(\real_passthrough:hpfircore_core|u0_m0_wo0_oseq_gated_reg_q[0]~q ),
	.packet_error({gnd,\sink|packet_error_s[0]~q }),
	.clk(clk),
	.reset_n(reset_n));

fir_compiler_ii_auk_dspip_avalon_streaming_sink_hpfir sink(
	.packet_error_s_0(\sink|packet_error_s[0]~q ),
	.clk(clk),
	.reset_n(reset_n),
	.ast_sink_valid(ast_sink_valid),
	.ast_sink_error_0(ast_sink_error_0));

endmodule

module fir_compiler_ii_auk_dspip_avalon_streaming_sink_hpfir (
	packet_error_s_0,
	clk,
	reset_n,
	ast_sink_valid,
	ast_sink_error_0)/* synthesis synthesis_greybox=0 */;
output 	packet_error_s_0;
input 	clk;
input 	reset_n;
input 	ast_sink_valid;
input 	ast_sink_error_0;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;

wire \at_sink_error_int~0_combout ;


dffeas \packet_error_s[0] (
	.clk(clk),
	.d(\at_sink_error_int~0_combout ),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(packet_error_s_0),
	.prn(vcc));
defparam \packet_error_s[0] .is_wysiwyg = "true";
defparam \packet_error_s[0] .power_up = "low";

fiftyfivenm_lcell_comb \at_sink_error_int~0 (
	.dataa(ast_sink_valid),
	.datab(ast_sink_error_0),
	.datac(gnd),
	.datad(gnd),
	.cin(gnd),
	.combout(\at_sink_error_int~0_combout ),
	.cout());
defparam \at_sink_error_int~0 .lut_mask = 16'h8888;
defparam \at_sink_error_int~0 .sum_lutc_input = "datac";

endmodule

module fir_compiler_ii_auk_dspip_avalon_streaming_source_hpfir (
	data_in,
	data_out_0,
	data_out_1,
	data_out_2,
	data_out_3,
	data_out_4,
	data_out_5,
	data_out_6,
	data_out_7,
	data_out_8,
	data_out_9,
	data_out_10,
	data_out_11,
	data_out_12,
	data_out_13,
	data_out_14,
	data_out_15,
	data_out_16,
	data_out_17,
	data_out_18,
	data_out_19,
	data_out_20,
	data_out_21,
	data_valid1,
	at_source_error_s_0,
	source_valid_ctrl,
	packet_error,
	clk,
	reset_n)/* synthesis synthesis_greybox=0 */;
input 	[21:0] data_in;
output 	data_out_0;
output 	data_out_1;
output 	data_out_2;
output 	data_out_3;
output 	data_out_4;
output 	data_out_5;
output 	data_out_6;
output 	data_out_7;
output 	data_out_8;
output 	data_out_9;
output 	data_out_10;
output 	data_out_11;
output 	data_out_12;
output 	data_out_13;
output 	data_out_14;
output 	data_out_15;
output 	data_out_16;
output 	data_out_17;
output 	data_out_18;
output 	data_out_19;
output 	data_out_20;
output 	data_out_21;
output 	data_valid1;
output 	at_source_error_s_0;
input 	source_valid_ctrl;
input 	[1:0] packet_error;
input 	clk;
input 	reset_n;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;



dffeas \data_out[0] (
	.clk(clk),
	.d(data_in[0]),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(data_out_0),
	.prn(vcc));
defparam \data_out[0] .is_wysiwyg = "true";
defparam \data_out[0] .power_up = "low";

dffeas \data_out[1] (
	.clk(clk),
	.d(data_in[1]),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(data_out_1),
	.prn(vcc));
defparam \data_out[1] .is_wysiwyg = "true";
defparam \data_out[1] .power_up = "low";

dffeas \data_out[2] (
	.clk(clk),
	.d(data_in[2]),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(data_out_2),
	.prn(vcc));
defparam \data_out[2] .is_wysiwyg = "true";
defparam \data_out[2] .power_up = "low";

dffeas \data_out[3] (
	.clk(clk),
	.d(data_in[3]),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(data_out_3),
	.prn(vcc));
defparam \data_out[3] .is_wysiwyg = "true";
defparam \data_out[3] .power_up = "low";

dffeas \data_out[4] (
	.clk(clk),
	.d(data_in[4]),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(data_out_4),
	.prn(vcc));
defparam \data_out[4] .is_wysiwyg = "true";
defparam \data_out[4] .power_up = "low";

dffeas \data_out[5] (
	.clk(clk),
	.d(data_in[5]),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(data_out_5),
	.prn(vcc));
defparam \data_out[5] .is_wysiwyg = "true";
defparam \data_out[5] .power_up = "low";

dffeas \data_out[6] (
	.clk(clk),
	.d(data_in[6]),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(data_out_6),
	.prn(vcc));
defparam \data_out[6] .is_wysiwyg = "true";
defparam \data_out[6] .power_up = "low";

dffeas \data_out[7] (
	.clk(clk),
	.d(data_in[7]),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(data_out_7),
	.prn(vcc));
defparam \data_out[7] .is_wysiwyg = "true";
defparam \data_out[7] .power_up = "low";

dffeas \data_out[8] (
	.clk(clk),
	.d(data_in[8]),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(data_out_8),
	.prn(vcc));
defparam \data_out[8] .is_wysiwyg = "true";
defparam \data_out[8] .power_up = "low";

dffeas \data_out[9] (
	.clk(clk),
	.d(data_in[9]),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(data_out_9),
	.prn(vcc));
defparam \data_out[9] .is_wysiwyg = "true";
defparam \data_out[9] .power_up = "low";

dffeas \data_out[10] (
	.clk(clk),
	.d(data_in[10]),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(data_out_10),
	.prn(vcc));
defparam \data_out[10] .is_wysiwyg = "true";
defparam \data_out[10] .power_up = "low";

dffeas \data_out[11] (
	.clk(clk),
	.d(data_in[11]),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(data_out_11),
	.prn(vcc));
defparam \data_out[11] .is_wysiwyg = "true";
defparam \data_out[11] .power_up = "low";

dffeas \data_out[12] (
	.clk(clk),
	.d(data_in[12]),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(data_out_12),
	.prn(vcc));
defparam \data_out[12] .is_wysiwyg = "true";
defparam \data_out[12] .power_up = "low";

dffeas \data_out[13] (
	.clk(clk),
	.d(data_in[13]),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(data_out_13),
	.prn(vcc));
defparam \data_out[13] .is_wysiwyg = "true";
defparam \data_out[13] .power_up = "low";

dffeas \data_out[14] (
	.clk(clk),
	.d(data_in[14]),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(data_out_14),
	.prn(vcc));
defparam \data_out[14] .is_wysiwyg = "true";
defparam \data_out[14] .power_up = "low";

dffeas \data_out[15] (
	.clk(clk),
	.d(data_in[15]),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(data_out_15),
	.prn(vcc));
defparam \data_out[15] .is_wysiwyg = "true";
defparam \data_out[15] .power_up = "low";

dffeas \data_out[16] (
	.clk(clk),
	.d(data_in[16]),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(data_out_16),
	.prn(vcc));
defparam \data_out[16] .is_wysiwyg = "true";
defparam \data_out[16] .power_up = "low";

dffeas \data_out[17] (
	.clk(clk),
	.d(data_in[16]),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(data_out_17),
	.prn(vcc));
defparam \data_out[17] .is_wysiwyg = "true";
defparam \data_out[17] .power_up = "low";

dffeas \data_out[18] (
	.clk(clk),
	.d(data_in[16]),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(data_out_18),
	.prn(vcc));
defparam \data_out[18] .is_wysiwyg = "true";
defparam \data_out[18] .power_up = "low";

dffeas \data_out[19] (
	.clk(clk),
	.d(data_in[16]),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(data_out_19),
	.prn(vcc));
defparam \data_out[19] .is_wysiwyg = "true";
defparam \data_out[19] .power_up = "low";

dffeas \data_out[20] (
	.clk(clk),
	.d(data_in[16]),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(data_out_20),
	.prn(vcc));
defparam \data_out[20] .is_wysiwyg = "true";
defparam \data_out[20] .power_up = "low";

dffeas \data_out[21] (
	.clk(clk),
	.d(data_in[16]),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(data_out_21),
	.prn(vcc));
defparam \data_out[21] .is_wysiwyg = "true";
defparam \data_out[21] .power_up = "low";

dffeas data_valid(
	.clk(clk),
	.d(source_valid_ctrl),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(data_valid1),
	.prn(vcc));
defparam data_valid.is_wysiwyg = "true";
defparam data_valid.power_up = "low";

dffeas \at_source_error_s[0] (
	.clk(clk),
	.d(packet_error[0]),
	.asdata(vcc),
	.clrn(reset_n),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(at_source_error_s_0),
	.prn(vcc));
defparam \at_source_error_s[0] .is_wysiwyg = "true";
defparam \at_source_error_s[0] .power_up = "low";

endmodule

module fir_compiler_ii_fir_compiler_ii_fir_compiler_ii_0_rtl_core (
	u0_m0_wo0_mtree_add2_4_o_0,
	u0_m0_wo0_mtree_add2_4_o_1,
	u0_m0_wo0_mtree_add2_4_o_2,
	u0_m0_wo0_mtree_add2_4_o_3,
	u0_m0_wo0_mtree_add2_4_o_4,
	u0_m0_wo0_mtree_add2_4_o_5,
	u0_m0_wo0_mtree_add2_4_o_6,
	u0_m0_wo0_mtree_add2_4_o_7,
	u0_m0_wo0_mtree_add2_4_o_8,
	u0_m0_wo0_mtree_add2_4_o_9,
	u0_m0_wo0_mtree_add2_4_o_10,
	u0_m0_wo0_mtree_add2_4_o_11,
	u0_m0_wo0_mtree_add2_4_o_12,
	u0_m0_wo0_mtree_add2_4_o_13,
	u0_m0_wo0_mtree_add2_4_o_14,
	u0_m0_wo0_mtree_add2_4_o_15,
	u0_m0_wo0_mtree_add2_4_o_18,
	u0_m0_wo0_oseq_gated_reg_q_0,
	clk,
	areset,
	xIn_v,
	xIn_0)/* synthesis synthesis_greybox=0 */;
output 	u0_m0_wo0_mtree_add2_4_o_0;
output 	u0_m0_wo0_mtree_add2_4_o_1;
output 	u0_m0_wo0_mtree_add2_4_o_2;
output 	u0_m0_wo0_mtree_add2_4_o_3;
output 	u0_m0_wo0_mtree_add2_4_o_4;
output 	u0_m0_wo0_mtree_add2_4_o_5;
output 	u0_m0_wo0_mtree_add2_4_o_6;
output 	u0_m0_wo0_mtree_add2_4_o_7;
output 	u0_m0_wo0_mtree_add2_4_o_8;
output 	u0_m0_wo0_mtree_add2_4_o_9;
output 	u0_m0_wo0_mtree_add2_4_o_10;
output 	u0_m0_wo0_mtree_add2_4_o_11;
output 	u0_m0_wo0_mtree_add2_4_o_12;
output 	u0_m0_wo0_mtree_add2_4_o_13;
output 	u0_m0_wo0_mtree_add2_4_o_14;
output 	u0_m0_wo0_mtree_add2_4_o_15;
output 	u0_m0_wo0_mtree_add2_4_o_18;
output 	u0_m0_wo0_oseq_gated_reg_q_0;
input 	clk;
input 	areset;
input 	[0:0] xIn_v;
input 	[7:0] xIn_0;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;

wire \d_u0_m0_wo0_compute_q_11|delay_signals[0][0]~q ;
wire \u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][0]~q ;
wire \u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][1]~q ;
wire \u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][2]~q ;
wire \u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][3]~q ;
wire \u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][4]~q ;
wire \u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][5]~q ;
wire \u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][6]~q ;
wire \u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][7]~q ;
wire \u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][0]~q ;
wire \u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][1]~q ;
wire \u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][2]~q ;
wire \u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][3]~q ;
wire \u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][4]~q ;
wire \u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][5]~q ;
wire \u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][6]~q ;
wire \u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][7]~q ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[0]~q ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[0]~q ;
wire \u0_m0_wo0_mtree_add2_4_o[0]~17_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[1]~q ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[1]~15_combout ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[1]~q ;
wire \u0_m0_wo0_mtree_add2_4_o[0]~18 ;
wire \u0_m0_wo0_mtree_add2_4_o[1]~19_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[2]~q ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[1]~16 ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[2]~17_combout ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[2]~q ;
wire \u0_m0_wo0_mtree_add2_4_o[1]~20 ;
wire \u0_m0_wo0_mtree_add2_4_o[2]~21_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[3]~q ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[2]~18 ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[3]~19_combout ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[3]~q ;
wire \u0_m0_wo0_mtree_add2_4_o[2]~22 ;
wire \u0_m0_wo0_mtree_add2_4_o[3]~23_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[4]~q ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[3]~20 ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[4]~21_combout ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[4]~q ;
wire \u0_m0_wo0_mtree_add2_4_o[3]~24 ;
wire \u0_m0_wo0_mtree_add2_4_o[4]~25_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[5]~q ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[4]~22 ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[5]~23_combout ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[5]~q ;
wire \u0_m0_wo0_mtree_add2_4_o[4]~26 ;
wire \u0_m0_wo0_mtree_add2_4_o[5]~27_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[6]~q ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[5]~24 ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[6]~25_combout ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[6]~q ;
wire \u0_m0_wo0_mtree_add2_4_o[5]~28 ;
wire \u0_m0_wo0_mtree_add2_4_o[6]~29_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[7]~9_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[7]~q ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[6]~26 ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[7]~27_combout ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[7]~q ;
wire \u0_m0_wo0_mtree_add2_4_o[6]~30 ;
wire \u0_m0_wo0_mtree_add2_4_o[7]~31_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[7]~10 ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[8]~11_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[8]~q ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[7]~28 ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[8]~29_combout ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[8]~q ;
wire \u0_m0_wo0_mtree_add2_4_o[7]~32 ;
wire \u0_m0_wo0_mtree_add2_4_o[8]~33_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[8]~12 ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[9]~13_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[9]~q ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[8]~30 ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[9]~31_combout ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[9]~q ;
wire \u0_m0_wo0_mtree_add2_4_o[8]~34 ;
wire \u0_m0_wo0_mtree_add2_4_o[9]~35_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[9]~14 ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[10]~15_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[10]~q ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[9]~32 ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[10]~33_combout ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[10]~q ;
wire \u0_m0_wo0_mtree_add2_4_o[9]~36 ;
wire \u0_m0_wo0_mtree_add2_4_o[10]~37_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[10]~16 ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[11]~17_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[11]~q ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[10]~34 ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[11]~35_combout ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[11]~q ;
wire \u0_m0_wo0_mtree_add2_4_o[10]~38 ;
wire \u0_m0_wo0_mtree_add2_4_o[11]~39_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[11]~18 ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[12]~19_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[12]~q ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[11]~36 ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[12]~37_combout ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[12]~q ;
wire \u0_m0_wo0_mtree_add2_4_o[11]~40 ;
wire \u0_m0_wo0_mtree_add2_4_o[12]~41_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[12]~20 ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[13]~21_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[13]~q ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[12]~38 ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[13]~39_combout ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[13]~q ;
wire \u0_m0_wo0_mtree_add2_4_o[12]~42 ;
wire \u0_m0_wo0_mtree_add2_4_o[13]~43_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[13]~22 ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[14]~23_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[14]~q ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[13]~40 ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[14]~41_combout ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[14]~q ;
wire \u0_m0_wo0_mtree_add2_4_o[13]~44 ;
wire \u0_m0_wo0_mtree_add2_4_o[14]~45_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[14]~24 ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[15]~25_combout ;
wire \u0_m0_wo0_mtree_mult1_34_sub_1_o[15]~q ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[14]~42 ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[15]~43_combout ;
wire \u0_m0_wo0_mtree_mult1_36_sub_1_o[15]~q ;
wire \u0_m0_wo0_mtree_add2_4_o[14]~46 ;
wire \u0_m0_wo0_mtree_add2_4_o[15]~47_combout ;
wire \u0_m0_wo0_mtree_add2_4_o[15]~48 ;
wire \u0_m0_wo0_mtree_add2_4_o[18]~49_combout ;


fir_compiler_ii_dspba_delay_2 u0_m0_wo0_wi0_r0_delayr2(
	.delay_signals_0_0(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][0]~q ),
	.delay_signals_1_0(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][1]~q ),
	.delay_signals_2_0(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][2]~q ),
	.delay_signals_3_0(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][3]~q ),
	.delay_signals_4_0(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][4]~q ),
	.delay_signals_5_0(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][5]~q ),
	.delay_signals_6_0(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][6]~q ),
	.delay_signals_7_0(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][7]~q ),
	.xin({\u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][7]~q ,\u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][6]~q ,\u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][5]~q ,\u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][4]~q ,\u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][3]~q ,
\u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][2]~q ,\u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][1]~q ,\u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][0]~q }),
	.clk(clk),
	.aclr(areset),
	.ena(xIn_v[0]));

fir_compiler_ii_dspba_delay_1 u0_m0_wo0_wi0_r0_delayr1(
	.delay_signals_0_0(\u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][0]~q ),
	.delay_signals_1_0(\u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][1]~q ),
	.delay_signals_2_0(\u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][2]~q ),
	.delay_signals_3_0(\u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][3]~q ),
	.delay_signals_4_0(\u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][4]~q ),
	.delay_signals_5_0(\u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][5]~q ),
	.delay_signals_6_0(\u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][6]~q ),
	.delay_signals_7_0(\u0_m0_wo0_wi0_r0_delayr1|delay_signals[0][7]~q ),
	.clk(clk),
	.aclr(areset),
	.ena(xIn_v[0]),
	.xin({xIn_0[7],xIn_0[6],xIn_0[5],xIn_0[4],xIn_0[3],xIn_0[2],xIn_0[1],xIn_0[0]}));

fir_compiler_ii_dspba_delay d_u0_m0_wo0_compute_q_11(
	.delay_signals_0_0(\d_u0_m0_wo0_compute_q_11|delay_signals[0][0]~q ),
	.clk(clk),
	.aclr(areset),
	.xin({gnd,gnd,gnd,gnd,gnd,gnd,gnd,xIn_v[0]}));

dffeas \u0_m0_wo0_mtree_add2_4_o[0] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_add2_4_o[0]~17_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(u0_m0_wo0_mtree_add2_4_o_0),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_add2_4_o[0] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_add2_4_o[0] .power_up = "low";

dffeas \u0_m0_wo0_mtree_add2_4_o[1] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_add2_4_o[1]~19_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(u0_m0_wo0_mtree_add2_4_o_1),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_add2_4_o[1] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_add2_4_o[1] .power_up = "low";

dffeas \u0_m0_wo0_mtree_add2_4_o[2] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_add2_4_o[2]~21_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(u0_m0_wo0_mtree_add2_4_o_2),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_add2_4_o[2] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_add2_4_o[2] .power_up = "low";

dffeas \u0_m0_wo0_mtree_add2_4_o[3] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_add2_4_o[3]~23_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(u0_m0_wo0_mtree_add2_4_o_3),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_add2_4_o[3] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_add2_4_o[3] .power_up = "low";

dffeas \u0_m0_wo0_mtree_add2_4_o[4] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_add2_4_o[4]~25_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(u0_m0_wo0_mtree_add2_4_o_4),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_add2_4_o[4] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_add2_4_o[4] .power_up = "low";

dffeas \u0_m0_wo0_mtree_add2_4_o[5] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_add2_4_o[5]~27_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(u0_m0_wo0_mtree_add2_4_o_5),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_add2_4_o[5] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_add2_4_o[5] .power_up = "low";

dffeas \u0_m0_wo0_mtree_add2_4_o[6] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_add2_4_o[6]~29_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(u0_m0_wo0_mtree_add2_4_o_6),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_add2_4_o[6] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_add2_4_o[6] .power_up = "low";

dffeas \u0_m0_wo0_mtree_add2_4_o[7] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_add2_4_o[7]~31_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(u0_m0_wo0_mtree_add2_4_o_7),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_add2_4_o[7] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_add2_4_o[7] .power_up = "low";

dffeas \u0_m0_wo0_mtree_add2_4_o[8] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_add2_4_o[8]~33_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(u0_m0_wo0_mtree_add2_4_o_8),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_add2_4_o[8] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_add2_4_o[8] .power_up = "low";

dffeas \u0_m0_wo0_mtree_add2_4_o[9] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_add2_4_o[9]~35_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(u0_m0_wo0_mtree_add2_4_o_9),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_add2_4_o[9] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_add2_4_o[9] .power_up = "low";

dffeas \u0_m0_wo0_mtree_add2_4_o[10] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_add2_4_o[10]~37_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(u0_m0_wo0_mtree_add2_4_o_10),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_add2_4_o[10] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_add2_4_o[10] .power_up = "low";

dffeas \u0_m0_wo0_mtree_add2_4_o[11] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_add2_4_o[11]~39_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(u0_m0_wo0_mtree_add2_4_o_11),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_add2_4_o[11] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_add2_4_o[11] .power_up = "low";

dffeas \u0_m0_wo0_mtree_add2_4_o[12] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_add2_4_o[12]~41_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(u0_m0_wo0_mtree_add2_4_o_12),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_add2_4_o[12] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_add2_4_o[12] .power_up = "low";

dffeas \u0_m0_wo0_mtree_add2_4_o[13] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_add2_4_o[13]~43_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(u0_m0_wo0_mtree_add2_4_o_13),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_add2_4_o[13] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_add2_4_o[13] .power_up = "low";

dffeas \u0_m0_wo0_mtree_add2_4_o[14] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_add2_4_o[14]~45_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(u0_m0_wo0_mtree_add2_4_o_14),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_add2_4_o[14] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_add2_4_o[14] .power_up = "low";

dffeas \u0_m0_wo0_mtree_add2_4_o[15] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_add2_4_o[15]~47_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(u0_m0_wo0_mtree_add2_4_o_15),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_add2_4_o[15] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_add2_4_o[15] .power_up = "low";

dffeas \u0_m0_wo0_mtree_add2_4_o[18] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_add2_4_o[18]~49_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(u0_m0_wo0_mtree_add2_4_o_18),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_add2_4_o[18] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_add2_4_o[18] .power_up = "low";

dffeas \u0_m0_wo0_oseq_gated_reg_q[0] (
	.clk(clk),
	.d(\d_u0_m0_wo0_compute_q_11|delay_signals[0][0]~q ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(u0_m0_wo0_oseq_gated_reg_q_0),
	.prn(vcc));
defparam \u0_m0_wo0_oseq_gated_reg_q[0] .is_wysiwyg = "true";
defparam \u0_m0_wo0_oseq_gated_reg_q[0] .power_up = "low";

dffeas \u0_m0_wo0_mtree_mult1_34_sub_1_o[0] (
	.clk(clk),
	.d(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][0]~q ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_34_sub_1_o[0]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[0] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[0] .power_up = "low";

dffeas \u0_m0_wo0_mtree_mult1_36_sub_1_o[0] (
	.clk(clk),
	.d(xIn_0[0]),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_36_sub_1_o[0]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[0] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[0] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_add2_4_o[0]~17 (
	.dataa(\u0_m0_wo0_mtree_mult1_34_sub_1_o[0]~q ),
	.datab(\u0_m0_wo0_mtree_mult1_36_sub_1_o[0]~q ),
	.datac(gnd),
	.datad(vcc),
	.cin(gnd),
	.combout(\u0_m0_wo0_mtree_add2_4_o[0]~17_combout ),
	.cout(\u0_m0_wo0_mtree_add2_4_o[0]~18 ));
defparam \u0_m0_wo0_mtree_add2_4_o[0]~17 .lut_mask = 16'h6688;
defparam \u0_m0_wo0_mtree_add2_4_o[0]~17 .sum_lutc_input = "datac";

dffeas \u0_m0_wo0_mtree_mult1_34_sub_1_o[1] (
	.clk(clk),
	.d(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][1]~q ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_34_sub_1_o[1]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[1] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[1] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_36_sub_1_o[1]~15 (
	.dataa(xIn_0[1]),
	.datab(xIn_0[0]),
	.datac(gnd),
	.datad(vcc),
	.cin(gnd),
	.combout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[1]~15_combout ),
	.cout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[1]~16 ));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[1]~15 .lut_mask = 16'h6611;
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[1]~15 .sum_lutc_input = "datac";

dffeas \u0_m0_wo0_mtree_mult1_36_sub_1_o[1] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_36_sub_1_o[1]~15_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_36_sub_1_o[1]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[1] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[1] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_add2_4_o[1]~19 (
	.dataa(\u0_m0_wo0_mtree_mult1_34_sub_1_o[1]~q ),
	.datab(\u0_m0_wo0_mtree_mult1_36_sub_1_o[1]~q ),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_add2_4_o[0]~18 ),
	.combout(\u0_m0_wo0_mtree_add2_4_o[1]~19_combout ),
	.cout(\u0_m0_wo0_mtree_add2_4_o[1]~20 ));
defparam \u0_m0_wo0_mtree_add2_4_o[1]~19 .lut_mask = 16'h9617;
defparam \u0_m0_wo0_mtree_add2_4_o[1]~19 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_34_sub_1_o[2] (
	.clk(clk),
	.d(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][2]~q ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_34_sub_1_o[2]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[2] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[2] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_36_sub_1_o[2]~17 (
	.dataa(xIn_0[2]),
	.datab(gnd),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_mult1_36_sub_1_o[1]~16 ),
	.combout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[2]~17_combout ),
	.cout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[2]~18 ));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[2]~17 .lut_mask = 16'hA5AF;
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[2]~17 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_36_sub_1_o[2] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_36_sub_1_o[2]~17_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_36_sub_1_o[2]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[2] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[2] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_add2_4_o[2]~21 (
	.dataa(\u0_m0_wo0_mtree_mult1_34_sub_1_o[2]~q ),
	.datab(\u0_m0_wo0_mtree_mult1_36_sub_1_o[2]~q ),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_add2_4_o[1]~20 ),
	.combout(\u0_m0_wo0_mtree_add2_4_o[2]~21_combout ),
	.cout(\u0_m0_wo0_mtree_add2_4_o[2]~22 ));
defparam \u0_m0_wo0_mtree_add2_4_o[2]~21 .lut_mask = 16'h698E;
defparam \u0_m0_wo0_mtree_add2_4_o[2]~21 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_34_sub_1_o[3] (
	.clk(clk),
	.d(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][3]~q ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_34_sub_1_o[3]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[3] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[3] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_36_sub_1_o[3]~19 (
	.dataa(xIn_0[3]),
	.datab(gnd),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_mult1_36_sub_1_o[2]~18 ),
	.combout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[3]~19_combout ),
	.cout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[3]~20 ));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[3]~19 .lut_mask = 16'h5A05;
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[3]~19 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_36_sub_1_o[3] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_36_sub_1_o[3]~19_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_36_sub_1_o[3]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[3] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[3] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_add2_4_o[3]~23 (
	.dataa(\u0_m0_wo0_mtree_mult1_34_sub_1_o[3]~q ),
	.datab(\u0_m0_wo0_mtree_mult1_36_sub_1_o[3]~q ),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_add2_4_o[2]~22 ),
	.combout(\u0_m0_wo0_mtree_add2_4_o[3]~23_combout ),
	.cout(\u0_m0_wo0_mtree_add2_4_o[3]~24 ));
defparam \u0_m0_wo0_mtree_add2_4_o[3]~23 .lut_mask = 16'h9617;
defparam \u0_m0_wo0_mtree_add2_4_o[3]~23 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_34_sub_1_o[4] (
	.clk(clk),
	.d(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][4]~q ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_34_sub_1_o[4]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[4] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[4] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_36_sub_1_o[4]~21 (
	.dataa(xIn_0[4]),
	.datab(gnd),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_mult1_36_sub_1_o[3]~20 ),
	.combout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[4]~21_combout ),
	.cout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[4]~22 ));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[4]~21 .lut_mask = 16'hA5AF;
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[4]~21 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_36_sub_1_o[4] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_36_sub_1_o[4]~21_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_36_sub_1_o[4]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[4] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[4] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_add2_4_o[4]~25 (
	.dataa(\u0_m0_wo0_mtree_mult1_34_sub_1_o[4]~q ),
	.datab(\u0_m0_wo0_mtree_mult1_36_sub_1_o[4]~q ),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_add2_4_o[3]~24 ),
	.combout(\u0_m0_wo0_mtree_add2_4_o[4]~25_combout ),
	.cout(\u0_m0_wo0_mtree_add2_4_o[4]~26 ));
defparam \u0_m0_wo0_mtree_add2_4_o[4]~25 .lut_mask = 16'h698E;
defparam \u0_m0_wo0_mtree_add2_4_o[4]~25 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_34_sub_1_o[5] (
	.clk(clk),
	.d(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][5]~q ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_34_sub_1_o[5]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[5] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[5] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_36_sub_1_o[5]~23 (
	.dataa(xIn_0[5]),
	.datab(gnd),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_mult1_36_sub_1_o[4]~22 ),
	.combout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[5]~23_combout ),
	.cout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[5]~24 ));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[5]~23 .lut_mask = 16'h5A05;
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[5]~23 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_36_sub_1_o[5] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_36_sub_1_o[5]~23_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_36_sub_1_o[5]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[5] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[5] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_add2_4_o[5]~27 (
	.dataa(\u0_m0_wo0_mtree_mult1_34_sub_1_o[5]~q ),
	.datab(\u0_m0_wo0_mtree_mult1_36_sub_1_o[5]~q ),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_add2_4_o[4]~26 ),
	.combout(\u0_m0_wo0_mtree_add2_4_o[5]~27_combout ),
	.cout(\u0_m0_wo0_mtree_add2_4_o[5]~28 ));
defparam \u0_m0_wo0_mtree_add2_4_o[5]~27 .lut_mask = 16'h9617;
defparam \u0_m0_wo0_mtree_add2_4_o[5]~27 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_34_sub_1_o[6] (
	.clk(clk),
	.d(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][6]~q ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_34_sub_1_o[6]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[6] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[6] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_36_sub_1_o[6]~25 (
	.dataa(xIn_0[6]),
	.datab(gnd),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_mult1_36_sub_1_o[5]~24 ),
	.combout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[6]~25_combout ),
	.cout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[6]~26 ));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[6]~25 .lut_mask = 16'hA5AF;
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[6]~25 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_36_sub_1_o[6] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_36_sub_1_o[6]~25_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_36_sub_1_o[6]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[6] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[6] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_add2_4_o[6]~29 (
	.dataa(\u0_m0_wo0_mtree_mult1_34_sub_1_o[6]~q ),
	.datab(\u0_m0_wo0_mtree_mult1_36_sub_1_o[6]~q ),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_add2_4_o[5]~28 ),
	.combout(\u0_m0_wo0_mtree_add2_4_o[6]~29_combout ),
	.cout(\u0_m0_wo0_mtree_add2_4_o[6]~30 ));
defparam \u0_m0_wo0_mtree_add2_4_o[6]~29 .lut_mask = 16'h698E;
defparam \u0_m0_wo0_mtree_add2_4_o[6]~29 .sum_lutc_input = "cin";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_34_sub_1_o[7]~9 (
	.dataa(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][0]~q ),
	.datab(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][7]~q ),
	.datac(gnd),
	.datad(vcc),
	.cin(gnd),
	.combout(\u0_m0_wo0_mtree_mult1_34_sub_1_o[7]~9_combout ),
	.cout(\u0_m0_wo0_mtree_mult1_34_sub_1_o[7]~10 ));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[7]~9 .lut_mask = 16'h66DD;
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[7]~9 .sum_lutc_input = "datac";

dffeas \u0_m0_wo0_mtree_mult1_34_sub_1_o[7] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_34_sub_1_o[7]~9_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_34_sub_1_o[7]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[7] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[7] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_36_sub_1_o[7]~27 (
	.dataa(xIn_0[7]),
	.datab(xIn_0[0]),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_mult1_36_sub_1_o[6]~26 ),
	.combout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[7]~27_combout ),
	.cout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[7]~28 ));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[7]~27 .lut_mask = 16'h964D;
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[7]~27 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_36_sub_1_o[7] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_36_sub_1_o[7]~27_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_36_sub_1_o[7]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[7] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[7] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_add2_4_o[7]~31 (
	.dataa(\u0_m0_wo0_mtree_mult1_34_sub_1_o[7]~q ),
	.datab(\u0_m0_wo0_mtree_mult1_36_sub_1_o[7]~q ),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_add2_4_o[6]~30 ),
	.combout(\u0_m0_wo0_mtree_add2_4_o[7]~31_combout ),
	.cout(\u0_m0_wo0_mtree_add2_4_o[7]~32 ));
defparam \u0_m0_wo0_mtree_add2_4_o[7]~31 .lut_mask = 16'h9617;
defparam \u0_m0_wo0_mtree_add2_4_o[7]~31 .sum_lutc_input = "cin";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_34_sub_1_o[8]~11 (
	.dataa(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][1]~q ),
	.datab(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][7]~q ),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_mult1_34_sub_1_o[7]~10 ),
	.combout(\u0_m0_wo0_mtree_mult1_34_sub_1_o[8]~11_combout ),
	.cout(\u0_m0_wo0_mtree_mult1_34_sub_1_o[8]~12 ));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[8]~11 .lut_mask = 16'h692B;
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[8]~11 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_34_sub_1_o[8] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_34_sub_1_o[8]~11_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_34_sub_1_o[8]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[8] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[8] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_36_sub_1_o[8]~29 (
	.dataa(xIn_0[7]),
	.datab(xIn_0[1]),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_mult1_36_sub_1_o[7]~28 ),
	.combout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[8]~29_combout ),
	.cout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[8]~30 ));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[8]~29 .lut_mask = 16'h692B;
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[8]~29 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_36_sub_1_o[8] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_36_sub_1_o[8]~29_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_36_sub_1_o[8]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[8] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[8] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_add2_4_o[8]~33 (
	.dataa(\u0_m0_wo0_mtree_mult1_34_sub_1_o[8]~q ),
	.datab(\u0_m0_wo0_mtree_mult1_36_sub_1_o[8]~q ),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_add2_4_o[7]~32 ),
	.combout(\u0_m0_wo0_mtree_add2_4_o[8]~33_combout ),
	.cout(\u0_m0_wo0_mtree_add2_4_o[8]~34 ));
defparam \u0_m0_wo0_mtree_add2_4_o[8]~33 .lut_mask = 16'h698E;
defparam \u0_m0_wo0_mtree_add2_4_o[8]~33 .sum_lutc_input = "cin";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_34_sub_1_o[9]~13 (
	.dataa(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][2]~q ),
	.datab(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][7]~q ),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_mult1_34_sub_1_o[8]~12 ),
	.combout(\u0_m0_wo0_mtree_mult1_34_sub_1_o[9]~13_combout ),
	.cout(\u0_m0_wo0_mtree_mult1_34_sub_1_o[9]~14 ));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[9]~13 .lut_mask = 16'h964D;
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[9]~13 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_34_sub_1_o[9] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_34_sub_1_o[9]~13_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_34_sub_1_o[9]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[9] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[9] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_36_sub_1_o[9]~31 (
	.dataa(xIn_0[7]),
	.datab(xIn_0[2]),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_mult1_36_sub_1_o[8]~30 ),
	.combout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[9]~31_combout ),
	.cout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[9]~32 ));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[9]~31 .lut_mask = 16'h964D;
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[9]~31 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_36_sub_1_o[9] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_36_sub_1_o[9]~31_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_36_sub_1_o[9]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[9] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[9] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_add2_4_o[9]~35 (
	.dataa(\u0_m0_wo0_mtree_mult1_34_sub_1_o[9]~q ),
	.datab(\u0_m0_wo0_mtree_mult1_36_sub_1_o[9]~q ),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_add2_4_o[8]~34 ),
	.combout(\u0_m0_wo0_mtree_add2_4_o[9]~35_combout ),
	.cout(\u0_m0_wo0_mtree_add2_4_o[9]~36 ));
defparam \u0_m0_wo0_mtree_add2_4_o[9]~35 .lut_mask = 16'h9617;
defparam \u0_m0_wo0_mtree_add2_4_o[9]~35 .sum_lutc_input = "cin";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_34_sub_1_o[10]~15 (
	.dataa(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][3]~q ),
	.datab(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][7]~q ),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_mult1_34_sub_1_o[9]~14 ),
	.combout(\u0_m0_wo0_mtree_mult1_34_sub_1_o[10]~15_combout ),
	.cout(\u0_m0_wo0_mtree_mult1_34_sub_1_o[10]~16 ));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[10]~15 .lut_mask = 16'h692B;
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[10]~15 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_34_sub_1_o[10] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_34_sub_1_o[10]~15_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_34_sub_1_o[10]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[10] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[10] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_36_sub_1_o[10]~33 (
	.dataa(xIn_0[7]),
	.datab(xIn_0[3]),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_mult1_36_sub_1_o[9]~32 ),
	.combout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[10]~33_combout ),
	.cout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[10]~34 ));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[10]~33 .lut_mask = 16'h692B;
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[10]~33 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_36_sub_1_o[10] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_36_sub_1_o[10]~33_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_36_sub_1_o[10]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[10] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[10] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_add2_4_o[10]~37 (
	.dataa(\u0_m0_wo0_mtree_mult1_34_sub_1_o[10]~q ),
	.datab(\u0_m0_wo0_mtree_mult1_36_sub_1_o[10]~q ),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_add2_4_o[9]~36 ),
	.combout(\u0_m0_wo0_mtree_add2_4_o[10]~37_combout ),
	.cout(\u0_m0_wo0_mtree_add2_4_o[10]~38 ));
defparam \u0_m0_wo0_mtree_add2_4_o[10]~37 .lut_mask = 16'h698E;
defparam \u0_m0_wo0_mtree_add2_4_o[10]~37 .sum_lutc_input = "cin";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_34_sub_1_o[11]~17 (
	.dataa(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][4]~q ),
	.datab(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][7]~q ),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_mult1_34_sub_1_o[10]~16 ),
	.combout(\u0_m0_wo0_mtree_mult1_34_sub_1_o[11]~17_combout ),
	.cout(\u0_m0_wo0_mtree_mult1_34_sub_1_o[11]~18 ));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[11]~17 .lut_mask = 16'h964D;
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[11]~17 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_34_sub_1_o[11] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_34_sub_1_o[11]~17_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_34_sub_1_o[11]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[11] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[11] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_36_sub_1_o[11]~35 (
	.dataa(xIn_0[7]),
	.datab(xIn_0[4]),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_mult1_36_sub_1_o[10]~34 ),
	.combout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[11]~35_combout ),
	.cout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[11]~36 ));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[11]~35 .lut_mask = 16'h964D;
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[11]~35 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_36_sub_1_o[11] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_36_sub_1_o[11]~35_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_36_sub_1_o[11]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[11] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[11] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_add2_4_o[11]~39 (
	.dataa(\u0_m0_wo0_mtree_mult1_34_sub_1_o[11]~q ),
	.datab(\u0_m0_wo0_mtree_mult1_36_sub_1_o[11]~q ),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_add2_4_o[10]~38 ),
	.combout(\u0_m0_wo0_mtree_add2_4_o[11]~39_combout ),
	.cout(\u0_m0_wo0_mtree_add2_4_o[11]~40 ));
defparam \u0_m0_wo0_mtree_add2_4_o[11]~39 .lut_mask = 16'h9617;
defparam \u0_m0_wo0_mtree_add2_4_o[11]~39 .sum_lutc_input = "cin";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_34_sub_1_o[12]~19 (
	.dataa(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][5]~q ),
	.datab(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][7]~q ),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_mult1_34_sub_1_o[11]~18 ),
	.combout(\u0_m0_wo0_mtree_mult1_34_sub_1_o[12]~19_combout ),
	.cout(\u0_m0_wo0_mtree_mult1_34_sub_1_o[12]~20 ));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[12]~19 .lut_mask = 16'h692B;
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[12]~19 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_34_sub_1_o[12] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_34_sub_1_o[12]~19_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_34_sub_1_o[12]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[12] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[12] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_36_sub_1_o[12]~37 (
	.dataa(xIn_0[7]),
	.datab(xIn_0[5]),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_mult1_36_sub_1_o[11]~36 ),
	.combout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[12]~37_combout ),
	.cout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[12]~38 ));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[12]~37 .lut_mask = 16'h692B;
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[12]~37 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_36_sub_1_o[12] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_36_sub_1_o[12]~37_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_36_sub_1_o[12]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[12] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[12] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_add2_4_o[12]~41 (
	.dataa(\u0_m0_wo0_mtree_mult1_34_sub_1_o[12]~q ),
	.datab(\u0_m0_wo0_mtree_mult1_36_sub_1_o[12]~q ),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_add2_4_o[11]~40 ),
	.combout(\u0_m0_wo0_mtree_add2_4_o[12]~41_combout ),
	.cout(\u0_m0_wo0_mtree_add2_4_o[12]~42 ));
defparam \u0_m0_wo0_mtree_add2_4_o[12]~41 .lut_mask = 16'h698E;
defparam \u0_m0_wo0_mtree_add2_4_o[12]~41 .sum_lutc_input = "cin";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_34_sub_1_o[13]~21 (
	.dataa(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][6]~q ),
	.datab(\u0_m0_wo0_wi0_r0_delayr2|delay_signals[0][7]~q ),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_mult1_34_sub_1_o[12]~20 ),
	.combout(\u0_m0_wo0_mtree_mult1_34_sub_1_o[13]~21_combout ),
	.cout(\u0_m0_wo0_mtree_mult1_34_sub_1_o[13]~22 ));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[13]~21 .lut_mask = 16'h964D;
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[13]~21 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_34_sub_1_o[13] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_34_sub_1_o[13]~21_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_34_sub_1_o[13]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[13] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[13] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_36_sub_1_o[13]~39 (
	.dataa(xIn_0[7]),
	.datab(xIn_0[6]),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_mult1_36_sub_1_o[12]~38 ),
	.combout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[13]~39_combout ),
	.cout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[13]~40 ));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[13]~39 .lut_mask = 16'h964D;
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[13]~39 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_36_sub_1_o[13] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_36_sub_1_o[13]~39_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_36_sub_1_o[13]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[13] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[13] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_add2_4_o[13]~43 (
	.dataa(\u0_m0_wo0_mtree_mult1_34_sub_1_o[13]~q ),
	.datab(\u0_m0_wo0_mtree_mult1_36_sub_1_o[13]~q ),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_add2_4_o[12]~42 ),
	.combout(\u0_m0_wo0_mtree_add2_4_o[13]~43_combout ),
	.cout(\u0_m0_wo0_mtree_add2_4_o[13]~44 ));
defparam \u0_m0_wo0_mtree_add2_4_o[13]~43 .lut_mask = 16'h9617;
defparam \u0_m0_wo0_mtree_add2_4_o[13]~43 .sum_lutc_input = "cin";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_34_sub_1_o[14]~23 (
	.dataa(gnd),
	.datab(gnd),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_mult1_34_sub_1_o[13]~22 ),
	.combout(\u0_m0_wo0_mtree_mult1_34_sub_1_o[14]~23_combout ),
	.cout(\u0_m0_wo0_mtree_mult1_34_sub_1_o[14]~24 ));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[14]~23 .lut_mask = 16'h0F0F;
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[14]~23 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_34_sub_1_o[14] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_34_sub_1_o[14]~23_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_34_sub_1_o[14]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[14] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[14] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_36_sub_1_o[14]~41 (
	.dataa(gnd),
	.datab(gnd),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_mult1_36_sub_1_o[13]~40 ),
	.combout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[14]~41_combout ),
	.cout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[14]~42 ));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[14]~41 .lut_mask = 16'h0F0F;
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[14]~41 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_36_sub_1_o[14] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_36_sub_1_o[14]~41_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_36_sub_1_o[14]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[14] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[14] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_add2_4_o[14]~45 (
	.dataa(\u0_m0_wo0_mtree_mult1_34_sub_1_o[14]~q ),
	.datab(\u0_m0_wo0_mtree_mult1_36_sub_1_o[14]~q ),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_add2_4_o[13]~44 ),
	.combout(\u0_m0_wo0_mtree_add2_4_o[14]~45_combout ),
	.cout(\u0_m0_wo0_mtree_add2_4_o[14]~46 ));
defparam \u0_m0_wo0_mtree_add2_4_o[14]~45 .lut_mask = 16'h698E;
defparam \u0_m0_wo0_mtree_add2_4_o[14]~45 .sum_lutc_input = "cin";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_34_sub_1_o[15]~25 (
	.dataa(gnd),
	.datab(gnd),
	.datac(gnd),
	.datad(gnd),
	.cin(\u0_m0_wo0_mtree_mult1_34_sub_1_o[14]~24 ),
	.combout(\u0_m0_wo0_mtree_mult1_34_sub_1_o[15]~25_combout ),
	.cout());
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[15]~25 .lut_mask = 16'hF0F0;
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[15]~25 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_34_sub_1_o[15] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_34_sub_1_o[15]~25_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_34_sub_1_o[15]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[15] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_34_sub_1_o[15] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_mult1_36_sub_1_o[15]~43 (
	.dataa(gnd),
	.datab(gnd),
	.datac(gnd),
	.datad(gnd),
	.cin(\u0_m0_wo0_mtree_mult1_36_sub_1_o[14]~42 ),
	.combout(\u0_m0_wo0_mtree_mult1_36_sub_1_o[15]~43_combout ),
	.cout());
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[15]~43 .lut_mask = 16'hF0F0;
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[15]~43 .sum_lutc_input = "cin";

dffeas \u0_m0_wo0_mtree_mult1_36_sub_1_o[15] (
	.clk(clk),
	.d(\u0_m0_wo0_mtree_mult1_36_sub_1_o[15]~43_combout ),
	.asdata(vcc),
	.clrn(areset),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(\u0_m0_wo0_mtree_mult1_36_sub_1_o[15]~q ),
	.prn(vcc));
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[15] .is_wysiwyg = "true";
defparam \u0_m0_wo0_mtree_mult1_36_sub_1_o[15] .power_up = "low";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_add2_4_o[15]~47 (
	.dataa(\u0_m0_wo0_mtree_mult1_34_sub_1_o[15]~q ),
	.datab(\u0_m0_wo0_mtree_mult1_36_sub_1_o[15]~q ),
	.datac(gnd),
	.datad(vcc),
	.cin(\u0_m0_wo0_mtree_add2_4_o[14]~46 ),
	.combout(\u0_m0_wo0_mtree_add2_4_o[15]~47_combout ),
	.cout(\u0_m0_wo0_mtree_add2_4_o[15]~48 ));
defparam \u0_m0_wo0_mtree_add2_4_o[15]~47 .lut_mask = 16'h9617;
defparam \u0_m0_wo0_mtree_add2_4_o[15]~47 .sum_lutc_input = "cin";

fiftyfivenm_lcell_comb \u0_m0_wo0_mtree_add2_4_o[18]~49 (
	.dataa(\u0_m0_wo0_mtree_mult1_34_sub_1_o[15]~q ),
	.datab(\u0_m0_wo0_mtree_mult1_36_sub_1_o[15]~q ),
	.datac(gnd),
	.datad(gnd),
	.cin(\u0_m0_wo0_mtree_add2_4_o[15]~48 ),
	.combout(\u0_m0_wo0_mtree_add2_4_o[18]~49_combout ),
	.cout());
defparam \u0_m0_wo0_mtree_add2_4_o[18]~49 .lut_mask = 16'h6969;
defparam \u0_m0_wo0_mtree_add2_4_o[18]~49 .sum_lutc_input = "cin";

endmodule

module fir_compiler_ii_dspba_delay (
	delay_signals_0_0,
	clk,
	aclr,
	xin)/* synthesis synthesis_greybox=0 */;
output 	delay_signals_0_0;
input 	clk;
input 	aclr;
input 	[7:0] xin;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;



dffeas \delay_signals[0][0] (
	.clk(clk),
	.d(xin[0]),
	.asdata(vcc),
	.clrn(aclr),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(vcc),
	.q(delay_signals_0_0),
	.prn(vcc));
defparam \delay_signals[0][0] .is_wysiwyg = "true";
defparam \delay_signals[0][0] .power_up = "low";

endmodule

module fir_compiler_ii_dspba_delay_1 (
	delay_signals_0_0,
	delay_signals_1_0,
	delay_signals_2_0,
	delay_signals_3_0,
	delay_signals_4_0,
	delay_signals_5_0,
	delay_signals_6_0,
	delay_signals_7_0,
	clk,
	aclr,
	ena,
	xin)/* synthesis synthesis_greybox=0 */;
output 	delay_signals_0_0;
output 	delay_signals_1_0;
output 	delay_signals_2_0;
output 	delay_signals_3_0;
output 	delay_signals_4_0;
output 	delay_signals_5_0;
output 	delay_signals_6_0;
output 	delay_signals_7_0;
input 	clk;
input 	aclr;
input 	ena;
input 	[7:0] xin;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;



dffeas \delay_signals[0][0] (
	.clk(clk),
	.d(xin[0]),
	.asdata(vcc),
	.clrn(aclr),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(ena),
	.q(delay_signals_0_0),
	.prn(vcc));
defparam \delay_signals[0][0] .is_wysiwyg = "true";
defparam \delay_signals[0][0] .power_up = "low";

dffeas \delay_signals[0][1] (
	.clk(clk),
	.d(xin[1]),
	.asdata(vcc),
	.clrn(aclr),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(ena),
	.q(delay_signals_1_0),
	.prn(vcc));
defparam \delay_signals[0][1] .is_wysiwyg = "true";
defparam \delay_signals[0][1] .power_up = "low";

dffeas \delay_signals[0][2] (
	.clk(clk),
	.d(xin[2]),
	.asdata(vcc),
	.clrn(aclr),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(ena),
	.q(delay_signals_2_0),
	.prn(vcc));
defparam \delay_signals[0][2] .is_wysiwyg = "true";
defparam \delay_signals[0][2] .power_up = "low";

dffeas \delay_signals[0][3] (
	.clk(clk),
	.d(xin[3]),
	.asdata(vcc),
	.clrn(aclr),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(ena),
	.q(delay_signals_3_0),
	.prn(vcc));
defparam \delay_signals[0][3] .is_wysiwyg = "true";
defparam \delay_signals[0][3] .power_up = "low";

dffeas \delay_signals[0][4] (
	.clk(clk),
	.d(xin[4]),
	.asdata(vcc),
	.clrn(aclr),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(ena),
	.q(delay_signals_4_0),
	.prn(vcc));
defparam \delay_signals[0][4] .is_wysiwyg = "true";
defparam \delay_signals[0][4] .power_up = "low";

dffeas \delay_signals[0][5] (
	.clk(clk),
	.d(xin[5]),
	.asdata(vcc),
	.clrn(aclr),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(ena),
	.q(delay_signals_5_0),
	.prn(vcc));
defparam \delay_signals[0][5] .is_wysiwyg = "true";
defparam \delay_signals[0][5] .power_up = "low";

dffeas \delay_signals[0][6] (
	.clk(clk),
	.d(xin[6]),
	.asdata(vcc),
	.clrn(aclr),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(ena),
	.q(delay_signals_6_0),
	.prn(vcc));
defparam \delay_signals[0][6] .is_wysiwyg = "true";
defparam \delay_signals[0][6] .power_up = "low";

dffeas \delay_signals[0][7] (
	.clk(clk),
	.d(xin[7]),
	.asdata(vcc),
	.clrn(aclr),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(ena),
	.q(delay_signals_7_0),
	.prn(vcc));
defparam \delay_signals[0][7] .is_wysiwyg = "true";
defparam \delay_signals[0][7] .power_up = "low";

endmodule

module fir_compiler_ii_dspba_delay_2 (
	delay_signals_0_0,
	delay_signals_1_0,
	delay_signals_2_0,
	delay_signals_3_0,
	delay_signals_4_0,
	delay_signals_5_0,
	delay_signals_6_0,
	delay_signals_7_0,
	xin,
	clk,
	aclr,
	ena)/* synthesis synthesis_greybox=0 */;
output 	delay_signals_0_0;
output 	delay_signals_1_0;
output 	delay_signals_2_0;
output 	delay_signals_3_0;
output 	delay_signals_4_0;
output 	delay_signals_5_0;
output 	delay_signals_6_0;
output 	delay_signals_7_0;
input 	[7:0] xin;
input 	clk;
input 	aclr;
input 	ena;

wire gnd;
wire vcc;
wire unknown;

assign gnd = 1'b0;
assign vcc = 1'b1;
// unknown value (1'bx) is not needed for this tool. Default to 1'b0
assign unknown = 1'b0;



dffeas \delay_signals[0][0] (
	.clk(clk),
	.d(xin[0]),
	.asdata(vcc),
	.clrn(aclr),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(ena),
	.q(delay_signals_0_0),
	.prn(vcc));
defparam \delay_signals[0][0] .is_wysiwyg = "true";
defparam \delay_signals[0][0] .power_up = "low";

dffeas \delay_signals[0][1] (
	.clk(clk),
	.d(xin[1]),
	.asdata(vcc),
	.clrn(aclr),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(ena),
	.q(delay_signals_1_0),
	.prn(vcc));
defparam \delay_signals[0][1] .is_wysiwyg = "true";
defparam \delay_signals[0][1] .power_up = "low";

dffeas \delay_signals[0][2] (
	.clk(clk),
	.d(xin[2]),
	.asdata(vcc),
	.clrn(aclr),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(ena),
	.q(delay_signals_2_0),
	.prn(vcc));
defparam \delay_signals[0][2] .is_wysiwyg = "true";
defparam \delay_signals[0][2] .power_up = "low";

dffeas \delay_signals[0][3] (
	.clk(clk),
	.d(xin[3]),
	.asdata(vcc),
	.clrn(aclr),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(ena),
	.q(delay_signals_3_0),
	.prn(vcc));
defparam \delay_signals[0][3] .is_wysiwyg = "true";
defparam \delay_signals[0][3] .power_up = "low";

dffeas \delay_signals[0][4] (
	.clk(clk),
	.d(xin[4]),
	.asdata(vcc),
	.clrn(aclr),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(ena),
	.q(delay_signals_4_0),
	.prn(vcc));
defparam \delay_signals[0][4] .is_wysiwyg = "true";
defparam \delay_signals[0][4] .power_up = "low";

dffeas \delay_signals[0][5] (
	.clk(clk),
	.d(xin[5]),
	.asdata(vcc),
	.clrn(aclr),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(ena),
	.q(delay_signals_5_0),
	.prn(vcc));
defparam \delay_signals[0][5] .is_wysiwyg = "true";
defparam \delay_signals[0][5] .power_up = "low";

dffeas \delay_signals[0][6] (
	.clk(clk),
	.d(xin[6]),
	.asdata(vcc),
	.clrn(aclr),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(ena),
	.q(delay_signals_6_0),
	.prn(vcc));
defparam \delay_signals[0][6] .is_wysiwyg = "true";
defparam \delay_signals[0][6] .power_up = "low";

dffeas \delay_signals[0][7] (
	.clk(clk),
	.d(xin[7]),
	.asdata(vcc),
	.clrn(aclr),
	.aload(gnd),
	.sclr(gnd),
	.sload(gnd),
	.ena(ena),
	.q(delay_signals_7_0),
	.prn(vcc));
defparam \delay_signals[0][7] .is_wysiwyg = "true";
defparam \delay_signals[0][7] .power_up = "low";

endmodule
