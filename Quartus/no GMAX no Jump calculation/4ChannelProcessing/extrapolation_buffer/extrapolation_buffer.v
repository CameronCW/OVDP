module extrapolation_buffer #(
    parameter N = 8
)(
    input wire clk,
    input wire reset_n,
    
    input wire signed [15:0] sample_in,
    input wire valid_in,
    
    output reg signed [15:0] sample_out,
    output reg valid_out
);

    reg signed [15:0] buffer [0:N-1];
    reg [2:0] wr_ptr = 0;

    reg [2:0] miss_count = 0;
    reg interpolate_flag = 0;
    reg signed [15:0] last_valid = 0;
    reg signed [15:0] next_valid = 0;

    integer i;
    reg [2:0] interp_index = 0;
	 
	 
	 wire [15:0] x;
    wire [2:0]  n;
    wire [15:0] Result;

    assign x = (next_valid - last_valid) * i;
    assign n = miss_count + 1;

    // Approximate Division using a shift adder
    div_by_const div_inst ( 
        .x(x),
        .n(n),
        .y(Result)
    );

    always @(posedge clk) begin
        if (!reset_n) begin
            wr_ptr <= 0;
            miss_count <= 0;
            sample_out <= 0;
            valid_out <= 0;
            interpolate_flag <= 0;
        end else begin
            valid_out <= 0;

            if (valid_in) begin
                next_valid <= sample_in;

                if (miss_count > 0) begin
                    // Perform interpolation from last_valid to next_valid
                    for (i = 1; i <= miss_count; i = i + 1) begin
                        buffer[(wr_ptr - miss_count + i - 1) % N] <=
                            //last_valid + ((next_valid - last_valid) * i) / (miss_count + 1); 
												// Division is too slow, need to implement a faster method
									 last_valid + Result;
										
                    end
                    miss_count <= 0;
                end

                buffer[wr_ptr] <= sample_in;
                last_valid <= sample_in;
                wr_ptr <= (wr_ptr + 1) % N;
                sample_out <= sample_in;
                valid_out <= 1;
            end else begin
                // Missed sample, mark slot and count
                buffer[wr_ptr] <= 0;  // placeholder
                miss_count <= miss_count + 1;
                wr_ptr <= (wr_ptr + 1) % N;
                sample_out <= last_valid;
                valid_out <= 1;
            end
        end
    end
endmodule
