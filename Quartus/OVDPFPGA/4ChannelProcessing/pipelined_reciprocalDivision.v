module pipelined_reciprocal (
    input  wire        clk,        // fast clock (e.g., 100MHz)
    input  wire        clk_slow,   // slow clock (e.g., 5MHz)
    input  wire        reset_n,
    
    input  wire [31:0] scan_duration,      // fast clock input
    output reg  [31:0] reciprocal,         // fast clock output
    output reg         reciprocal_valid   // fast clock valid pulse
);

    // Wires for handshake
    wire [31:0] scan_duration_slow;
    wire        req;
    wire        ack;

    // CDC handshake module instantiation
    cdc_handshake u_cdc_handshake (
        .clk_fast(clk),
        .clk_slow(clk_slow),
        .reset_n(reset_n),
        .scan_duration_in(scan_duration),
        .req_in(req),
        .scan_duration_out(scan_duration_slow),
        .ack_out(ack)
    );

    // Generate request when scan_duration changes (fast domain)
    reg [31:0] scan_duration_reg_fast;
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            scan_duration_reg_fast <= 32'd0;
        end else begin
            scan_duration_reg_fast <= scan_duration;
        end
    end
    assign req = (scan_duration != scan_duration_reg_fast); // New request when input changes

    // Do the division on clk_slow
    reg [31:0] reciprocal_slow;
    reg        reciprocal_valid_slow;

    always @(posedge clk_slow or negedge reset_n) begin
        if (!reset_n) begin
            reciprocal_slow <= 32'd0;
            reciprocal_valid_slow <= 1'b0;
        end else if (ack) begin
            reciprocal_slow <= 32'd32768 / scan_duration_slow;
            reciprocal_valid_slow <= 1'b1;
        end else begin
            reciprocal_valid_slow <= 1'b0;
        end
    end

    // Bring the result back to fast clock (clk domain)
    reg [31:0] reciprocal_reg_fast;
    reg        reciprocal_valid_reg_fast;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            reciprocal <= 32'd0;
            reciprocal_valid <= 1'b0;
        end else begin
            reciprocal <= reciprocal_slow;
            reciprocal_valid <= reciprocal_valid_slow;
        end
    end


endmodule
