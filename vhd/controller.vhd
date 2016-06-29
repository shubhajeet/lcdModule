----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:02:22 06/28/2016 
-- Design Name: 
-- Module Name:    controller - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

15MS_CLK_CYL : constant integer <= 750000;
12_CLK_CYL : constant integer <= 12;
100us_CLK_CYL : constant integer <= 5000;
40us_CLK_CYL : constant integer <= 2000;

entity controller is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           LCD_E : out  STD_LOGIC;
           LCD_RS : out  STD_LOGIC;
           LCD_RW : out  STD_LOGIC;
           SF_CE0 : out  STD_LOGIC;
           state : out  STD_LOGIC;
			  cw : out STD_LOGIC_VECTOR (7 downto 0));
end controller;

architecture Behavioral of controller is

	-- initialization state machine
	type init_sequence is (idle, 15ms_wait, epulse1, 4ms_wait, epulse2, 100us_wait, epulse3, 4us_wait, epulse4,40us_wait2, done) 
	signal init_state : init_sequence := idle;
	signal counter : integer := 0;
	
	-- transmitting state machine
	type tx_sequence is (high_setup, high_hold, oneus, low_setup, low_hold, fortyus, done);
	signal tx_state : tx_sequence := done;
	signal tx_byte : STD_LOGIC_VECTOR(7 downto 0);

	--

begin
	-- spartan 3e special configuration
	SF_CE0 <= '1'; --disable intel strataflash
	LCD_RW <= '0'; --write to lcd_module only
	
	-- power on lcd initialization
	power_on_init: process(clk, reset)
	begin
		if (reset = '1') then
		-- reset
			init_state <= idle; -- back to the top of the init_sequence
		elsif (clk = '1' and clk'event) then
			case init_state is
				when idle => 
					counter <= 0;
					init_state <= 15ms_wait;
				when 15ms_wait =>
					if (counter = 15MS_CLK_CYL) then
						counter <= 0;
						init_state <= epulse1;
					else
						counter = counter + 1;
					end if
				when epulse1 =>
					if (counter = 12) then
						counter <= 0;
						init_state <= 4ms_wait;
					else
						cw <= 0x3;
						counter = counter + 1;
					end if
				when 4ms_wait =>
					if (counter = 10us_CLK_CYL) then
						counter <= 0;
						init_state <= epulse3;
					else
						counter = counter + 1;
					end if
				when epulse2 =>
					if (counter = 12) then
						counter <= 0;
						init_state <= 4ms_wait;
					else
						cw <= 0x3;
						counter = counter + 1;
					end if
				when 100us_wait =>
					if (counter = 10us_CLK_CYL) then
						counter <= 0;
						init_state <= epulse3;
					else
						counter = counter + 1;
					end if
				when epulse3 =>
					if (counter = 12) then
						counter <= 0;
						init_state <= 4ms_wait;
					else
						cw <= 0x3;
						counter = counter + 1;
					end if
				when 4us_wait=>
					if (counter = 4us_CLK_CYL) then
						counter <= 0;
						init_state <= epulse4;
					else
						counter = counter + 1;
					end if
				when epulse4 =>
					if (counter = 12) then
						counter <= 0;
						init_state <= 4ms_wait;
					else
						cw <= 0x3;
						counter = counter + 1;
					end if
				when 40us_wait2=>
					if (counter = 40us_CLK_CYL) then
						counter <= 0;
						init_state <= done;
					else
						counter = counter + 1;
					end if
		end if
	end process power_on_init;
end Behavioral;

