// Groove timestamp selector  -  take buffer of 5-8 timestamps per Channel 
	// choose best one (closest to groove in correct ddirection of scan)
	// should remove jitter and issues from noisy signal (no hysteresis)
	// dynamically accounts for scanning frequency variation
	
module groove_sample_selector #(
    parameter SAMPLE_DEPTH = 8            // Up to 8 samples per side
)(
    input  wire        clk,
    input  wire        reset_n,

    input  wire        dir,               // 0 = LTR, 1 = RTL
    input  wire [31:0] current_timestamp,
    input  wire        sig_l_edge,
    input  wire        sig_l_rise,         // 1 if rising edge on SIG_L
    input  wire        sig_r_edge,
    input  wire        sig_r_rise,         // 1 if rising edge on SIG_R
    input  wire        sync_pulse,         // End of sweep signal (LSYNC/RSYNC)

    output reg  [31:0] best_sig_time_L,
    output reg         best_sig_is_rise_L,
    output reg  [31:0] best_sig_time_R,
    output reg         best_sig_is_rise_R,
    output reg         best_sample_valid
);

    // === Internal Buffers ===
    reg [31:0] timestamp_buffer_L [0:SAMPLE_DEPTH-1];
    reg [31:0] timestamp_buffer_R [0:SAMPLE_DEPTH-1];
    reg        edge_polarity_L    [0:SAMPLE_DEPTH-1]; // 1 = rising, 0 = falling
    reg        edge_polarity_R    [0:SAMPLE_DEPTH-1];
    reg [2:0]  sample_count_L;
    reg [2:0]  sample_count_R;

    reg [31:0] last_sync_time;
    reg [31:0] sweep_period;
    reg [31:0] sweep_start_time;

    wire [31:0] sweep_center_time;
    assign sweep_center_time = sweep_start_time + (sweep_period >> 1);

    // === Capture Groove Edges with Polarity ===
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            sample_count_L <= 0;
            sample_count_R <= 0;
        end else begin
            if (sig_l_edge && (sample_count_L < SAMPLE_DEPTH)) begin
                timestamp_buffer_L[sample_count_L] <= current_timestamp;
                edge_polarity_L[sample_count_L]    <= sig_l_rise;
                sample_count_L <= sample_count_L + 1;
            end

            if (sig_r_edge && (sample_count_R < SAMPLE_DEPTH)) begin
                timestamp_buffer_R[sample_count_R] <= current_timestamp;
                edge_polarity_R[sample_count_R]    <= sig_r_rise;
                sample_count_R <= sample_count_R + 1;
            end
        end
    end

    // === Absolute Difference Function ===
    function [31:0] abs_diff;
        input [31:0] a, b;
        begin
            abs_diff = (a > b) ? (a - b) : (b - a);
        end
    endfunction

    // === Best Sample Selection ===
    integer i;
    reg [31:0] best_left_sample;
    reg [31:0] best_right_sample;
    reg        best_left_rise;
    reg        best_right_rise;
    reg [31:0] min_left_distance;
    reg [31:0] min_right_distance;
    reg        left_found;
    reg        right_found;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            best_sig_time_L   <= 32'd0;
            best_sig_is_rise_L<= 1'b0;
            best_sig_time_R   <= 32'd0;
            best_sig_is_rise_R<= 1'b0;
            best_sample_valid <= 1'b0;
            sweep_start_time  <= 32'd0;
            last_sync_time    <= 32'd0;
            sweep_period      <= 32'd0;
        end else if (sync_pulse) begin
            // Measure dynamic sweep period
            sweep_period <= current_timestamp - last_sync_time;
            sweep_start_time <= last_sync_time;
            last_sync_time <= current_timestamp;

            // Default values
            min_left_distance = 32'hFFFFFFFF;
            min_right_distance = 32'hFFFFFFFF;
            left_found = 1'b0;
            right_found = 1'b0;

            // Find best left sample
            for (i = 0; i < sample_count_L; i = i + 1) begin
                if ((dir == 1'b0 && edge_polarity_L[i]) || (dir == 1'b1 && !edge_polarity_L[i])) begin
                    if (abs_diff(timestamp_buffer_L[i], sweep_center_time) < min_left_distance) begin
                        min_left_distance = abs_diff(timestamp_buffer_L[i], sweep_center_time);
                        best_left_sample = timestamp_buffer_L[i];
                        best_left_rise = edge_polarity_L[i];
                        left_found = 1'b1;
                    end
                end
            end

            // Find best right sample
            for (i = 0; i < sample_count_R; i = i + 1) begin
                if ((dir == 1'b1 && edge_polarity_R[i]) || (dir == 1'b0 && !edge_polarity_R[i])) begin
                    if (abs_diff(timestamp_buffer_R[i], sweep_center_time) < min_right_distance) begin
                        min_right_distance = abs_diff(timestamp_buffer_R[i], sweep_center_time);
                        best_right_sample = timestamp_buffer_R[i];
                        best_right_rise = edge_polarity_R[i];
                        right_found = 1'b1;
                    end
                end
            end

            if (left_found && right_found) begin
                best_sig_time_L    <= best_left_sample;
                best_sig_is_rise_L <= best_left_rise;
                best_sig_time_R    <= best_right_sample;
                best_sig_is_rise_R <= best_right_rise;
                best_sample_valid  <= 1'b1;
            end else begin
                best_sample_valid  <= 1'b0;
            end

            // Reset sample counters for next sweep
            sample_count_L <= 0;
            sample_count_R <= 0;
        end else begin
            best_sample_valid <= 1'b0;
        end
    end

endmodule
