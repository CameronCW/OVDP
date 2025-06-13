/*
 Copyright (C) 2018  Intel Corporation. All rights reserved.
 Your use of Intel Corporation's design tools, logic functions 
 and other software and tools, and its AMPP partner logic 
 functions, and any output files from any of the foregoing 
 (including device programming or simulation files), and any 
 associated documentation or information are expressly subject 
 to the terms and conditions of the Intel Program License 
 Subscription Agreement, the Intel Quartus Prime License Agreement,
 the Intel FPGA IP License Agreement, or other applicable license
 agreement, including, without limitation, that your use is for
 the sole purpose of programming logic devices manufactured by
 Intel and sold by Intel or its authorized distributors.  Please
 refer to the applicable agreement for further details.
*/
MODEL
/*MODEL HEADER*/
/*
 This file contains Fast Corner delays for the design using part 5CSEMA5F31C6
 with speed grade M, core voltage 1.1V, and temperature 0 Celsius

*/
MODEL_VERSION "1.0";
DESIGN "OVDP";
DATE "06/06/2025 20:07:58";
PROGRAM "Quartus Prime";



INPUT clk_clk;
INPUT reset_reset_n;
INPUT spislave_export_sclk;
INPUT spislave_export_nss;
INPUT spislave_export_mosi;
INOUT spislave_export_miso;
INPUT spislave_avalon_streaming_sink_data[2];
INPUT spislave_avalon_streaming_sink_data[0];
INPUT spislave_avalon_streaming_sink_data[1];
INPUT spislave_avalon_streaming_sink_valid;
INPUT spislave_avalon_streaming_sink_data[4];
INPUT spislave_avalon_streaming_sink_data[3];
INPUT spislave_avalon_streaming_sink_data[6];
INPUT spislave_avalon_streaming_sink_data[7];
INPUT spislave_avalon_streaming_sink_data[5];
INPUT preprocess_block_lsync_export;
INPUT preprocess_block_rsync_export;
INPUT preprocess_block_sig_export;
OUTPUT spislave_avalon_streaming_sink_ready;
OUTPUT pid_focus_pwm_out_export[0];
OUTPUT pid_focus_pwm_out_export[1];
OUTPUT pid_focus_pwm_out_export[2];
OUTPUT pid_focus_pwm_out_export[3];
OUTPUT pid_focus_pwm_out_export[4];
OUTPUT pid_focus_pwm_out_export[5];
OUTPUT pid_focus_pwm_out_export[6];
OUTPUT pid_focus_pwm_out_export[7];
OUTPUT i2s_tx_bclk_export;
OUTPUT i2s_tx_lrclk_export;
OUTPUT i2s_tx_sdata_export;

/*Arc definitions start here*/
pos_spislave_avalon_streaming_sink_data[0]__clk_clk__setup:		SETUP (POSEDGE) spislave_avalon_streaming_sink_data[0] clk_clk ;
pos_spislave_avalon_streaming_sink_data[1]__clk_clk__setup:		SETUP (POSEDGE) spislave_avalon_streaming_sink_data[1] clk_clk ;
pos_spislave_avalon_streaming_sink_data[2]__clk_clk__setup:		SETUP (POSEDGE) spislave_avalon_streaming_sink_data[2] clk_clk ;
pos_spislave_avalon_streaming_sink_data[3]__clk_clk__setup:		SETUP (POSEDGE) spislave_avalon_streaming_sink_data[3] clk_clk ;
pos_spislave_avalon_streaming_sink_data[4]__clk_clk__setup:		SETUP (POSEDGE) spislave_avalon_streaming_sink_data[4] clk_clk ;
pos_spislave_avalon_streaming_sink_data[5]__clk_clk__setup:		SETUP (POSEDGE) spislave_avalon_streaming_sink_data[5] clk_clk ;
pos_spislave_avalon_streaming_sink_data[6]__clk_clk__setup:		SETUP (POSEDGE) spislave_avalon_streaming_sink_data[6] clk_clk ;
pos_spislave_avalon_streaming_sink_data[7]__clk_clk__setup:		SETUP (POSEDGE) spislave_avalon_streaming_sink_data[7] clk_clk ;
pos_spislave_avalon_streaming_sink_valid__clk_clk__setup:		SETUP (POSEDGE) spislave_avalon_streaming_sink_valid clk_clk ;
pos_spislave_export_mosi__clk_clk__setup:		SETUP (POSEDGE) spislave_export_mosi clk_clk ;
pos_spislave_export_nss__clk_clk__setup:		SETUP (POSEDGE) spislave_export_nss clk_clk ;
pos_spislave_export_sclk__clk_clk__setup:		SETUP (POSEDGE) spislave_export_sclk clk_clk ;
pos_spislave_avalon_streaming_sink_data[0]__synchronizer:sync_sclk|sync_reg2__setup:		SETUP (POSEDGE) spislave_avalon_streaming_sink_data[0] synchronizer:sync_sclk|sync_reg2 ;
pos_spislave_avalon_streaming_sink_data[1]__synchronizer:sync_sclk|sync_reg2__setup:		SETUP (POSEDGE) spislave_avalon_streaming_sink_data[1] synchronizer:sync_sclk|sync_reg2 ;
pos_spislave_avalon_streaming_sink_data[2]__synchronizer:sync_sclk|sync_reg2__setup:		SETUP (POSEDGE) spislave_avalon_streaming_sink_data[2] synchronizer:sync_sclk|sync_reg2 ;
pos_spislave_avalon_streaming_sink_data[3]__synchronizer:sync_sclk|sync_reg2__setup:		SETUP (POSEDGE) spislave_avalon_streaming_sink_data[3] synchronizer:sync_sclk|sync_reg2 ;
pos_spislave_avalon_streaming_sink_data[4]__synchronizer:sync_sclk|sync_reg2__setup:		SETUP (POSEDGE) spislave_avalon_streaming_sink_data[4] synchronizer:sync_sclk|sync_reg2 ;
pos_spislave_avalon_streaming_sink_data[5]__synchronizer:sync_sclk|sync_reg2__setup:		SETUP (POSEDGE) spislave_avalon_streaming_sink_data[5] synchronizer:sync_sclk|sync_reg2 ;
pos_spislave_avalon_streaming_sink_data[6]__synchronizer:sync_sclk|sync_reg2__setup:		SETUP (POSEDGE) spislave_avalon_streaming_sink_data[6] synchronizer:sync_sclk|sync_reg2 ;
pos_spislave_avalon_streaming_sink_data[7]__synchronizer:sync_sclk|sync_reg2__setup:		SETUP (POSEDGE) spislave_avalon_streaming_sink_data[7] synchronizer:sync_sclk|sync_reg2 ;
pos_spislave_avalon_streaming_sink_valid__synchronizer:sync_sclk|sync_reg2__setup:		SETUP (POSEDGE) spislave_avalon_streaming_sink_valid synchronizer:sync_sclk|sync_reg2 ;
pos_spislave_avalon_streaming_sink_data[0]__clk_clk__hold:		HOLD (POSEDGE) spislave_avalon_streaming_sink_data[0] clk_clk ;
pos_spislave_avalon_streaming_sink_data[1]__clk_clk__hold:		HOLD (POSEDGE) spislave_avalon_streaming_sink_data[1] clk_clk ;
pos_spislave_avalon_streaming_sink_data[2]__clk_clk__hold:		HOLD (POSEDGE) spislave_avalon_streaming_sink_data[2] clk_clk ;
pos_spislave_avalon_streaming_sink_data[3]__clk_clk__hold:		HOLD (POSEDGE) spislave_avalon_streaming_sink_data[3] clk_clk ;
pos_spislave_avalon_streaming_sink_data[4]__clk_clk__hold:		HOLD (POSEDGE) spislave_avalon_streaming_sink_data[4] clk_clk ;
pos_spislave_avalon_streaming_sink_data[5]__clk_clk__hold:		HOLD (POSEDGE) spislave_avalon_streaming_sink_data[5] clk_clk ;
pos_spislave_avalon_streaming_sink_data[6]__clk_clk__hold:		HOLD (POSEDGE) spislave_avalon_streaming_sink_data[6] clk_clk ;
pos_spislave_avalon_streaming_sink_data[7]__clk_clk__hold:		HOLD (POSEDGE) spislave_avalon_streaming_sink_data[7] clk_clk ;
pos_spislave_avalon_streaming_sink_valid__clk_clk__hold:		HOLD (POSEDGE) spislave_avalon_streaming_sink_valid clk_clk ;
pos_spislave_export_mosi__clk_clk__hold:		HOLD (POSEDGE) spislave_export_mosi clk_clk ;
pos_spislave_export_nss__clk_clk__hold:		HOLD (POSEDGE) spislave_export_nss clk_clk ;
pos_spislave_export_sclk__clk_clk__hold:		HOLD (POSEDGE) spislave_export_sclk clk_clk ;
pos_spislave_avalon_streaming_sink_data[0]__synchronizer:sync_sclk|sync_reg2__hold:		HOLD (POSEDGE) spislave_avalon_streaming_sink_data[0] synchronizer:sync_sclk|sync_reg2 ;
pos_spislave_avalon_streaming_sink_data[1]__synchronizer:sync_sclk|sync_reg2__hold:		HOLD (POSEDGE) spislave_avalon_streaming_sink_data[1] synchronizer:sync_sclk|sync_reg2 ;
pos_spislave_avalon_streaming_sink_data[2]__synchronizer:sync_sclk|sync_reg2__hold:		HOLD (POSEDGE) spislave_avalon_streaming_sink_data[2] synchronizer:sync_sclk|sync_reg2 ;
pos_spislave_avalon_streaming_sink_data[3]__synchronizer:sync_sclk|sync_reg2__hold:		HOLD (POSEDGE) spislave_avalon_streaming_sink_data[3] synchronizer:sync_sclk|sync_reg2 ;
pos_spislave_avalon_streaming_sink_data[4]__synchronizer:sync_sclk|sync_reg2__hold:		HOLD (POSEDGE) spislave_avalon_streaming_sink_data[4] synchronizer:sync_sclk|sync_reg2 ;
pos_spislave_avalon_streaming_sink_data[5]__synchronizer:sync_sclk|sync_reg2__hold:		HOLD (POSEDGE) spislave_avalon_streaming_sink_data[5] synchronizer:sync_sclk|sync_reg2 ;
pos_spislave_avalon_streaming_sink_data[6]__synchronizer:sync_sclk|sync_reg2__hold:		HOLD (POSEDGE) spislave_avalon_streaming_sink_data[6] synchronizer:sync_sclk|sync_reg2 ;
pos_spislave_avalon_streaming_sink_data[7]__synchronizer:sync_sclk|sync_reg2__hold:		HOLD (POSEDGE) spislave_avalon_streaming_sink_data[7] synchronizer:sync_sclk|sync_reg2 ;
pos_spislave_avalon_streaming_sink_valid__synchronizer:sync_sclk|sync_reg2__hold:		HOLD (POSEDGE) spislave_avalon_streaming_sink_valid synchronizer:sync_sclk|sync_reg2 ;
pos_clk_clk__i2s_tx_bclk_export__delay:		DELAY (POSEDGE) clk_clk i2s_tx_bclk_export ;
pos_clk_clk__i2s_tx_lrclk_export__delay:		DELAY (POSEDGE) clk_clk i2s_tx_lrclk_export ;
pos_clk_clk__i2s_tx_sdata_export__delay:		DELAY (POSEDGE) clk_clk i2s_tx_sdata_export ;
pos_clk_clk__pid_focus_pwm_out_export[0]__delay:		DELAY (POSEDGE) clk_clk pid_focus_pwm_out_export[0] ;
pos_clk_clk__spislave_avalon_streaming_sink_ready__delay:		DELAY (POSEDGE) clk_clk spislave_avalon_streaming_sink_ready ;
pos_synchronizer:sync_sclk|sync_reg2__spislave_export_miso__delay:		DELAY (POSEDGE) synchronizer:sync_sclk|sync_reg2 spislave_export_miso ;
_6.195__6.691__delay:		DELAY 6.195 6.691 ;
_6.193__6.678__delay:		DELAY 6.193 6.678 ;
_6.435__6.925__delay:		DELAY 6.435 6.925 ;
_6.148__delay:		DELAY 6.148  ;
___6.640__delay:		DELAY  6.640 ;
___6.764__delay:		DELAY  6.764 ;
_6.152__delay:		DELAY 6.152  ;
___6.534__delay:		DELAY  6.534 ;
_5.740__delay:		DELAY 5.740  ;

ENDMODEL
