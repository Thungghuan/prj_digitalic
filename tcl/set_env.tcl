# Logical libraries
set library_dir       "/ee/ncicc2019/yqzheng/process/gb18_dc_lib"
set library_file_name "scx_csm_18ic_tt_1p8v_25c.db"
set library_name      "scx_csm_18ic_tt_1p8v_25c"
   
set search_path	" . \
   ${library_dir} \
   ${search_path} \
" 
set target_library "${library_file_name}"

set link_library " \
   * \
   ${target_library}
     
"

#set symbol_library "slow_1v08c125.sldb"

suppress_message "APL-027"
set suppress_errors {PWR-18 OPT-932 OPT-317}
set suppress_errors "$suppress_errors PDEFP-30 PSYN-040 PSYN-087 PSYN-088"
set physopt_fix_multiple_port_nets true
set pdefin_use_nameprefix false
set verilogout_no_tri {true}
set acs_internal_search_path_appendix {}
set auto_link_options {-all}
set verilogout_no_tri {true}
set dc_shell_status {}
set symbol_library {generic.sdb}
set hdlin_unsigned_integers {true}
#set hdlin_preserve_sequential {true}
set sh_new_variable_message {true}
set verbose_messages {true}
set compile_seqmap_propagate_constants false
set compile_delete_unloaded_sequential_cells false
set compile_preserve_subdesign_interfaces {true}

#DFT traceing
set hdlin_enable_rtldrc_info true

suppress_message "ELAB-311 VER-313 VER-318 ELAB-810 VER-61 UID-348"

############################################################################
alias rpt report_timing -sig 6 -cap -tran -net -input_pins
alias rf  report_timing -sig 6 -cap -tran -net -input_pins -from
alias rt  report_timing -sig 6 -cap -tran -net -input_pins -to

