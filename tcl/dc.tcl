# ################################################################################
# Design Compiler Reference Methodology Script for Top-Down Flow
# Script: dc.tcl
# Version: D-2010.03-SP1 (May 24, 2010)
# ################################################################################

set start_time [clock seconds]

# file exists ... -> if output or work directory exist, return 1;
# mkdir ... -> create a new directory 
if {! [file exists output]} {exec mkdir output}
if {! [file exists work]} {exec mkdir work}

define_design_lib WORK -path ./work

# remove output/* 
sh rm -rf ./output/* 

# ##################################
#            Setting up            #
# ##################################

# set alib_library_analysis_path /home2/asic_B09/

# for RTL files
source -echo -verbose ./tcl/define.tcl

# set environment for DC 
source -echo -verbose ./tcl/set_env.tcl
source -echo -verbose ./tcl/dont_use_cell.tcl


# #######################################################################
#                 Setup for Formality verification
# #######################################################################

#SVF should always be written to allow Formality verification for advanced optimizations.
#Once set_svf is issued, DC will begin recording all relevant operations.
set_svf  ./output/${DESIGN_NAME}.svf

# ################################################################################
# Read in the RTL Design
# Read in the RTL source files or read in the elaborated design (.ddc).
# Use the -format option to specify: verilog, sverilog, or vhdl as needed.
# ################################################################################

echo "SOC_MESSAGE: Begin read design file "

#read_file -f verilog -netlist ../output/netlist_file.v
#analyze -format vhdl ${rtl_dir}/system/time_div.vhd

analyze -format verilog ${RTL_SOURCE_FILES}
elaborate ${DESIGN_NAME}

echo "SOC_MESSAGE: End read design file "

# Specify the current_design before link
current_design $DESIGN_NAME

# explicitly link the design immediately after reading RTL
link

# run check_design after link
check_design

# Since DC version 2004.06, the current design is auto uniquified during compile
set uniquify_naming_style "${DESIGN_NAME}_%s_%d"
uniquify -force
link

sh rm -rf ./work 

# ##### write RTL DDC #################################################################################################
#write -hierarchy -format ddc -output ./output/${DESIGN_NAME}.elab.ddc
#write -hierarchy -format verilog -output ./output/${DESIGN_NAME}.elab.v

# ################################################################################
#                    Apply Logical Design Constraints
# ################################################################################

# Remove any existing constraints and attributes
remove_sdc
remove_clock -all

# good practice step to reset design
reset_design

echo "SOC_MESSAGE: Begin read design constraint file "
#source ./tcl/define_clock.tcl
source -echo -verbose ./tcl/top.sdc

# --------------------Specify Wire Load Models-------------------------

# Override automatic selection and select manually
set auto_wire_load_selection false
# Use top mode if your design will be 'flat'
set_wire_load_mode top

set_wire_load_model -name ForQA -library scx_csm_18ic_tt_1p8v_25c

echo "SOC_MESSAGE: End read design constraint file "

# ################################################################################
# #                      set dont use library cell
# ################################################################################
#echo "SOC_MESSAGE: set dont use library cell"
#source $LIBRARY_DONT_USE_FILE

# ################################################################################
#                     Apply The Operating Conditions
# ################################################################################

##yqzheng
##remove_propagated_clock *   

#set_max_transition 0.2 [current_design]
#set_max_capacitance 0.2 [current_design]
#set_max_fanout 12 [current_design]
#set_critical_range 0.02 [current_design]
#set_max_area 800000

set_max_leakage_power 1000000
# set_max_dynamic_power 0.0

# Prevent feedthroughs in the synthesized netlist. 
set_fix_multiple_port_nets -feedthroughs -outputs -buffer_constants

# Prevent assignment statements in the Verilog netlist.
set_fix_multiple_port_nets -all -buffer_constants [get_designs *]
set verilogout_no_tri true

# ###############################################################################
#	                    set_dont_touch 
#
# ###############################################################################

current_design $DESIGN_NAME


# protect IO pad cell
#yqzheng
##set_dont_touch {PI PO8  PX3} true
# Buffering and optimization of HFNs may not be worthwhile because WLMs are especially inaccurate for very large fanouts
# By defined as ideal networks to disable buffering and optimization of HFNs
#yqzheng
##set_ideal_network [all_fanout -flat -clock_tree ]

                                          
# #############################################################
#      set max number of cpu used during compile
# ##################### #######################################
set_host_options -max_cores 1

# Prevent assignment statements in the Verilog netlist.
set_fix_multiple_port_nets -all -buffer_constants [get_designs *]
set verilogout_no_tri true

# ########################################################################
#                           Compile Design
# ########################################################################
set_prefer -min ${library_file_name}:${library_name}/DLY*
echo "SOC_MESSAGE: Begin compile design"

compile
#compile_ultra -no_autoungroup -no_boundary_optimization -no_seq_output_inversion

echo "SOC_MESSAGE: End compile design"

# ################################################################################
#                     Save Design after First Compile
# ################################################################################
#current_design $DESIGN_NAME
#change_name -rule verilog -hier
#echo "SOC_MESSAGE: Begin write design before post compile"
#write -format ddc -hierarchy -output ./output/${DESIGN_NAME}.before_post_compile.ddc
#write -format verilog -hierarchy -output ./output/${DESIGN_NAME}.before_post_compile.v
#report_qor > ./output/${DESIGN_NAME}.before_post_compile.qor.rpt
#report_timing -sig 4 -cap -transition_time -nets -attributes -nosplit > ./output/${DESIGN_NAME}.before_post_compile.timing.rpt
#report_constraint -all_violators -significant_digits 4 -nosplit  > ./output/${DESIGN_NAME}.before_post_compile.con
#report_constraint -all_violators -significant_digits 4 -nosplit -verbose >> ./output/${DESIGN_NAME}.before_post_compile.con

#echo "SOC_MESSAGE: End write design before post compile"

# Prevent assignment statements in the Verilog netlist.
set_fix_multiple_port_nets -all -buffer_constants [get_designs *]
set verilogout_no_tri true

# ##############################################################################
# ## post compile optimization
# ## Reload constraint files if neccessary
# ##############################################################################
#echo "SOC_MESSAGE: Begin read post compile file"
#compile_ultra -incremental  -no_autoungroup -scan -no_boundary_optimization 
#echo "SOC_MESSAGE: End read post compile file"

#current_design $DESIGN_NAME
#change_name -rule verilog -hier

#echo "SOC_MESSAGE: Begin write design before DFT"
#compile -scan
#
#write -format ddc -hierarchy -output ./output/${DESIGN_NAME}.compile_ultra.ddc_1
#write -format verilog -hierarchy -output ./output/${DESIGN_NAME}.compile_ultra.v
#report_qor > ./output/${DESIGN_NAME}.compile_ultra.qor.rpt_1
#report_timing -sig 4 -cap -transition_time -nets -attributes -nosplit > ./output/${DESIGN_NAME}.compile_ultra.timing.rpt_1

#echo "SOC_MESSAGE: End write design before DFT"
# ################################################################################
# DFT Compiler Optimization Section
# ################################################################################
#source -echo -verbose ./tcl/dft.tcl
#set_fix_hold clk

# compile -incremental -no_autoungroup -no_boundary_optimization -no_seq_output_inversion
#compile -incremental
#reoptimize_design -in_place
#compile_ultra -incremental  -no_autoungroup  -no_boundary_optimization 

current_design $DESIGN_NAME
change_name -rule verilog -hier

#write -format ddc -hierarchy -output ./output/${DESIGN_NAME}.compile.ddc_dft
#report_qor > ./output/${DESIGN_NAME}.compile.qor.rpt_dft
#report_timing -sig 4 -cap -transition_time -nets -attributes -nosplit > ./output/${DESIGN_NAME}.compile.timing.rpt_dft

# ################################################################################
#                        Write out Design
# ################################################################################
# Write and close SVF file and make it available for immediate use
set_svf -off

write -format ddc -hierarchy -output ./output/${DESIGN_NAME}.ddc
write -f verilog -hierarchy -output ./output/${DESIGN_NAME}.v
#write_scan_def  -output     ./output/${DESIGN_NAME}.scandef

# ################################################################################
#                         Write out Design Data
# ################################################################################
write_sdc -nosplit ./output/${DESIGN_NAME}.sdc
write_sdf ./output/${DESIGN_NAME}.sdf

# ################################################################################
# Generate Final Reports
# ################################################################################

report_qor > ./output/${DESIGN_NAME}.qor.rpt
report_threshold_voltage_group >> ./output/${DESIGN_NAME}.qor.rpt
#report_timing -delay_type min -sig 4 -cap -transition_time -nets -attributes -nosplit > ./output/${DESIGN_NAME}.timing.rpt
report_timing -sig 4 -cap -transition_time -nets -attributes -nosplit > ./output/${DESIGN_NAME}.timing.rpt

report_constraint -all_violators -significant_digits 4 -nosplit  > ./output/${DESIGN_NAME}.con

report_constraint -all_violators -significant_digits 4 -nosplit -verbose >> ./output/${DESIGN_NAME}.con
report_area -nosplit > ./output/${DESIGN_NAME}.area.rpt
report_power -nosplit > ./output/${DESIGN_NAME}.power.rpt

set end_time  [clock seconds]
set use_min [format "%3.1f" [expr [expr $end_time- $start_time]/60.0]]
set use_hr [format "%3.2f" [expr [expr $end_time- $start_time]/3600.0]]
echo "run time: [expr $end_time-$start_time] seconds = $use_min mins =  $use_hr hrs"



