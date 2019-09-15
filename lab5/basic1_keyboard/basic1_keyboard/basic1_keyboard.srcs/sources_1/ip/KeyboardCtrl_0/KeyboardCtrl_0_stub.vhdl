-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
-- Date        : Thu Nov 15 15:48:56 2018
-- Host        : asus running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               d:/verilog/hardware_exp/lab5/basic1_keyboard/basic1_keyboard/basic1_keyboard.srcs/sources_1/ip/KeyboardCtrl_0/KeyboardCtrl_0_stub.vhdl
-- Design      : KeyboardCtrl_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KeyboardCtrl_0 is
  Port ( 
    key_in : out STD_LOGIC_VECTOR ( 7 downto 0 );
    is_extend : out STD_LOGIC;
    is_break : out STD_LOGIC;
    valid : out STD_LOGIC;
    err : out STD_LOGIC;
    PS2_DATA : inout STD_LOGIC;
    PS2_CLK : inout STD_LOGIC;
    rst : in STD_LOGIC;
    clk : in STD_LOGIC
  );

end KeyboardCtrl_0;

architecture stub of KeyboardCtrl_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "key_in[7:0],is_extend,is_break,valid,err,PS2_DATA,PS2_CLK,rst,clk";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "KeyboardCtrl,Vivado 2018.2";
begin
end;
