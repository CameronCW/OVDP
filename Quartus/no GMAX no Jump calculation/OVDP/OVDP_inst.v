	OVDP u0 (
		.clk_clk                              (<connected-to-clk_clk>),                              //                            clk.clk
		.i2s_tx_bclk_export                   (<connected-to-i2s_tx_bclk_export>),                   //                    i2s_tx_bclk.export
		.i2s_tx_lrclk_export                  (<connected-to-i2s_tx_lrclk_export>),                  //                   i2s_tx_lrclk.export
		.i2s_tx_sdata_export                  (<connected-to-i2s_tx_sdata_export>),                  //                   i2s_tx_sdata.export
		.pid_focus_pwm_out_export             (<connected-to-pid_focus_pwm_out_export>),             //              pid_focus_pwm_out.export
		.preprocess_block_lsync_export        (<connected-to-preprocess_block_lsync_export>),        //         preprocess_block_lsync.export
		.preprocess_block_rsync_export        (<connected-to-preprocess_block_rsync_export>),        //         preprocess_block_rsync.export
		.preprocess_block_sig_export          (<connected-to-preprocess_block_sig_export>),          //           preprocess_block_sig.export
		.reset_reset_n                        (<connected-to-reset_reset_n>),                        //                          reset.reset_n
		.spislave_avalon_streaming_sink_valid (<connected-to-spislave_avalon_streaming_sink_valid>), // spislave_avalon_streaming_sink.valid
		.spislave_avalon_streaming_sink_data  (<connected-to-spislave_avalon_streaming_sink_data>),  //                               .data
		.spislave_avalon_streaming_sink_ready (<connected-to-spislave_avalon_streaming_sink_ready>), //                               .ready
		.spislave_export_mosi                 (<connected-to-spislave_export_mosi>),                 //                spislave_export.mosi
		.spislave_export_nss                  (<connected-to-spislave_export_nss>),                  //                               .nss
		.spislave_export_miso                 (<connected-to-spislave_export_miso>),                 //                               .miso
		.spislave_export_sclk                 (<connected-to-spislave_export_sclk>)                  //                               .sclk
	);

