	// pid top , stays in 100MHz domain
module pid_focus_controller (
    input  wire clk,           // 100 MHz fast domain
    input  wire clk_slow,      // 5 MHz slow domain
    input  wire reset_n,

    input  wire signed [15:0] focus_signal,
    input  wire signed [15:0] kp,
    input  wire signed [15:0] ki,
    input  wire signed [15:0] kd,
    input  wire signed [15:0] threshold,

    output wire pwm_out        // Real PWM signal output
);

    // === CDC Double Flop Synchronization to clk_slow ===
    reg signed [15:0] focus_signal_sync1, focus_signal_sync2;
    reg signed [15:0] kp_sync1, kp_sync2;
    reg signed [15:0] ki_sync1, ki_sync2;
    reg signed [15:0] kd_sync1, kd_sync2;
    reg signed [15:0] threshold_sync1, threshold_sync2;

    always @(posedge clk_slow or negedge reset_n) begin
        if (!reset_n) begin
            focus_signal_sync1 <= 16'd0;
            focus_signal_sync2 <= 16'd0;
            kp_sync1 <= 16'd0;
            kp_sync2 <= 16'd0;
            ki_sync1 <= 16'd0;
            ki_sync2 <= 16'd0;
            kd_sync1 <= 16'd0;
            kd_sync2 <= 16'd0;
            threshold_sync1 <= 16'd0;
            threshold_sync2 <= 16'd0;
        end else begin
            focus_signal_sync1 <= focus_signal;
            focus_signal_sync2 <= focus_signal_sync1;

            kp_sync1 <= kp;
            kp_sync2 <= kp_sync1;

            ki_sync1 <= ki;
            ki_sync2 <= ki_sync1;

            kd_sync1 <= kd;
            kd_sync2 <= kd_sync1;

            threshold_sync1 <= threshold;
            threshold_sync2 <= threshold_sync1;
        end
    end

    wire signed [15:0] focus_signal_slow = focus_signal_sync2;
    wire signed [15:0] kp_slow = kp_sync2;
    wire signed [15:0] ki_slow = ki_sync2;
    wire signed [15:0] kd_slow = kd_sync2;
    wire signed [15:0] threshold_slow = threshold_sync2;

    wire [7:0] pwm_duty_slow;	

    // PID Controller — purely in clk_slow domain
    pid_controller u_pid (
        .clk(clk_slow),
        .reset_n(reset_n),
        .focus_signal(focus_signal_slow),
        .kp(kp_slow),
        .ki(ki_slow),
        .kd(kd_slow),
        .threshold(threshold_slow),
        .pwm_out(pwm_duty_slow)
    );

    // === CDC Double-Flop Synchronization to clk_sys for PWM duty ===
    reg [7:0] pwm_duty_sync1, pwm_duty_sync2;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            pwm_duty_sync1 <= 8'd128;
            pwm_duty_sync2 <= 8'd128;
        end else begin
            pwm_duty_sync1 <= pwm_duty_slow;
            pwm_duty_sync2 <= pwm_duty_sync1;
        end
    end

    // === PWM Generator in clk_sys domain ===
    pwm_generator #(8) u_pwm_generator (
        .clk(clk),
        .reset_n(reset_n),
        .duty(pwm_duty_sync2),
        .pwm_out(pwm_out)
    );

endmodule
