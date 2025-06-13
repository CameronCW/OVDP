module scan_cycle_controller (
    input wire clk,
    input wire reset_n,
    input wire sync_start,
    input wire sig_l_detected,
    input wire sig_r_detected,

    output reg dir,
    output reg sig_l_enable,
    output reg sig_r_enable
);

    reg sync_prev;
    wire sync_rising;
    assign sync_rising = sync_start & ~sync_prev;

    // Simple FSM states
    reg [1:0] state;

    parameter IDLE     = 2'd0;
    parameter WAIT_L   = 2'd1;
    parameter WAIT_R   = 2'd2;
    parameter COMPLETE = 2'd3;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            sync_prev <= 0;
            dir <= 0;
            sig_l_enable <= 0;
            sig_r_enable <= 0;
            state <= IDLE;
        end else begin
            sync_prev <= sync_start;

            case (state)
                IDLE: begin
                    if (sync_rising) begin
                        dir <= ~dir;
                        sig_l_enable <= 1;
                        sig_r_enable <= 0;
                        state <= WAIT_L;
                    end
                end

                WAIT_L: begin
                    if (sig_l_detected) begin
                        sig_l_enable <= 0;
                        sig_r_enable <= 1;
                        state <= WAIT_R;
                    end
                end

                WAIT_R: begin
                    if (sig_r_detected) begin
                        sig_r_enable <= 0;
                        state <= COMPLETE;
                    end
                end

                COMPLETE: begin
                    if (sync_rising) begin
                        dir <= ~dir;
                        sig_l_enable <= 1;
                        sig_r_enable <= 0;
                        state <= WAIT_L;
                    end
                end
            endcase
        end
    end
endmodule
