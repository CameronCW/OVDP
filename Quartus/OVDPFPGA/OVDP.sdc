# 100 MHz input clock
create_clock -name clk_sys -period 10 [get_ports clk_clk]

# 5 MHz virtual slow clock
create_clock -name clk_slow -period 200

# Mark domains as async
set_clock_groups -asynchronous -group {clk_sys} -group {clk_slow}

# Clock uncertainty
derive_clock_uncertainty

# Assign virtual clk_slow to PID block
set_clock -name clk_slow [get_registers -hierarchical *pid_controller*]
