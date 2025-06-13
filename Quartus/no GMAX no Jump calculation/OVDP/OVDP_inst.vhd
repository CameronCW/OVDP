	component OVDP is
		port (
			clk_clk                              : in    std_logic                    := 'X';             -- clk
			i2s_tx_bclk_export                   : out   std_logic;                                       -- export
			i2s_tx_lrclk_export                  : out   std_logic;                                       -- export
			i2s_tx_sdata_export                  : out   std_logic;                                       -- export
			pid_focus_pwm_out_export             : out   std_logic_vector(7 downto 0);                    -- export
			preprocess_block_lsync_export        : in    std_logic                    := 'X';             -- export
			preprocess_block_rsync_export        : in    std_logic                    := 'X';             -- export
			preprocess_block_sig_export          : in    std_logic                    := 'X';             -- export
			reset_reset_n                        : in    std_logic                    := 'X';             -- reset_n
			spislave_avalon_streaming_sink_valid : in    std_logic                    := 'X';             -- valid
			spislave_avalon_streaming_sink_data  : in    std_logic_vector(7 downto 0) := (others => 'X'); -- data
			spislave_avalon_streaming_sink_ready : out   std_logic;                                       -- ready
			spislave_export_mosi                 : in    std_logic                    := 'X';             -- mosi
			spislave_export_nss                  : in    std_logic                    := 'X';             -- nss
			spislave_export_miso                 : inout std_logic                    := 'X';             -- miso
			spislave_export_sclk                 : in    std_logic                    := 'X'              -- sclk
		);
	end component OVDP;

	u0 : component OVDP
		port map (
			clk_clk                              => CONNECTED_TO_clk_clk,                              --                            clk.clk
			i2s_tx_bclk_export                   => CONNECTED_TO_i2s_tx_bclk_export,                   --                    i2s_tx_bclk.export
			i2s_tx_lrclk_export                  => CONNECTED_TO_i2s_tx_lrclk_export,                  --                   i2s_tx_lrclk.export
			i2s_tx_sdata_export                  => CONNECTED_TO_i2s_tx_sdata_export,                  --                   i2s_tx_sdata.export
			pid_focus_pwm_out_export             => CONNECTED_TO_pid_focus_pwm_out_export,             --              pid_focus_pwm_out.export
			preprocess_block_lsync_export        => CONNECTED_TO_preprocess_block_lsync_export,        --         preprocess_block_lsync.export
			preprocess_block_rsync_export        => CONNECTED_TO_preprocess_block_rsync_export,        --         preprocess_block_rsync.export
			preprocess_block_sig_export          => CONNECTED_TO_preprocess_block_sig_export,          --           preprocess_block_sig.export
			reset_reset_n                        => CONNECTED_TO_reset_reset_n,                        --                          reset.reset_n
			spislave_avalon_streaming_sink_valid => CONNECTED_TO_spislave_avalon_streaming_sink_valid, -- spislave_avalon_streaming_sink.valid
			spislave_avalon_streaming_sink_data  => CONNECTED_TO_spislave_avalon_streaming_sink_data,  --                               .data
			spislave_avalon_streaming_sink_ready => CONNECTED_TO_spislave_avalon_streaming_sink_ready, --                               .ready
			spislave_export_mosi                 => CONNECTED_TO_spislave_export_mosi,                 --                spislave_export.mosi
			spislave_export_nss                  => CONNECTED_TO_spislave_export_nss,                  --                               .nss
			spislave_export_miso                 => CONNECTED_TO_spislave_export_miso,                 --                               .miso
			spislave_export_sclk                 => CONNECTED_TO_spislave_export_sclk                  --                               .sclk
		);

