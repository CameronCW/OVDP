module pid_focus_controller (
    input  wire        clk,
    input  wire        reset_n,

    input  wire signed [15:0] focus_signal,
    input  wire signed [15:0] kp,
    input  wire signed [15:0] ki,
    input  wire signed [15:0] kd,
    input  wire signed [15:0] threshold,

    output wire [7:0] pwm_out
);

    wire signed [15:0] raw_error;
    wire signed [15:0] focus_error;

    assign raw_error = focus_signal - 16'sd512;

    // Apply deadband threshold
    assign focus_error = (raw_error > threshold || raw_error < -threshold) ? raw_error : 16'sd0;

    wire [7:0] pwm_val;

    // PID Controller
    pid_controller u_pid (
        .clk(clk),
        .reset(~reset_n),
        .focus_signal(focus_error),
        .kp(kp),
        .ki(ki),
        .kd(kd),
        .pwm_out(pwm_val)
    );

    // PWM Generator (same RESOLUTION as PID output scale)
    assign pwm_out = pwm_val;

endmodule
