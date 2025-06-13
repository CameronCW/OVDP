module afll (
    input wire clk,             // 100 MHz system clock
    input wire reset_n,         // active-low reset
    input wire sync_start,      // sync pulse from scanner (e.g., LSYNC or RSYNC)
    input wire scan_dir,        // 0 = LTR, 1 = RTL
    output reg [31:0] t_ltr,    // estimated scan time LTR in clock ticks as 100MHz clock
    output reg [31:0] t_rtl     // estimated scan time RTL
);

// Adaptive Frequency Lock Loop

    parameter THRESHOLD = 32'd5000;

    reg [31:0] timer = 0;
    reg [31:0] last_start = 0;
    reg [31:0] dot_ltr = 0;
    reg [31:0] dot_rtl = 0;
    reg sync_prev = 0;
    wire sync_rising = sync_start & ~sync_prev;

    always @(posedge clk) begin
        sync_prev <= sync_start;

        if (!reset_n) begin
            t_ltr <= 32'd0;
            t_rtl <= 32'd0;
            timer <= 32'd0;
        end else begin
            timer <= timer + 1;

            if (sync_rising) begin
                if (scan_dir == 1'b0) begin
                    // LTR scan
                    dot_ltr <= timer - last_start;
                    last_start <= timer;
                    if ((dot_ltr > t_ltr + THRESHOLD) || (dot_ltr < t_ltr - THRESHOLD)) begin
                        t_ltr <= dot_ltr;
                    end else if (dot_ltr > t_ltr) begin
                        t_ltr <= t_ltr + 1;
                    end else if (dot_ltr < t_ltr) begin
                        t_ltr <= t_ltr - 1;
                    end
                end else begin
                    // RTL scan
                    dot_rtl <= timer - last_start;
                    last_start <= timer;
                    if ((dot_rtl > t_rtl + THRESHOLD) || (dot_rtl < t_rtl - THRESHOLD)) begin
                        t_rtl <= dot_rtl;
                    end else if (dot_rtl > t_rtl) begin
                        t_rtl <= t_rtl + 1;
                    end else if (dot_rtl < t_rtl) begin
                        t_rtl <= t_rtl - 1;
                    end
                end
            end
        end
    end

endmodule
