----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Sujit Maharjan
-- 
-- Create Date:    07:57:10 06/28/2016 
-- Design Name: 
-- Module Name:    lcd_module - Behavioral 
-- Project Name: 	lcd_module
-- Target Devices: spartan 3e 
-- Tool versions: 
-- Description: A Genric lcd controller able to display either ASCII text or number send to it
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

entity lcd_module is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           data : in  STD_LOGIC_VECTOR (7 downto 0);
           data_type : in  STD_LOGIC;
           state : out  STD_LOGIC_VECTOR (0 downto 0));
end lcd_module;

architecture Behavioral of lcd_module is

begin


end Behavioral;

