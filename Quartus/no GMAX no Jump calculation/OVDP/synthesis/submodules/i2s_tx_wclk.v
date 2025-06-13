module i2s_transmitter (
    input  wire        clk,          // 100 MHz system clock
    input  wire        reset_n,

    input  wire signed [15:0] sample_L,
    input  wire signed [15:0] sample_R,
    input  wire        valid_in,     // Pulse high when sample pair is ready

    output reg         bclk,         // Bit clock
    output reg         lrclk,        // Word select (left/right)
    output reg         sdata         // Serial audio data
);

    reg [7:0] clk_div = 0;
    reg [5:0] bit_cnt = 0;
    reg [31:0] shift_reg = 0;
    reg       transmitting = 0;

    // === BCLK Generation: Divide 100 MHz to ~3.125 MHz (~64x 48kHz)
    always @(posedge clk) begin
        if (!reset_n) begin
            clk_div <= 0;
            bclk <= 0;
        end else begin
            clk_div <= clk_div + 1;
            if (clk_div == 15) begin
                clk_div <= 0;
                bclk <= ~bclk;
            end
        end
    end

    wire bclk_posedge = (clk_div == 15 && bclk == 0);

    // === Data logic
    always @(posedge clk) begin
        if (!reset_n) begin
            bit_cnt <= 0;
            shift_reg <= 0;
            lrclk <= 0;
            sdata <= 0;
            transmitting <= 0;
        end else if (valid_in && !transmitting) begin
            // Load new sample pair into shift register
            shift_reg <= {sample_L, sample_R};  // L then R
            bit_cnt <= 0;
            lrclk <= 0;          // Start with left channel
            transmitting <= 1;
        end else if (transmitting && bclk_posedge) begin
            sdata <= shift_reg[31];
            shift_reg <= {shift_reg[30:0], 1'b0};
            bit_cnt <= bit_cnt + 1;

            // Toggle LRCLK at midpoint (after 16 bits)
            if (bit_cnt == 15)
                lrclk <= 1;
            if (bit_cnt == 31) begin
                transmitting <= 0;
                lrclk <= 0;
            end
        end
    end

endmodule
