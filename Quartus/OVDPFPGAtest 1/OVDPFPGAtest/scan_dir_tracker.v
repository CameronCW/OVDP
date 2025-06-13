module scan_dir_tracker (
    input  wire clk,
    input  wire reset_n,
    input  wire sync_start,

    output reg dir  // 0 = LTR, 1 = RTL
);

initial dir = 1'b0;
    always @(posedge clk) begin
        if (!reset_n)
            dir <= 1'b0;  // Initialize to LTR or RTL — your choice
        else if (sync_start)
            dir <= ~dir;  // Toggle every scan
    end

endmodule
