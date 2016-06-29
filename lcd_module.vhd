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
			  clear : in  STD_LOGIC;
			  wr : in STD_LOGIC;
           data : in  STD_LOGIC_VECTOR (7 downto 0);
           data_type : in  STD_LOGIC;
           state : out  STD_LOGIC_VECTOR (0 downto 0);
			  LCD_E : out std_logic;
			  LCD_RS : out std_logic;
			  LCD_RW : out std_logic;
			  SF_CE0 : out std_logic;
			  SF_D : OUT  std_logic_vector(3 downto 0)
			  );
end lcd_module;

architecture Behavioral of lcd_module is
    COMPONENT data_converter
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         cw : IN  std_logic_vector(7 downto 0);
         en : IN  std_logic;
         data : IN  std_logic_vector(7 downto 0);
         LCD_RS : IN  std_logic;
         nibble_mux : IN  std_logic;
         data_type : IN  std_logic;
         SF_D : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
	 COMPONENT controller
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
			clear : IN std_logic;
			wr : IN std_logic;
         LCD_E : OUT  std_logic;
         LCD_RS : OUT  std_logic;
         LCD_RW : OUT  std_logic;
         SF_CE0 : OUT  std_logic;
         data_converter_en : OUT  std_logic;
			nibble_sel : OUT std_logic;
			cw : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
 	signal data_converter_en, nibble_sel, c_d : std_logic;
	signal cw : std_logic_vector (7 downto 0);
 	begin
	-- Instantiate the Unit Under Test (UUT)
   contrl: controller PORT MAP (
          clk => clk,
          reset => reset,
			 clear => clear, 
			 wr => wr,
          LCD_E => LCD_E,
          LCD_RS => c_d,
			 LCD_RW => LCD_RW,
          SF_CE0 => SF_CE0,
          data_converter_en => data_converter_en,
			 nibble_sel => nibble_sel,
          cw => cw
        );
		  
	conv: data_converter PORT MAP (
          clk => clk,
          reset => reset,
          cw => cw,
          en => data_converter_en,
          data => data,
          LCD_RS => c_d,
          nibble_mux => nibble_sel,
          data_type => data_type,
          SF_D => SF_D
        );
	LCD_RS <= c_d;
end Behavioral;

