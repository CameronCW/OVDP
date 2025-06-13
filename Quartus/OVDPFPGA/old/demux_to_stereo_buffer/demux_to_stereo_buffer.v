module demux_to_stereo_buffer (
    input wire clk,
    input wire reset_n,

    input wire signed [15:0] sample_in,
    input wire valid_in,
    input wire dir,  // 0 = LTR (Left), 1 = RTL (Right)

    output reg signed [15:0] left_sample,
    output reg signed [15:0] right_sample,
    output reg sample_pair_valid  // pulses high when both L & R are updated
);

    reg got_left = 0;
    reg got_right = 0;

    always @(posedge clk) begin
        if (!reset_n) begin
            left_sample <= 0;
            right_sample <= 0;
            got_left <= 0;
            got_right <= 0;
            sample_pair_valid <= 0;
        end else begin
            sample_pair_valid <= 0;

            if (valid_in) begin
                if (dir == 1'b0) begin
                    left_sample <= sample_in;
                    got_left <= 1;
                end else begin
                    right_sample <= sample_in;
                    got_right <= 1;
                end
            end

            if (got_left && got_right) begin
                sample_pair_valid <= 1;
                got_left <= 0;
                got_right <= 0;
            end
        end
    end

endmodule
