module split_sync_predictor (
    input  wire clk,
    input  wire reset_n,

    input  wire [31:0] lsync_rise_time,
    input  wire [31:0] lsync_fall_time,
    input  wire [31:0] rsync_rise_time,
    input  wire [31:0] rsync_fall_time,

    input  wire        scan_dir,    // 0 = LTR, 1 = RTL
    input  wire        sync_pulse,  // pulse high when SYNC edge occurs (fall)

    output reg  [31:0] split_sync_time
);

    reg [31:0] lsync_start_frame;
    reg [31:0] rsync_start_frame;
    reg [31:0] prev_rsync_start;
    reg [31:0] prev_lsync_start;

    always @(posedge clk) begin
        if (!reset_n) begin
            split_sync_time   <= 0;
            lsync_start_frame <= 0;
            rsync_start_frame <= 0;
            prev_rsync_start  <= 0;
            prev_lsync_start  <= 0;
        end else if (sync_pulse) begin
            if (scan_dir == 0) begin  // LTR scan completed (SYNC was RSYNC_fall)
                lsync_start_frame <= (lsync_rise_time + lsync_fall_time) >> 1;
                split_sync_time   <= prev_rsync_start + (prev_rsync_start - lsync_start_frame);
                prev_lsync_start  <= lsync_start_frame;
            end else begin  // RTL scan completed (SYNC was LSYNC_fall)
                rsync_start_frame <= (rsync_rise_time + rsync_fall_time) >> 1;
                split_sync_time   <= prev_lsync_start + (prev_lsync_start - rsync_start_frame);
                prev_rsync_start  <= rsync_start_frame;
            end
        end
    end

endmodule
