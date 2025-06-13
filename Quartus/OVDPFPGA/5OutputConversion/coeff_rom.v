module coeff_rom (
    input wire [3:0] phase,      // 0 to 15
    input wire [2:0] tap_index,  // 0 to 7
    output reg signed [15:0] coeff
);

    always @(*) begin
        case (phase)
            4'd0: case (tap_index)
                0: coeff = 16'sd218;   1: coeff = -379;   2: coeff = -2418;  3: coeff = 9643;
                4: coeff = 20288;      5: coeff = 6490;   6: coeff = -953;   7: coeff = -120;
            endcase
            4'd1: case (tap_index)
                0: coeff = 216;    1: coeff = -483;   2: coeff = -2134;  3: coeff = 10584;
                4: coeff = 19996;  5: coeff = 5695;   6: coeff = -1022;  7: coeff = -84;
            endcase
            4'd2: case (tap_index)
                0: coeff = 211;    1: coeff = -582;   2: coeff = -1810;  3: coeff = 11502;
                4: coeff = 19642;  5: coeff = 4927;   6: coeff = -1072;  7: coeff = -49;
            endcase
            4'd3: case (tap_index)
                0: coeff = 203;    1: coeff = -676;   2: coeff = -1447;  3: coeff = 12394;
                4: coeff = 19229;  5: coeff = 4185;   6: coeff = -1104;  7: coeff = -16;
            endcase
            4'd4: case (tap_index)
                0: coeff = 193;    1: coeff = -764;   2: coeff = -1045;  3: coeff = 13257;
                4: coeff = 18758;  5: coeff = 3472;   6: coeff = -1119;  7: coeff = 16;
            endcase
            4'd5: case (tap_index)
                0: coeff = 179;    1: coeff = -844;   2: coeff = -605;   3: coeff = 14088;
                4: coeff = 18233;  5: coeff = 2790;   6: coeff = -1119;  7: coeff = 46;
            endcase
            4'd6: case (tap_index)
                0: coeff = 163;    1: coeff = -917;   2: coeff = -128;   3: coeff = 14884;
                4: coeff = 17656;  5: coeff = 2139;   6: coeff = -1103;  7: coeff = 74;
            endcase
            4'd7: case (tap_index)
                0: coeff = 145;    1: coeff = -980;   2: coeff = 386;    3: coeff = 15641;
                4: coeff = 17030;  5: coeff = 1520;   6: coeff = -1074;  7: coeff = 100;
            endcase
            4'd8: case (tap_index)
                0: coeff = 124;    1: coeff = -1033;  2: coeff = 936;    3: coeff = 16357;
                4: coeff = 16357;  5: coeff = 936;    6: coeff = -1033;  7: coeff = 124;
            endcase
            4'd9: case (tap_index)
                0: coeff = 100;    1: coeff = -1074;  2: coeff = 1520;   3: coeff = 17030;
                4: coeff = 15641;  5: coeff = 386;    6: coeff = -980;   7: coeff = 145;
            endcase
            4'd10: case (tap_index)
                0: coeff = 74;     1: coeff = -1103;  2: coeff = 2139;   3: coeff = 17656;
                4: coeff = 14884;  5: coeff = -128;   6: coeff = -917;   7: coeff = 163;
            endcase
            4'd11: case (tap_index)
                0: coeff = 46;     1: coeff = -1119;  2: coeff = 2790;   3: coeff = 18233;
                4: coeff = 14088;  5: coeff = -605;   6: coeff = -844;   7: coeff = 179;
            endcase
            4'd12: case (tap_index)
                0: coeff = 16;     1: coeff = -1119;  2: coeff = 3472;   3: coeff = 18758;
                4: coeff = 13257;  5: coeff = -1045;  6: coeff = -764;   7: coeff = 193;
            endcase
            4'd13: case (tap_index)
                0: coeff = -16;    1: coeff = -1104;  2: coeff = 4185;   3: coeff = 19229;
                4: coeff = 12394;  5: coeff = -1447;  6: coeff = -676;   7: coeff = 203;
            endcase
            4'd14: case (tap_index)
                0: coeff = -49;    1: coeff = -1072;  2: coeff = 4927;   3: coeff = 19642;
                4: coeff = 11502;  5: coeff = -1810;  6: coeff = -582;   7: coeff = 211;
            endcase
            4'd15: case (tap_index)
                0: coeff = -84;    1: coeff = -1022;  2: coeff = 5695;   3: coeff = 19996;
                4: coeff = 10584;  5: coeff = -2134;  6: coeff = -483;   7: coeff = 216;
            endcase
            default: coeff = 16'sd0;
        endcase
    end

endmodule
