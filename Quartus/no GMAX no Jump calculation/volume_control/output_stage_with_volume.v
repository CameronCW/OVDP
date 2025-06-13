module output_stage_with_volume (
    input wire clk,
    input wire reset_n,

    // Inputs from demux
    input wire signed [15:0] left_sample,
    input wire signed [15:0] right_sample,
    input wire mute,

    // Volume control
    input wire [7:0] volume,

    // Final outputs
    output wire signed [15:0] audio_left,
    output wire signed [15:0] audio_right
);

    wire valid_left, valid_right;

    volume_control volume_left (
        .clk(clk),
        .reset_n(reset_n),
        .in_sample(left_sample),
        .volume(volume),
        .out_sample(audio_left),
        .mute(mute)
    );

    volume_control volume_right (
        .clk(clk),
        .reset_n(reset_n),
        .in_sample(right_sample),
        .volume(volume),
        .out_sample(audio_right),
        .mute(mute)
    );

    // no valid neeeded
    // assign valid_out = valid_right;

endmodule
