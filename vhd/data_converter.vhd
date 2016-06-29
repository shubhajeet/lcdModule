----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:08:05 06/28/2016 
-- Design Name: 
-- Module Name:    data_converter - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_converter is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           cw : in  STD_LOGIC_VECTOR (7 downto 0);
           cw_en : in  STD_LOGIC;
           data : in  STD_LOGIC_VECTOR (7 downto 0);
           data_en : in  STD_LOGIC;
           nibble_mux : in  STD_LOGIC;
           data_type : in  STD_LOGIC;
           SF_D : out  STD_LOGIC_VECTOR (3 downto 0));
end data_converter;

architecture Behavioral of data_converter is

begin


end Behavioral;

