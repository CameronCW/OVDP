module pid_controller (
    input wire clk,
    input wire reset,
    input wire signed [15:0] focus_signal,   // e.g., from ADC, 0–1023 centered at 512
    input wire signed [15:0] kp,
    input wire signed [15:0] ki,
    input wire signed [15:0] kd,
    output reg [7:0] pwm_out                 // output to motor or DAC
);

    reg signed [15:0] last_error = 0;
    reg signed [31:0] error_sum = 0;

    wire signed [15:0] focus_error = focus_signal - 16'sd512;
    wire signed [15:0] error_diff = focus_error - last_error;

    wire signed [31:0] p_term = kp * focus_error;
    wire signed [31:0] i_term = ki * error_sum;
    wire signed [31:0] d_term = kd * error_diff;

    wire signed [31:0] pid_output = (p_term + i_term + d_term) >>> 4; // right shift to scale down

    wire signed [8:0] clipped_output = 
        (pid_output + 128 < 0) ? 0 :
        (pid_output + 128 > 255) ? 255 :
        pid_output + 128;

    always @(posedge clk) begin
        if (reset) begin
            error_sum <= 0;
            last_error <= 0;
            pwm_out <= 8'd128;
        end else begin
            error_sum <= error_sum + focus_error;
            last_error <= focus_error;
            pwm_out <= clipped_output[7:0];
        end
    end

endmodule
