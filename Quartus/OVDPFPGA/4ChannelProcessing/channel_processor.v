module channel_processor (	// Single channel, instantiate 2 of these
    input  wire        clk,			// 100MHz
	 input  wire		  clk_slow,		// 5MHz
    input  wire        reset_n,

    input  wire [31:0] sig_time,
    input  wire        valid_in,
    input  wire        dir,            // 0 = LTR, 1 = RTL
    input  wire [31:0] t_ltr,          // Scan time left-to-right
    input  wire [31:0] t_rtl,          // Scan time right-to-left
    input  wire        sync_start,     // Reset signal for scan

    output wire signed [15:0] sample_out,
    output wire               sample_valid
);

    // Internal signals
    wire signed [15:0] normalized_sample;
    wire               normalized_valid;

    wire signed [15:0] extrapolated_sample;
    wire               extrapolated_valid;

    // === Groove timestamp to normalized sample ===
    groove_sample_timestamp u_groove (
        .clk         (clk),
		  .clk_slow		(clk_slow),
        .reset_n     (reset_n),
        .sig_time    (sig_time),
        .dir         (dir),
        .afll_ltr    (t_ltr),
        .afll_rtl    (t_rtl),
        .sync_start  (sync_start),
        .sample_out  (normalized_sample),
        .sample_valid(normalized_valid)
    );

    // === Extrapolation buffer ===
    extrapolation_buffer u_extrap (
        .clk         (clk),
        .reset_n     (reset_n),
        .sample_in   (normalized_sample),
        .valid_in    (normalized_valid),
        .sample_out  (extrapolated_sample),
        .valid_out   (extrapolated_valid)
    );

    // === FIR stream filter ===
    fir_stream_wrapper u_fir (
        .clk         (clk),
        .reset_n     (reset_n),
        .sample_in   (extrapolated_sample),
        .valid_in    (extrapolated_valid),
        .sample_out  (sample_out),
        .valid_out   (sample_valid)
    );

endmodule
