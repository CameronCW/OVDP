module pid_controller_wrapper (
    input wire clk,
    input wire reset_n,

    // Avalon-MM slave interface
    input wire [2:0] address,
    input wire [15:0] writedata,
    input wire write,
    input wire chipselect,
    output reg [15:0] readdata,

    // External signal in
    input wire signed [15:0] focus_signal,
    // External control out
    output wire [7:0] pwm_out
);

    // Internal PID gain registers
    reg signed [15:0] kp, ki, kd;

    // Register write logic
    always @(posedge clk) begin
        if (!reset_n) begin
            kp <= 0;
            ki <= 0;
            kd <= 0;
        end else if (chipselect && write) begin
            case (address)
                3'd0: kp <= writedata;
                3'd1: ki <= writedata;
                3'd2: kd <= writedata;
            endcase
        end
    end

    //reading values back
    always @(*) begin
        case (address)
            3'd0: readdata = kp;
            3'd1: readdata = ki;
            3'd2: readdata = kd;
            default: readdata = 16'h0000;
        endcase
    end

    // Instantiate the actual PID controller core in HorizontalPID
    pid_controller u_pid (
        .clk(clk),
        .reset(~reset_n),
        .focus_signal(focus_signal),
        .kp(kp),
        .ki(ki),
        .kd(kd),
        .pwm_out(pwm_out)
    );

endmodule
