echo "SOC_MESSAGE: set dont use library cell "

# Clock Cells
set_dont_use  ${library_file_name}:${library_name}/CLK*
#remove_attribute [get_lib_cells ${library_file_name}:${library_name}/CLKMX2*] dont_use

# Delay Cells
#set_dont_use  ${library_file_name}:${library_name}/DLY*

# Drive too low -> timing not predictable due to a high sensitivity to routing
set_dont_use  ${library_file_name}:${library_name}/*XL
set_dont_use  ${library_file_name}:${library_name}/*X1
set_dont_use  ${library_file_name}:${library_name}/*X2

# Drive too high -> electromigration & xtalk issue
set_dont_use  ${library_file_name}:${library_name}/*X20
set_dont_use  ${library_file_name}:${library_name}/*X16
set_dont_use  ${library_file_name}:${library_name}/*X12

# tri state
set_dont_use  ${library_file_name}:${library_name}/TBUF*

# Complex devices which are slower than DW library
#set_dont_use  ${library_file_name}:${library_name}/ACC*
#set_dont_use  ${library_file_name}:${library_name}/ACH*
#set_dont_use  ${library_file_name}:${library_name}/ADD*
set_dont_use  ${library_file_name}:${library_name}/AFC*
set_dont_use  ${library_file_name}:${library_name}/AFH*
#set_dont_use  ${library_file_name}:${library_name}/AHC*
set_dont_use  ${library_file_name}:${library_name}/AHH*
set_dont_use  ${library_file_name}:${library_name}/BENC*
set_dont_use  ${library_file_name}:${library_name}/BMX*
set_dont_use  ${library_file_name}:${library_name}/CMPR*
set_dont_use  ${library_file_name}:${library_name}/RF*

# latch
set_dont_use  ${library_file_name}:${library_name}/*TLAT* 
#remove_attribute [get_lib_cells ${library_file_name}:${library_name}/TLATNCA*] dont_use

# reg with scan
set_dont_use  ${library_file_name}:${library_name}/SDFF*
set_dont_use  ${library_file_name}:${library_name}/SEDFF*
#set_dont_use  ${library_file_name}:${library_name}/SMDFF*

set_dont_use  ${library_file_name}:${library_name}/JK*


set_dont_use  ${library_file_name}:${library_name}/SDFFX*
set_dont_use  ${library_file_name}:${library_name}/SDFFHQX*
#set_dont_use  ${library_file_name}:${library_name}/SDFFQX*
set_dont_use  ${library_file_name}:${library_name}/SDFFSX*
set_dont_use  ${library_file_name}:${library_name}/SDFFSHQX*
set_dont_use  ${library_file_name}:${library_name}/SEDFFX*
set_dont_use  ${library_file_name}:${library_name}/SEDFFHQX*
#set_dont_use  ${library_file_name}:${library_name}/SMDFFHQX*

# reg without scan
#set_dont_use  ${library_file_name}:${library_name}/DFF*
set_dont_use  ${library_file_name}:${library_name}/EDFF*
#set_dont_use  ${library_file_name}:${library_name}/MDFF*

# reg with transparent mode

# reg which is negative-edge triggered
#set_dont_use  ${library_file_name}:${library_name}/*DFFN*

# reg with async set/reset
#set_dont_use  ${library_file_name}:${library_name}/*DFFR*
#set_dont_use  ${library_file_name}:${library_name}/*DFFS*

# reg without reset

# reg without TQ
