module sig_timestamp (
    input  wire        clk,
    input  wire        reset_n,
    input  wire        sig_edge,      // from comparator output (digital)
    input  wire        sync_start,    // resets scan timer
    output reg [31:0]  sig_time,      // timestamp of detected edge
    output reg         sig_rise,      // high when rising edge
    output reg         sig_fall       // high when falling edge
);

    reg [31:0] timer = 0;
    reg sig_prev = 0;

    always @(posedge clk) begin
        if (!reset_n) begin
            timer     <= 0;
            sig_time  <= 0;
            sig_prev  <= 0;
            sig_rise  <= 0;
            sig_fall  <= 0;
        end else begin
            sig_prev <= sig_edge;

            if (sync_start) begin
                timer <= 0;
            end else begin
                timer <= timer + 1;
            end

            // Edge detection
            sig_rise <= (sig_edge && !sig_prev);
            sig_fall <= (!sig_edge && sig_prev);

            if ((sig_edge && !sig_prev) || (!sig_edge && sig_prev)) begin
                sig_time <= timer;
            end
        end
    end

endmodule
