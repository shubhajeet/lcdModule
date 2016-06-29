--------------------------------------------------------------------------------
-- Copyright (c) 1995-2011 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version: O.87xd
--  \   \         Application: netgen
--  /   /         Filename: controller_synthesis.vhd
-- /___/   /\     Timestamp: Tue Jun 28 07:21:13 2016
-- \   \  /  \ 
--  \___\/\___\
--             
-- Command	: -filter C:/Users/sujit/Projects/lcd_module/iseconfig/filter.filter -intstyle ise -ar Structure -tm controller -w -dir netgen/synthesis -ofmt vhdl -sim controller.ngc controller_synthesis.vhd 
-- Device	: xc3s500e-4-fg320
-- Input file	: controller.ngc
-- Output file	: C:\Users\sujit\Projects\lcd_module\netgen\synthesis\controller_synthesis.vhd
-- # of Entities	: 1
-- Design Name	: controller
-- Xilinx	: C:\Xilinx\13.4\ISE_DS\ISE\
--             
-- Purpose:    
--     This VHDL netlist is a verification model and uses simulation 
--     primitives which may not represent the true implementation of the 
--     device, however the netlist is functionally correct and should not 
--     be modified. This file cannot be synthesized and should only be used 
--     with supported simulation tools.
--             
-- Reference:  
--     Command Line Tools User Guide, Chapter 23
--     Synthesis and Simulation Design Guide, Chapter 6
--             
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
use UNISIM.VPKG.ALL;

entity controller is
  port (
    clk : in STD_LOGIC := 'X'; 
    LCD_E : out STD_LOGIC; 
    state : out STD_LOGIC; 
    reset : in STD_LOGIC := 'X'; 
    LCD_RS : out STD_LOGIC; 
    LCD_RW : out STD_LOGIC; 
    SF_CE0 : out STD_LOGIC; 
    cw : out STD_LOGIC_VECTOR ( 7 downto 0 ) 
  );
end controller;

architecture Structure of controller is
  signal cw_0_OBUF_10 : STD_LOGIC; 
  signal cw_2_OBUF_11 : STD_LOGIC; 
begin
  XST_GND : GND
    port map (
      G => cw_2_OBUF_11
    );
  XST_VCC : VCC
    port map (
      P => cw_0_OBUF_10
    );
  LCD_RW_OBUF : OBUF
    port map (
      I => cw_2_OBUF_11,
      O => LCD_RW
    );
  SF_CE0_OBUF : OBUF
    port map (
      I => cw_0_OBUF_10,
      O => SF_CE0
    );
  cw_7_OBUF : OBUF
    port map (
      I => cw_2_OBUF_11,
      O => cw(7)
    );
  cw_6_OBUF : OBUF
    port map (
      I => cw_2_OBUF_11,
      O => cw(6)
    );
  cw_5_OBUF : OBUF
    port map (
      I => cw_2_OBUF_11,
      O => cw(5)
    );
  cw_4_OBUF : OBUF
    port map (
      I => cw_2_OBUF_11,
      O => cw(4)
    );
  cw_3_OBUF : OBUF
    port map (
      I => cw_2_OBUF_11,
      O => cw(3)
    );
  cw_2_OBUF : OBUF
    port map (
      I => cw_2_OBUF_11,
      O => cw(2)
    );
  cw_1_OBUF : OBUF
    port map (
      I => cw_0_OBUF_10,
      O => cw(1)
    );
  cw_0_OBUF : OBUF
    port map (
      I => cw_0_OBUF_10,
      O => cw(0)
    );

end Structure;

