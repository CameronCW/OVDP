
module OVDP (
	clk_clk,
	i2s_tx_bclk_export,
	i2s_tx_lrclk_export,
	i2s_tx_sdata_export,
	pid_focus_pwm_out_export,
	preprocess_block_lsync_export,
	preprocess_block_rsync_export,
	preprocess_block_sig_export,
	reset_reset_n,
	spislave_avalon_streaming_sink_valid,
	spislave_avalon_streaming_sink_data,
	spislave_avalon_streaming_sink_ready,
	spislave_export_mosi,
	spislave_export_nss,
	spislave_export_miso,
	spislave_export_sclk);	

	input		clk_clk;
	output		i2s_tx_bclk_export;
	output		i2s_tx_lrclk_export;
	output		i2s_tx_sdata_export;
	output	[7:0]	pid_focus_pwm_out_export;
	input		preprocess_block_lsync_export;
	input		preprocess_block_rsync_export;
	input		preprocess_block_sig_export;
	input		reset_reset_n;
	input		spislave_avalon_streaming_sink_valid;
	input	[7:0]	spislave_avalon_streaming_sink_data;
	output		spislave_avalon_streaming_sink_ready;
	input		spislave_export_mosi;
	input		spislave_export_nss;
	inout		spislave_export_miso;
	input		spislave_export_sclk;
endmodule
