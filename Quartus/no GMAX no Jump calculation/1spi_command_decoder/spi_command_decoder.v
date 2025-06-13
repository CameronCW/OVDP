module spi_command_decoder (
    input  wire        clk,
    input  wire        reset_n,

    // SPI streaming interface (e.g., Intel Avalon-ST SPI Slave)
    input  wire [7:0]  stream_data,
    input  wire        stream_valid,

    // PID Control Outputs
    output reg [15:0]  kp,
    output reg [15:0]  ki,
    output reg [15:0]  kd,
    output reg [15:0]  threshold,
    output reg         mute,

    // Output Control
    output reg [7:0]   volume,

    // Focus signal from Teensy
    output reg [15:0]  focus_signal
);

    reg [1:0] state = 0;
    reg [7:0] cmd_id = 0;
    reg [15:0] data_buf = 0;

    localparam IDLE      = 2'd0,
               WAIT_HIGH = 2'd1,
               WAIT_LOW  = 2'd2;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state         <= IDLE;
            cmd_id        <= 8'd0;
            data_buf      <= 16'd0;

            // Default values
            kp            <= 16'd0;
            ki            <= 16'd0;
            kd            <= 16'd0;
            threshold     <= 16'd0;
            volume        <= 8'd255;
            mute          <= 1'b0;
            focus_signal  <= 16'd512;

        end else if (stream_valid) begin
            case (state)
                IDLE: begin
                    cmd_id <= stream_data;
                    state <= WAIT_HIGH;
                end

                WAIT_HIGH: begin
                    data_buf[15:8] <= stream_data;
                    state <= WAIT_LOW;
                end

                WAIT_LOW: begin
                    data_buf[7:0] <= stream_data;
                    state <= IDLE;

                    // Dispatch command
                    case (cmd_id)
                        8'h01: kp            <= data_buf;
                        8'h02: ki            <= data_buf;
                        8'h03: kd            <= data_buf;
                        8'h04: volume        <= data_buf[7:0]; // low byte only
                        8'h06: threshold     <= data_buf;      // 10-bit preferred
                        8'h07: mute          <= data_buf[0];   // LSB only
                        8'h10: focus_signal  <= data_buf;      // raw ADC from Teensy
                        default: ; // no-op
                    endcase
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
