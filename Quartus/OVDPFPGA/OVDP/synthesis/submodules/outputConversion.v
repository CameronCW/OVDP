module output_conversion (
    input  wire        clk,
    input  wire        reset_n,

    // Filtered input samples (27.4kHz)
    input  wire signed [15:0] sample_L,
    input  wire               valid_L,
    input  wire signed [15:0] sample_R,
    input  wire               valid_R,

    // Control
    input  wire [7:0]  volume,
    input  wire        mute,

    // Upsampled + volume-scaled output (44.1kHz)
    output reg signed [15:0] out_L,
    output reg signed [15:0] out_R,
    output reg               valid_out
);

    // Internal signals
    wire signed [15:0] up_L, up_R;
    wire valid_up_L, valid_up_R;

    // === Left Channel Upsampler ===
    polyphase_upsampler up_left (
        .clk(clk),
        .reset_n(reset_n),
        .in_sample(sample_L),
        .valid_in(valid_L),
        .out_sample(up_L),
        .valid_out(valid_up_L)
    );

    // === Right Channel Upsampler ===
    polyphase_upsampler up_right (
        .clk(clk),
        .reset_n(reset_n),
        .in_sample(sample_R),
        .valid_in(valid_R),
        .out_sample(up_R),
        .valid_out(valid_up_R)
    );

    // === Volume and sync ===
    wire signed [23:0] scaled_L = (mute) ? 24'sd0 : (up_L * volume);
    wire signed [23:0] scaled_R = (mute) ? 24'sd0 : (up_R * volume);

    always @(posedge clk) begin
        if (!reset_n) begin
            out_L <= 0;
            out_R <= 0;
            valid_out <= 0;
        end else if (valid_up_L && valid_up_R) begin
            out_L <= scaled_L >>> 8;
            out_R <= scaled_R >>> 8;
            valid_out <= 1;
        end else begin
            valid_out <= 0;
        end
    end

endmodule
