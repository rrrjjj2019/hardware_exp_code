set_property IOSTANDARD LVCMOS33 [get_ports {RxData[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RxData[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RxData[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RxData[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RxData[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RxData[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RxData[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RxData[0]}]
set_property PACKAGE_PIN W5 [get_ports Clk]
set_property PACKAGE_PIN U18 [get_ports Rst_n]
set_property PACKAGE_PIN P18 [get_ports Tx]
set_property PACKAGE_PIN N17 [get_ports Rx]
set_property IOSTANDARD LVCMOS33 [get_ports Clk]
set_property IOSTANDARD LVCMOS33 [get_ports Rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports Rx]
set_property IOSTANDARD LVCMOS33 [get_ports Tx]
set_property PACKAGE_PIN U16 [get_ports {RxData[0]}]
set_property PACKAGE_PIN E19 [get_ports {RxData[1]}]
set_property PACKAGE_PIN U19 [get_ports {RxData[2]}]
set_property PACKAGE_PIN V19 [get_ports {RxData[3]}]
set_property PACKAGE_PIN W18 [get_ports {RxData[4]}]
set_property PACKAGE_PIN U15 [get_ports {RxData[5]}]
set_property PACKAGE_PIN U14 [get_ports {RxData[6]}]
set_property PACKAGE_PIN V14 [get_ports {RxData[7]}]

# testing
set_property IOSTANDARD LVCMOS33 [get_ports rx_test]
set_property PACKAGE_PIN L1 [get_ports rx_test]



set_property CFGBVS Vcco [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]


set_property IOSTANDARD LVCMOS33 [get_ports rx_test_x]
set_property PACKAGE_PIN P1 [get_ports rx_test_x]

set_property IOSTANDARD LVCMOS33 [get_ports RxDone_test]
set_property PACKAGE_PIN N3 [get_ports RxDone_test]

set_property IOSTANDARD LVCMOS33 [get_ports debug1]
set_property IOSTANDARD LVCMOS33 [get_ports debug2]
set_property IOSTANDARD LVCMOS33 [get_ports debug3]
set_property PACKAGE_PIN P3 [get_ports debug1]
set_property PACKAGE_PIN U3 [get_ports debug2]
set_property PACKAGE_PIN W3 [get_ports debug3]
