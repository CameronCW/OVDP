module preprocess_block (
    input  wire        clk,
    input  wire        reset_n,

    // Digital comparator inputs
    input  wire        lsync,     // left sync pulse
    input  wire        rsync,     // right sync pulse
    input  wire        sig,       // groove edge pulse

    // Direction outputs (separate for conduit use)
    output wire        dir,       // to sig_extract
    output wire        dir_cp,    // to channel_processor

    // Outputs to Mono SIG Extract
    output wire [31:0] sig_time_L,
    output wire        sig_rise_L,
    output wire        sig_fall_L,
    output wire [31:0] sig_time_R,
    output wire        sig_rise_R,
    output wire        sig_fall_R,

    output wire [31:0] t_ltr,
    output wire [31:0] t_rtl,
    output wire [31:0] split_sync_time,
    output wire        sync_start
);

    // === Free-running timer for timestamping used for sync_start
    reg [31:0] timer;
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            timer <= 0;
        else
            timer <= timer + 1;
    end

    // === SYNC edge detection
    reg lsync_prev, rsync_prev;
    wire lsync_rise = lsync & ~lsync_prev;
    wire lsync_fall = ~lsync & lsync_prev;
    wire rsync_rise = rsync & ~rsync_prev;
    wire rsync_fall = ~rsync & rsync_prev;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            lsync_prev <= 0;
            rsync_prev <= 0;
        end else begin
            lsync_prev <= lsync;
            rsync_prev <= rsync;
        end
    end

    // === SYNC timestamp registers
    reg [31:0] lsync_rise_time, lsync_fall_time;
    reg [31:0] rsync_rise_time, rsync_fall_time;

    always @(posedge clk) begin
        if (lsync_rise)
            lsync_rise_time <= timer;
        if (lsync_fall)
            lsync_fall_time <= timer;
        if (rsync_rise)
            rsync_rise_time <= timer;
        if (rsync_fall)
            rsync_fall_time <= timer;
    end

    // === SYNC midpoint logic (sync_start pulse)
    reg        sync_start_reg;
    assign     sync_start = sync_start_reg;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            sync_start_reg <= 0;
        else
            sync_start_reg <= lsync_fall | rsync_fall;  // pulse on either SYNC falling
    end

    // === dir FSM (RTL or LTR)
    wire dir_internal;
    scan_dir_tracker u_dir (
        .clk(clk),
        .reset_n(reset_n),
        .sync_start(sync_start),
        .dir(dir_internal)
    );

    assign dir   = dir_internal;
    assign dir_cp = dir_internal;

    // === SIG timestampers
    sig_timestamp u_sig_L (
        .clk(clk),
        .reset_n(reset_n),
        .sig_edge(sig),
        .sync_start(sync_start),
        .sig_time(sig_time_L),
        .sig_rise(sig_rise_L),
        .sig_fall(sig_fall_L)
    );

    sig_timestamp u_sig_R (
        .clk(clk),
        .reset_n(reset_n),
        .sig_edge(sig),
        .sync_start(sync_start),
        .sig_time(sig_time_R),
        .sig_rise(sig_rise_R),
        .sig_fall(sig_fall_R)
    );

    // === Adaptive FLL
    afll u_afll (
        .clk(clk),
        .reset_n(reset_n),
        .sync_start(sync_start),
        .scan_dir(dir_internal),
        .t_ltr(t_ltr),
        .t_rtl(t_rtl)
    );

    // === Split Sync Predictor
    split_sync_predictor u_split_sync (
        .clk(clk),
        .reset_n(reset_n),
        .lsync_rise_time(lsync_rise_time),
        .lsync_fall_time(lsync_fall_time),
        .rsync_rise_time(rsync_rise_time),
        .rsync_fall_time(rsync_fall_time),
        .scan_dir(dir_internal),
        .sync_pulse(sync_start),
        .split_sync_time(split_sync_time)
    );

endmodule
