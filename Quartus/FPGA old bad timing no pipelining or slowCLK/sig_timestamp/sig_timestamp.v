module sig_timestamp (
    input wire clk,
    input wire reset_n,
    input wire sig_edge,      // should be edge-detected externally if needed
    input wire sync_start,    // resets scan timer
    output reg [31:0] sig_time
);
	// tracks sig_time timestamp on either rising or falling sig_edge , reset on SYNC scan
	
    reg [31:0] timer = 0;
    reg sig_prev = 0;
    wire sig_rising = sig_edge & ~sig_prev;

    always @(posedge clk) begin
        if (!reset_n) begin
            timer <= 0;
            sig_time <= 0;
            sig_prev <= 0;
        end else begin
            sig_prev <= sig_edge;

            if (sync_start) begin
                timer <= 0;
            end else begin
                timer <= timer + 1;
            end

            if (sig_rising) begin
                sig_time <= timer;
            end
        end
    end
endmodule
