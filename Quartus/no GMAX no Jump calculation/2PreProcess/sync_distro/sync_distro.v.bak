module sync_distributor (
    input wire sync_in,
    output wire sync_to_afll,
    output wire sync_to_sig_timestamp,
    output wire sync_to_scan_dir
);
    assign sync_to_afll = sync_in;
    assign sync_to_sig_timestamp = sync_in;
    assign sync_to_scan_dir = sync_in;
endmodule

// this is so dumb, why can I not connect sync_start to multiple connections for a conduit