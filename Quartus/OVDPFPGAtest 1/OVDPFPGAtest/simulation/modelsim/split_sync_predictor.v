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
	 initial lsync_start_frame = 32'd4000;
	 initial rsync_start_frame = 32'd2000;
	 initial prev_rsync_start = 32'b0;
	 initial prev_lsync_start = 32'b0;

    always @(posedge clk) begin
        if (!reset_n) begin
            split_sync_time   <= 'd0;		//'d2000;
            lsync_start_frame <= 0;
            rsync_start_frame <= 0;
            prev_rsync_start  <= 'd0;		//d8109
            prev_lsync_start  <= 'd0;
        end else if (sync_pulse) begin
            if (lsync_rise_time - rsync_rise_time < 32'h80000000) begin  // LTR scan completed (SYNC was RSYNC_fall)
                lsync_start_frame <= lsync_rise_time + ((lsync_fall_time - lsync_rise_time) >> 1);
//                split_sync_time   <= prev_rsync_start + (prev_rsync_start - lsync_start_frame);
					 split_sync_time   <= lsync_rise_time + ((lsync_fall_time - lsync_rise_time) >> 1) + ((lsync_rise_time + ((lsync_fall_time - lsync_rise_time) >> 1) - lsync_start_frame)>>1);
                //prev_lsync_start  <= lsync_start_frame;
            end else begin  // RTL scan completed (SYNC was LSYNC_fall)
                rsync_start_frame <= rsync_rise_time + ((rsync_fall_time - rsync_rise_time) >> 1);
                // split_sync_time   <= prev_lsync_start + (prev_lsync_start - rsync_start_frame);
					 split_sync_time   <= rsync_rise_time + ((rsync_fall_time - rsync_rise_time) >> 1) + ((rsync_rise_time + ((rsync_fall_time - rsync_rise_time) >> 1) - rsync_start_frame)>>1);
                //prev_rsync_start  <= rsync_start_frame;
            end
        end
    end

endmodule
