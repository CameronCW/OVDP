# TCL File Generated by Component Editor 20.1
# Sun May 25 02:52:48 BST 2025
# DO NOT MODIFY


# 
# sig_timestamp "sig_timestamp" v1.0
# Cameron Wade 2025.05.25.02:52:48
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module sig_timestamp
# 
set_module_property DESCRIPTION ""
set_module_property NAME sig_timestamp
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Cameron Wade"
set_module_property DISPLAY_NAME sig_timestamp
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL sig_timestamp
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file sig_timestamp.v VERILOG PATH sig_timestamp/sig_timestamp.v TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 100000000
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset_n reset_n Input 1


# 
# connection point sig_edge
# 
add_interface sig_edge conduit end
set_interface_property sig_edge associatedClock clock
set_interface_property sig_edge associatedReset ""
set_interface_property sig_edge ENABLED true
set_interface_property sig_edge EXPORT_OF ""
set_interface_property sig_edge PORT_NAME_MAP ""
set_interface_property sig_edge CMSIS_SVD_VARIABLES ""
set_interface_property sig_edge SVD_ADDRESS_GROUP ""

add_interface_port sig_edge sig_edge export Input 1


# 
# connection point sig_time
# 
add_interface sig_time conduit end
set_interface_property sig_time associatedClock clock
set_interface_property sig_time associatedReset ""
set_interface_property sig_time ENABLED true
set_interface_property sig_time EXPORT_OF ""
set_interface_property sig_time PORT_NAME_MAP ""
set_interface_property sig_time CMSIS_SVD_VARIABLES ""
set_interface_property sig_time SVD_ADDRESS_GROUP ""

add_interface_port sig_time sig_time export Output 32


# 
# connection point sync_start
# 
add_interface sync_start conduit end
set_interface_property sync_start associatedClock clock
set_interface_property sync_start associatedReset ""
set_interface_property sync_start ENABLED true
set_interface_property sync_start EXPORT_OF ""
set_interface_property sync_start PORT_NAME_MAP ""
set_interface_property sync_start CMSIS_SVD_VARIABLES ""
set_interface_property sync_start SVD_ADDRESS_GROUP ""

add_interface_port sync_start sync_start export Input 1

