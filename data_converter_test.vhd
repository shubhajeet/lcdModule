--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:50:23 06/28/2016
-- Design Name:   
-- Module Name:   C:/Users/sujit/Projects/lcd_module/data_converter_test.vhd
-- Project Name:  lcd_module
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: data_converter
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY data_converter_test IS
END data_converter_test;
 
ARCHITECTURE behavior OF data_converter_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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
    

   --Inputs
   signal clk : std_logic;
   signal reset : std_logic := '0';
   signal cw : std_logic_vector(7 downto 0) := (others => '0');
   signal en : std_logic := '1';
   signal data : std_logic_vector(7 downto 0) := (others => '0');
   signal LCD_RS : std_logic := '0';
   signal nibble_mux : std_logic := '0';
   signal data_type : std_logic := '0';
	
 	--Outputs
   signal SF_D : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
	-- Instantiate the Unit Under Test (UUT)
   convt: data_converter PORT MAP (clk => clk,
         reset => reset,
         cw => cw,
         en => en,
         data => data,
         LCD_RS => LCD_RS,
         nibble_mux => nibble_mux,
         data_type => data_type,
         SF_D => SF_D
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
	
   begin		
		--wait for 100 ns;	

      --wait for clk_period*10;
		for count in 0 to 16 loop
			-- keep data
			data <= conv_std_logic_vector(signed(count),8);
			-- set data enable and data configuration
			data_type <= '0';
			nibble_mux <= '0';
			wait for clk_period*10;
			en <= '1';
			wait for clk_period*10;
			assert (SF_D = data(3 downto 0)) report "lower nibble not equal" severity error;
			nibble_mux <= '1';
			wait for clk_period*10;
			en <= '1';
			wait for clk_period*10;
			assert (SF_D = data(7 downto 4)) report "upper nibble not equal" severity error;
		end loop;
   end process;

END;
