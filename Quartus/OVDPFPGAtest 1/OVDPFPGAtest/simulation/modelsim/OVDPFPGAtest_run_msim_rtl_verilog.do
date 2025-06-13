transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+F:/Imperial/Desktop/OVDPFPGAtest\ 1/OVDPFPGAtest {F:/Imperial/Desktop/OVDPFPGAtest 1/OVDPFPGAtest/groove_sample_selector.v}
vlog -vlog01compat -work work +incdir+F:/Imperial/Desktop/OVDPFPGAtest\ 1/OVDPFPGAtest {F:/Imperial/Desktop/OVDPFPGAtest 1/OVDPFPGAtest/split_sync_predictor.v}
vlog -vlog01compat -work work +incdir+F:/Imperial/Desktop/OVDPFPGAtest\ 1/OVDPFPGAtest {F:/Imperial/Desktop/OVDPFPGAtest 1/OVDPFPGAtest/scan_dir_tracker.v}
vlog -vlog01compat -work work +incdir+F:/Imperial/Desktop/OVDPFPGAtest\ 1/OVDPFPGAtest {F:/Imperial/Desktop/OVDPFPGAtest 1/OVDPFPGAtest/preProcess_block.v}
vlog -vlog01compat -work work +incdir+F:/Imperial/Desktop/OVDPFPGAtest\ 1/OVDPFPGAtest {F:/Imperial/Desktop/OVDPFPGAtest 1/OVDPFPGAtest/afll.v}
vlog -vlog01compat -work work +incdir+F:/Imperial/Desktop/OVDPFPGAtest\ 1/OVDPFPGAtest {F:/Imperial/Desktop/OVDPFPGAtest 1/OVDPFPGAtest/AbsDiff.v}

