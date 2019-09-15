# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir D:/verilog/hardware_exp/lab5/fpga/vending_machine/vending_machine.cache/wt [current_project]
set_property parent.project_path D:/verilog/hardware_exp/lab5/fpga/vending_machine/vending_machine.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_repo_paths {{d:/verilog/hardware_exp/lab5/Keyboard Sample Code/Keyboard Sample Code/Keyboard Sample Code/ip}} [current_project]
set_property ip_output_repo d:/verilog/hardware_exp/lab5/fpga/vending_machine/vending_machine.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib D:/verilog/hardware_exp/lab5/Lab5_TeamX_Vending_Machine.v
read_ip -quiet D:/verilog/hardware_exp/lab5/fpga/vending_machine/vending_machine.srcs/sources_1/ip/KeyboardCtrl_0/KeyboardCtrl_0.xci

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc {{D:/verilog/hardware_exp/lab5/Keyboard Sample Code/Keyboard Sample Code/Keyboard Sample Code/KeyboardConstraints.xdc}}
set_property used_in_implementation false [get_files {{D:/verilog/hardware_exp/lab5/Keyboard Sample Code/Keyboard Sample Code/Keyboard Sample Code/KeyboardConstraints.xdc}}]

set_param ips.enableIPCacheLiteLoad 0
close [open __synthesis_is_running__ w]

synth_design -top fpga -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef fpga.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file fpga_utilization_synth.rpt -pb fpga_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
