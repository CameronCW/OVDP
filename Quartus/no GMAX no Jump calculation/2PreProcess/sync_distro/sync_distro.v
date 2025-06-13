module sync_distributor (
    input wire clk,
    input wire reset_n,

    input wire lsync_in,
    input wire rsync_in,

    output wire sync_to_afll,
    output wire sync_to_sig_timestamp_l,
    output wire sync_to_sig_timestamp_r,
    output wire sync_to_scan_dir
);

    assign sync_to_afll = lsync_in | rsync_in;  // OR both syncs to keep AFLL updated
    assign sync_to_sig_timestamp_l = lsync_in;
    assign sync_to_sig_timestamp_r = rsync_in;
    assign sync_to_scan_dir = lsync_in;  // or rsync_in depending on design

endmodule



// this is so dumb, why can I not connect sync_start to multiple connections for a conduit
// and it needs a clock to play ball though it's not driven

