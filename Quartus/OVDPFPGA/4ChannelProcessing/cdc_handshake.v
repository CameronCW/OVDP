// CDC Handshake Module: Fast to Slow Clock Domain
module cdc_handshake (
    input  wire        clk_fast,     // Source clock (100 MHz)
    input  wire        clk_slow,     // Destination clock (5 MHz)
    input  wire        reset_n,      // Active-low reset

    input  wire [31:0] scan_duration_in,  // Value to transfer
    input  wire        req_in,            // Request signal (1-cycle pulse)

    output reg  [31:0] scan_duration_out, // Received value in slow clock
    output reg         ack_out            // Acknowledge back
);

    // Synchronizer registers
    reg req_sync1, req_sync2, req_sync3;
    reg [31:0] scan_duration_buf;

    // Fast domain logic (latches data on request)
    always @(posedge clk_fast or negedge reset_n) begin
        if (!reset_n) begin
            scan_duration_buf <= 32'd0;
        end else if (req_in) begin
            scan_duration_buf <= scan_duration_in;
        end
    end

    // CDC synchronization
    always @(posedge clk_slow or negedge reset_n) begin
        if (!reset_n) begin
            req_sync1 <= 1'b0;
            req_sync2 <= 1'b0;
            req_sync3 <= 1'b0;
            ack_out   <= 1'b0;
        end else begin
            req_sync1 <= req_in;         // First FF
            req_sync2 <= req_sync1;      // Second FF
            req_sync3 <= req_sync2;      // Third FF (optional, cleaner CDC)

            // Edge detection
            if (req_sync2 & ~req_sync3) begin
                scan_duration_out <= scan_duration_buf;
                ack_out <= 1'b1;
            end else begin
                ack_out <= 1'b0;
            end
        end
    end

endmodule
