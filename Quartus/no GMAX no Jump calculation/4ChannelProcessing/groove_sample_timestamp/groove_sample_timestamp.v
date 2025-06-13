module groove_sample_timestamp (
    input wire clk,          // 100 MHz clock
    input wire clk_slow,     // 5 MHz clock
    input wire reset_n,

    // Inputs
    input wire sync_start,
    input wire [31:0] sig_time,
    input wire dir,              // 0 = LTR, 1 = RTL
    input wire [31:0] afll_ltr,   // t_ltr
    input wire [31:0] afll_rtl,   // t_rtl

    // Outputs
    output reg sample_valid,
    output reg signed [15:0] sample_out
);

    reg [31:0] sync_start_time;
    reg [31:0] position_in_scan;
    reg signed [31:0] normalized_pos;
    wire [31:0] scan_duration;

    // New: Wires for CDC handshake
    reg  req;
    wire ack;
    wire [31:0] scan_duration_slow;

    // New: Wire up reciprocal and valid (calculated in slow domain)
    wire [31:0] reciprocal;
    wire        reciprocal_valid;

    assign scan_duration = (dir == 1'b0) ? afll_ltr : afll_rtl;

    // Generate a request when scan_duration changes
    reg [31:0] scan_duration_last;
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            req <= 1'b0;
            scan_duration_last <= 32'd0;
        end else if (scan_duration != scan_duration_last) begin
            req <= 1'b1;
            scan_duration_last <= scan_duration;
        end else if (ack) begin
            req <= 1'b0;
        end
    end

    // Instantiate the CDC handshake (clk_fast -> clk_slow)
    cdc_handshake u_cdc_handshake (
         .clk_fast(clk),           // 100 MHz
         .clk_slow(clk_slow),      // 5 MHz
         .reset_n(reset_n),
         .scan_duration_in(scan_duration),
         .req_in(req),
         .scan_duration_out(scan_duration_slow),
         .ack_out(ack)
    );

    // === Slow Clock Domain: Reciprocal Calculation ===
    pipelined_reciprocal u_reciprocal (
        .clk(clk_slow),             // Slow clock now
        .reset_n(reset_n),
        .scan_duration(scan_duration_slow),
        .reciprocal(reciprocal),
        .reciprocal_valid(reciprocal_valid)
    );

    // === Fast Clock Domain: Sample Calculation ===
    always @(posedge clk) begin
        if (!reset_n) begin
            sync_start_time <= 32'd0;
            sample_valid    <= 1'b0;
            sample_out      <= 16'd0;
        end else begin
            if (sync_start) begin
                sync_start_time <= sig_time;
                sample_valid <= 1'b0;
            end else if (reciprocal_valid) begin
                position_in_scan <= sig_time - sync_start_time;

                // Multiply by precomputed reciprocal
                normalized_pos <= ((position_in_scan * reciprocal) >>> 1) - 32'sd32768;
                sample_out <= normalized_pos[15:0];
                sample_valid <= 1'b1;
            end else begin
                sample_valid <= 1'b0;
            end
        end
    end

endmodule
