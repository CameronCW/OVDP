module i2s_tx (
    input wire clk,                // Master clock (MCLK): e.g., 12.288 MHz
    input wire reset_n,

    input wire [15:0] left_sample,
    input wire [15:0] right_sample,
    input wire sample_valid,       // pulse once per stereo sample

    output reg i2s_bclk,
    output reg i2s_lrclk,
    output reg i2s_data
);

    reg [4:0] bit_cnt = 0;
    reg [15:0] shift_reg = 0;
    reg [1:0] state = 0;

    localparam S_IDLE = 2'd0,
               S_LEFT = 2'd1,
               S_RIGHT = 2'd2;

    reg [15:0] left_buf = 0;
    reg [15:0] right_buf = 0;
    reg bclk_div = 0;

    always @(posedge clk) begin
        if (!reset_n) begin
            state <= S_IDLE;
            bit_cnt <= 0;
            shift_reg <= 0;
            i2s_bclk <= 0;
            i2s_lrclk <= 0;
            i2s_data <= 0;
        end else begin
            // Generate BCLK at clk/2 (for demo, adjust via PLL for exact timing)
            bclk_div <= ~bclk_div;
            if (bclk_div) i2s_bclk <= ~i2s_bclk;

            // Only process on rising BCLK
            if (bclk_div && i2s_bclk) begin
                case (state)
                    S_IDLE: begin
                        if (sample_valid) begin
                            left_buf <= left_sample;
                            right_buf <= right_sample;
                            shift_reg <= left_sample;
                            bit_cnt <= 15;
                            i2s_lrclk <= 0; // Left
                            state <= S_LEFT;
                        end
                    end

                    S_LEFT: begin
                        i2s_data <= shift_reg[15];
                        shift_reg <= shift_reg << 1;
                        if (bit_cnt == 0) begin
                            shift_reg <= right_buf;
                            bit_cnt <= 15;
                            i2s_lrclk <= 1; // Right
                            state <= S_RIGHT;
                        end else begin
                            bit_cnt <= bit_cnt - 1;
                        end
                    end

                    S_RIGHT: begin
                        i2s_data <= shift_reg[15];
                        shift_reg <= shift_reg << 1;
                        if (bit_cnt == 0) begin
                            i2s_lrclk <= 0;
                            state <= S_IDLE;
                        end else begin
                            bit_cnt <= bit_cnt - 1;
                        end
                    end

                    default: state <= S_IDLE;
                endcase
            end
        end
    end

endmodule
