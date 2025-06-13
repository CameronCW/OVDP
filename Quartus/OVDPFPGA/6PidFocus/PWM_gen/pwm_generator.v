module pwm_generator #(
    parameter RESOLUTION = 8  // Number of bits in the counter (8 = 256 steps)
)(
    input  wire clk,
    input  wire reset_n,

    input  wire [RESOLUTION-1:0] duty,  // Duty cycle input (e.g., 0–255)
    output reg  pwm_out
);

    reg [RESOLUTION-1:0] counter;

    always @(posedge clk) begin
        if (!reset_n) begin
            counter <= 0;
            pwm_out <= 0;
        end else begin
            counter <= counter + 1;
            pwm_out <= (counter < duty);
        end
    end

endmodule
