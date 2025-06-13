module fir_stream_wrapper (
    input wire clk,
    input wire reset_n,

    // Conduit-style input (from extrapolation buffer)
    input wire signed [15:0] sample_in,
    input wire valid_in,

    // Conduit-style output (to DAC, I2S, or output logic)
    output wire signed [15:0] sample_out,
    output wire valid_out
);

    // Internal wires for Avalon-ST sink
    wire [15:0] sink_data;
    wire sink_valid;
    wire sink_ready; // unused, but declared for FIR IP

    // Internal wires for Avalon-ST source
    wire [15:0] source_data;
    wire source_valid;

    // Connect conduit inputs to Avalon-ST sink
    assign sink_data  = sample_in;
    assign sink_valid = valid_in;

    // Connect Avalon-ST source to conduit outputs
    assign sample_out = source_data;
    assign valid_out  = source_valid;

	 
	// === Instantiate FIR Compiler II IP Core ===
	fir_compiler_ii u_fir (
		 .clk(clk),
		 .reset_n(reset_n),

		 // Avalon-ST sink (input)
		 .ast_sink_data(sink_data),         // [7:0]
		 .ast_sink_valid(sink_valid),
		 .ast_sink_error(2'b00),            // Constant if not using error handling

		 // Avalon-ST source (output)
		 .ast_source_data(source_data),     // [21:0]
		 .ast_source_valid(source_valid),
		 .ast_source_error()                // Unused, can be left open
	);

endmodule
