module pid_controller (
    input wire clk,               // Slow clock (5 MHz)
    input wire reset_n,            // Active-low reset
    input wire signed [15:0] focus_signal,
    input wire signed [15:0] kp,
    input wire signed [15:0] ki,
    input wire signed [15:0] kd,
    input wire signed [15:0] threshold,

    output reg [7:0] pwm_out
);

    reg signed [15:0] last_error = 16'd0;
    reg signed [31:0] error_sum = 32'd0;

    wire signed [15:0] raw_error = focus_signal - 16'sd512;

    // Deadband
    wire signed [15:0] focus_error = 
        (raw_error > threshold || raw_error < -threshold) ? raw_error : 16'sd0;

    wire signed [15:0] error_diff = focus_error - last_error;

    wire signed [31:0] p_term = kp * focus_error;
    wire signed [31:0] i_term = ki * error_sum;
    wire signed [31:0] d_term = kd * error_diff;

    wire signed [31:0] pid_output = (p_term + i_term + d_term) >>> 4;

    wire signed [8:0] clipped_output = 
        (pid_output + 128 < 0) ? 9'd0 :
        (pid_output + 128 > 9'd255) ? 9'd255 :
        pid_output + 128;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            error_sum <= 32'd0;
            last_error <= 16'd0;
            pwm_out <= 8'd128;     // Midpoint PWM on reset
        end else begin
            error_sum <= error_sum + focus_error;
            last_error <= focus_error;
            pwm_out <= clipped_output[7:0];
        end
    end

endmodule
