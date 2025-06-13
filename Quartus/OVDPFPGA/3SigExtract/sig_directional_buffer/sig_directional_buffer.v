module sig_directional_buffer #(
    parameter DEPTH = 8
)(
    input  wire        clk,
    input  wire        reset_n,

    input  wire        dir,            // 0 = LTR, 1 = RTL
    input  wire [31:0] sig_time,
    input  wire        sig_rise,
    input  wire        sig_fall,

    // Readout interface (optional, or for debug/sample selector)
    output wire [31:0] latest_time,
    output wire        latest_valid,
    output wire        latest_is_rise,
    output wire        latest_is_ltr
);

    // Buffers
    reg [31:0] buf_ltr [0:DEPTH-1];
    reg [31:0] buf_rtl [0:DEPTH-1];
    reg        flag_ltr [0:DEPTH-1];  // 1 = rise, 0 = fall
    reg        flag_rtl [0:DEPTH-1];

    reg [2:0] ptr_ltr = 0;
    reg [2:0] ptr_rtl = 0;

    // Write
    always @(posedge clk) begin
        if (!reset_n) begin
            ptr_ltr <= 0;
            ptr_rtl <= 0;
        end else begin
            if (sig_rise || sig_fall) begin
                if (!dir) begin
                    buf_ltr[ptr_ltr] <= sig_time;
                    flag_ltr[ptr_ltr] <= sig_rise;
                    ptr_ltr <= ptr_ltr + 1;
                end else begin
                    buf_rtl[ptr_rtl] <= sig_time;
                    flag_rtl[ptr_rtl] <= sig_rise;
                    ptr_rtl <= ptr_rtl + 1;
                end
            end
        end
    end

    // Most recent sample output (optional)
    assign latest_time     = (!dir) ? buf_ltr[(ptr_ltr-1) & 3'b111] : buf_rtl[(ptr_rtl-1) & 3'b111];
    assign latest_is_rise  = (!dir) ? flag_ltr[(ptr_ltr-1) & 3'b111] : flag_rtl[(ptr_rtl-1) & 3'b111];
    assign latest_is_ltr   = ~dir;
    assign latest_valid    = ((ptr_ltr != 0) || (ptr_rtl != 0));

endmodule
