module top (
    input  wire        clk_clk,
    input  wire        reset_reset_n,

    // SPI input interface (receive-only)
    input  wire        spislave_export_mosi,
    input  wire        spislave_export_sclk,
    input  wire        spislave_export_nss,
    inout  wire        spislave_export_miso,   // unused if slave is input-only

    // Avalon-ST from SPI (external master)
    input  wire        spislave_avalon_streaming_sink_valid,
    input  wire  [7:0] spislave_avalon_streaming_sink_data,
    output wire        spislave_avalon_streaming_sink_ready,

    // Comparator sync/groove inputs
    input  wire        preprocess_block_lsync_export,
    input  wire        preprocess_block_rsync_export,
    input  wire        preprocess_block_sig_export,

    // PWM output
    output wire [7:0]  pid_focus_pwm_out_export,

    // I2S audio outputs
    output wire        i2s_tx_bclk_export,
    output wire        i2s_tx_lrclk_export,
    output wire        i2s_tx_sdata_export
);

    // === SPI Synchronizers ===
    wire mosi_sync;
    wire sclk_sync;
    wire nss_sync;

    synchronizer sync_mosi (
        .clk(clk_clk),
        .async_in(spislave_export_mosi),
        .sync_out(mosi_sync)
    );

    synchronizer sync_sclk (
        .clk(clk_clk),
        .async_in(spislave_export_sclk),
        .sync_out(sclk_sync)
    );

    synchronizer sync_nss (
        .clk(clk_clk),
        .async_in(spislave_export_nss),
        .sync_out(nss_sync)
    );
	 
//	 pll pll_inst (
//		  .inclk0(clk_clk),
//		  .c0(clk_slow)  // Generate 5 MHz clock
//	 );

    // === System Instantiation ===
    OVDP system_inst (
        .clk_clk(clk_clk),        // 100 MHz
        .reset_reset_n(reset_reset_n),

        .spislave_export_mosi(mosi_sync),
        .spislave_export_sclk(sclk_sync),
        .spislave_export_nss(nss_sync),
        .spislave_export_miso(spislave_export_miso),

        .spislave_avalon_streaming_sink_valid(spislave_avalon_streaming_sink_valid),
        .spislave_avalon_streaming_sink_data(spislave_avalon_streaming_sink_data),
        .spislave_avalon_streaming_sink_ready(spislave_avalon_streaming_sink_ready),

        .preprocess_block_lsync_export(preprocess_block_lsync_export),
        .preprocess_block_rsync_export(preprocess_block_rsync_export),
        .preprocess_block_sig_export(preprocess_block_sig_export),

        .pid_focus_pwm_out_export(pid_focus_pwm_out_export),

        .i2s_tx_bclk_export(i2s_tx_bclk_export),
        .i2s_tx_lrclk_export(i2s_tx_lrclk_export),
        .i2s_tx_sdata_export(i2s_tx_sdata_export)
    );

endmodule
