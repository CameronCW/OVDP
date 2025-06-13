module div_by_const ( // Approximate Division using a shift adder
    input  wire [15:0] x,
    input  wire [2:0]  n,    // 3 bits to select N=1..7
    output reg  [15:0] y
);
		// Min adders for >>0.1% resolution, using 4 + 5 +4 +3 = 16 adders (very low hardware)

    wire [15:0] div3, div5, div6, div7;

    // x / 3
    assign div3 = (x >> 2) + (x >> 4) + (x >> 6) + (x >> 8) + (x >> 10);
    // x / 5
    assign div5 = (x >> 3) + (x >> 4) + (x >> 7) + (x >> 8) + (x >> 11) + (x >> 12);
    // x / 6
    assign div6 = (x >> 3) + (x >> 5) + (x >> 7) + (x >> 9) + (x >> 11);
    // x / 7
    assign div7 = (x >> 3) + (x >> 6) + (x >> 9) + (x >> 12);

    always @(*) begin
        case (n)
            3'd1: y = x;
            3'd2: y = x >> 1;
            3'd3: y = div3;
            3'd4: y = x >> 2;
            3'd5: y = div5;
            3'd6: y = div6;
            3'd7: y = div7;
            default: y = 16'd0; // Undefined N
        endcase
    end

endmodule
