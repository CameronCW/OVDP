module sample_selector (
    input  wire        clk,
    input  wire        reset_n,

    input  wire        dir,               // 0 = LTR, 1 = RTL
    input  wire [31:0] split_sync_time,   // predicted scan boundary

    // Incoming SIG edge event
    input  wire [31:0] sig_time,
    input  wire        sig_is_rise,
    input  wire        sig_is_ltr,       // 1 = SIG from LTR buffer
    input  wire        sig_valid,

    // Output: selected stereo sample pair
    output reg  [31:0] left_sample_time,
    output reg  [31:0] right_sample_time,
    output reg         sample_pair_valid
);

    // Internal candidates
    reg [31:0] left_candidate_time;
    reg [31:0] right_candidate_time;
    reg        left_valid;
    reg        right_valid;

    always @(posedge clk) begin
        if (!reset_n) begin
            left_candidate_time  <= 0;
            right_candidate_time <= 0;
            left_valid  <= 0;
            right_valid <= 0;
            left_sample_time <= 0;
            right_sample_time <= 0;
            sample_pair_valid <= 0;

        end else begin
            sample_pair_valid <= 0;

            if (sig_valid) begin
                // Only process events after split_sync
                if (sig_time > split_sync_time) begin

                    if (dir == 1'b0) begin
                        // LTR scan
                        if (sig_is_ltr && sig_is_rise) begin
                            // Left candidate (rising)
                            left_candidate_time <= sig_time;
                            left_valid <= 1;
                        end else if (!sig_is_ltr && !sig_is_rise) begin
                            // Right candidate (falling)
                            right_candidate_time <= sig_time;
                            right_valid <= 1;
                        end

                        // Check if valid stereo pair (left after right)
                        if (left_valid && right_valid &&
                            left_candidate_time > right_candidate_time) begin
                            left_sample_time <= left_candidate_time;
                            right_sample_time <= right_candidate_time;
                            sample_pair_valid <= 1;

                            left_valid  <= 0;
                            right_valid <= 0;
                        end

                    end else begin
                        // RTL scan
                        if (!sig_is_ltr && sig_is_rise) begin
                            // Right candidate (rising)
                            right_candidate_time <= sig_time;
                            right_valid <= 1;
                        end else if (sig_is_ltr && !sig_is_rise) begin
                            // Left candidate (falling)
                            left_candidate_time <= sig_time;
                            left_valid <= 1;
                        end

                        // Check if valid stereo pair (right after left)
                        if (left_valid && right_valid &&
                            right_candidate_time > left_candidate_time) begin
                            left_sample_time <= left_candidate_time;
                            right_sample_time <= right_candidate_time;
                            sample_pair_valid <= 1;

                            left_valid  <= 0;
                            right_valid <= 0;
                        end
                    end
                end
            end
        end
    end

endmodule
