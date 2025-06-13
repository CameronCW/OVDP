module channel_processor_top (
    input  wire        clk,
	 input  wire		  clk_slow,
    input  wire        reset_n,

    input  wire [31:0] sig_time_L,
    input  wire [31:0] sig_time_R,
    input  wire        sample_valid,
    input  wire        dir,
    input  wire [31:0] t_ltr,
    input  wire [31:0] t_rtl,
    input  wire        sync_start,

    output wire signed [15:0] sample_L,
    output wire signed [15:0] sample_R,
    output wire               valid_L,
    output wire               valid_R
);

    channel_processor u_left (
        .clk(clk),
		  .clk(clk_slow),
        .reset_n(reset_n),
        .sig_time(sig_time_L),
        .valid_in(sample_valid),
        .dir(dir),
        .t_ltr(t_ltr),
        .t_rtl(t_rtl),
        .sync_start(sync_start),
        .sample_out(sample_L),
        .sample_valid(valid_L)
    );

    channel_processor u_right (
        .clk(clk),
		  .clk(clk_slow),
        .reset_n(reset_n),
        .sig_time(sig_time_R),
        .valid_in(sample_valid),
        .dir(dir),
        .t_ltr(t_ltr),
        .t_rtl(t_rtl),
        .sync_start(sync_start),
        .sample_out(sample_R),
        .sample_valid(valid_R)
    );

endmodule