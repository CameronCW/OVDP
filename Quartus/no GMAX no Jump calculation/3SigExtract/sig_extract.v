module sig_extract (
    input  wire        clk,
    input  wire        reset_n,

    input  wire        dir,                 // 0 = LTR, 1 = RTL
    input  wire [31:0] split_sync_time,     // from split_sync_predictor in preProcess

    input  wire [31:0] sig_time_L,
    input  wire        sig_rise_L,
    input  wire        sig_fall_L,

    input  wire [31:0] sig_time_R,
    input  wire        sig_rise_R,
    input  wire        sig_fall_R,

    output reg  [31:0] left_sample_time,
    output reg  [31:0] right_sample_time,
    output reg         sample_pair_valid
);

    // Candidate buffers
    reg [31:0] left_candidate_time;
    reg [31:0] right_candidate_time;
    reg        left_valid = 0;
    reg        right_valid = 0;

    always @(posedge clk) begin
        if (!reset_n) begin
            left_candidate_time  <= 0;
            right_candidate_time <= 0;
            left_sample_time     <= 0;
            right_sample_time    <= 0;
            sample_pair_valid    <= 0;
            left_valid           <= 0;
            right_valid          <= 0;
        end else begin
            sample_pair_valid <= 0;

            if (dir == 1'b0) begin
                // LTR scan
                if (sig_time_L > split_sync_time && sig_rise_L) begin
                    left_candidate_time <= sig_time_L;
                    left_valid <= 1;
                end
                if (sig_time_R > split_sync_time && sig_fall_R) begin
                    right_candidate_time <= sig_time_R;
                    right_valid <= 1;
                end
                if (left_valid && right_valid &&
                    left_candidate_time > right_candidate_time) begin
                    left_sample_time <= left_candidate_time;
                    right_sample_time <= right_candidate_time;
                    sample_pair_valid <= 1;
                    left_valid <= 0;
                    right_valid <= 0;
                end

            end else begin
                // RTL scan
                if (sig_time_L > split_sync_time && sig_fall_L) begin
                    left_candidate_time <= sig_time_L;
                    left_valid <= 1;
                end
                if (sig_time_R > split_sync_time && sig_rise_R) begin
                    right_candidate_time <= sig_time_R;
                    right_valid <= 1;
                end
                if (left_valid && right_valid &&
                    right_candidate_time > left_candidate_time) begin
                    left_sample_time <= left_candidate_time;
                    right_sample_time <= right_candidate_time;
                    sample_pair_valid <= 1;
                    left_valid <= 0;
                    right_valid <= 0;
                end
            end
        end
    end

endmodule
