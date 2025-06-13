module groove_sample_timestamp (
    input wire clk,
    input wire reset_n,

    // Inputs
    input wire sync_start,
    input wire [31:0] sig_time,
    input wire dir,  // 0 = LTR, 1 = RTL
    input wire [31:0] afll_ltr,
    input wire [31:0] afll_rtl,

    // Outputs
    output reg sample_valid,
    output reg signed [15:0] sample_out
);

    reg [31:0] sync_start_time = 0;
    reg [31:0] scan_duration = 0;
    reg [31:0] position_in_scan = 0;
    reg signed [31:0] normalized_pos;

    reg sync_prev = 0;
    wire sync_rising = sync_start & ~sync_prev;

    always @(posedge clk) begin
        if (!reset_n) begin
            sync_start_time <= 0;
            sample_valid <= 0;
            sample_out <= 0;
            sync_prev <= 0;
        end else begin
            sync_prev <= sync_start;

            if (sync_rising) begin
                // Latch scan start time
                sync_start_time <= sig_time; // or free-running timer
                sample_valid <= 0;
            end else begin
                // SIG position relative to start
                position_in_scan <= sig_time - sync_start_time;

                // Choose scan duration based on direction
                scan_duration <= (dir == 1'b0) ? afll_ltr : afll_rtl;

                // Normalize to signed 16-bit audio sample range
                // formula: ((position / duration) - 0.5) * 65535
                if (scan_duration != 0) begin
                    normalized_pos <= (((position_in_scan << 16) / scan_duration) - 16'sd32768);
                    sample_out <= normalized_pos[15:0];
                    sample_valid <= 1;
                end else begin
                    sample_out <= 0;
                    sample_valid <= 0;
                end
            end
        end
    end

endmodule
