module volume_control (
    input wire clk,
    input wire reset_n,

    input wire signed [15:0] in_sample,
    input wire [7:0] volume,
    input wire mute,  // 1 = muted

    output reg signed [15:0] out_sample
);

    reg signed [23:0] scaled;

    always @(posedge clk) begin
        if (!reset_n) begin
            out_sample <= 0;
        end else if (mute) begin
            out_sample <= 0;
        end else begin
            scaled <= (in_sample * volume);
            out_sample <= scaled >>> 8;
        end
    end

endmodule
