#######################################################################
#	
#			Create Clock
#	
#######################################################################

create_clock -name  {clk}    -period 10 -waveform {0 5} [get_ports clk]

########################################################################
##
##			Set Clock Latency
##	
########################################################################
set_clock_uncertainty -setup 1 [get_clocks clk]
set_clock_uncertainty -hold 1 [get_clocks clk]
set_propagated_clock clk

#set_load [expr 0.005] [all_outputs]

########################################################################
##	
##			Set Input Delay
##	
########################################################################
set_input_delay  -clock [get_clocks clk]  -max 5  [get_ports dext]



######################set_ideal_network#####################################
#set_ideal_network [get_ports rstb]
#set_ideal_latency 2 [get_ports rstb]
#set_ideal_transition 0.3 [get_ports rstb]

#set_max_fanout 4 [all_inputs]
#set_max_fanout 4 [current_design]
set_max_fanout 4 [get_pins rstb]
set_max_fanout 4 [get_ports rstb]
set_max_fanout 4 [get_ports clk]

#set_max_capacitance 0.1 [current_design]
#set_max_capacitance 0.1 [current_design]

#set_fix_hold clk
set_min_delay 2 -from [get_pins ins_delaycell/a] -to [get_pins ins_delaycell/y]

########################################################################
##	
##			Set Output Delay
##	
########################################################################





