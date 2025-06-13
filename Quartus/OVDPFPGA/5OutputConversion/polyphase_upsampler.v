module polyphase_upsampler (
    input wire clk,
    input wire reset_n,

    // Input sample stream @ 27.4kHz
    input wire signed [15:0] in_sample,
    input wire               valid_in,     // Needed to update buffer and phase

    // Output sample stream @ ~44.1kHz
    output reg signed [15:0] out_sample,
	 output reg valid_out
);

    parameter UPSAMPLE_NUM = 274;
    parameter UPSAMPLE_DEN = 170; // 274 / 170 ≈ 1.61176

    // Phase accumulator
    reg [15:0] phase_accum = 0;
    wire [3:0] phase_index = phase_accum[15:12]; // Top 4 bits = 16 phases

    // Circular buffer for 8 samples
    reg signed [15:0] sample_buf [0:7];
    reg [2:0] wr_ptr = 0;

    // Coefficient ROM
    wire signed [15:0] coeff;
    reg [2:0] tap_index;

    coeff_rom coeffs (
        .phase(phase_index),
        .tap_index(tap_index),
        .coeff(coeff)
    );

    // MAC accumulator
    reg signed [31:0] acc = 0;
    reg [2:0] mac_ptr = 0;
    reg [2:0] rd_index = 0;
    reg signed [15:0] sample_val;
    reg mac_active = 0;

    always @(posedge clk) begin
			valid_out <= 0;
        if (!reset_n) begin
            wr_ptr <= 0;
            mac_ptr <= 0;
            phase_accum <= 0;
            mac_active <= 0;
            acc <= 0;
            out_sample <= 0;
        end else begin
            if (valid_in) begin
                sample_buf[wr_ptr] <= in_sample;
                wr_ptr <= wr_ptr + 1;
                phase_accum <= phase_accum + UPSAMPLE_NUM;
            end

            if (!mac_active && (phase_accum >= UPSAMPLE_DEN)) begin
                mac_active <= 1;
                mac_ptr <= 0;
                acc <= 0;
            end

            if (mac_active) begin
                tap_index <= mac_ptr;
                rd_index <= wr_ptr - mac_ptr - 1;
                sample_val <= sample_buf[rd_index & 3'b111];

                acc <= acc + sample_val * coeff;
                mac_ptr <= mac_ptr + 1;

                if (mac_ptr == 7) begin
							valid_out <= 1;
							mac_active <= 0;
							out_sample <= acc[30:15];  // Scale Q1.15 to int16
							phase_accum <= phase_accum - UPSAMPLE_DEN;
                end

            end
        end
    end

endmodule
