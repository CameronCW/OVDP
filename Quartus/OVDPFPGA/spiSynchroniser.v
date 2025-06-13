// synchronizer.v
module synchronizer (
    input  wire clk,        // FPGA system clock
    input  wire async_in,   // Asynchronous input (e.g., SPI signal)
    output wire sync_out    // Synchronized output
);

    reg sync_reg1 = 0;
    reg sync_reg2 = 0;

    always @(posedge clk) begin
        sync_reg1 <= async_in;
        sync_reg2 <= sync_reg1;
    end

    assign sync_out = sync_reg2;

endmodule
