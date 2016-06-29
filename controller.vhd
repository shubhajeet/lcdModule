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

entity controller is
    Port (
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
end controller;

architecture Behavioral of controller is

	constant CLK_CYL_15ms : integer := 5 ;--750000;
	constant CLK_CYL_4ms : integer := 5 ;--205000;
	constant CLK_CYL_100us : integer := 3 ;--5000;
	constant CLK_CYL_40us : integer := 2 ;-- 2000;
	constant CLK_CYL_LTOM : integer := 1 ; -- 50;
	
	constant PAUSE_WAIT : integer := 20; -- 82000;
	-- initialization state machine
	type init_sequence is (idle, wait_15ms, epulse1, wait_4ms, epulse2, wait_100us, epulse3, wait_40us, epulse4, wait2_40us, done) ;
	signal init_state : init_sequence := idle;
	signal init_counter : integer := 0;
	
	-- transmitting state machine
	type tx_sequence is (high_setup, high_hold, oneus, low_setup, low_hold, fortyus, done);
	signal tx_state : tx_sequence := done;
	signal tx_byte : STD_LOGIC_VECTOR(7 downto 0);

	--
	type display_state is (init, idle, function_set, entry_set, set_display, clr_display, pause, set_addr, done);
	signal machine_state : display_state := init;
	signal machine_counter : integer := 0;
begin
	-- spartan 3e special configuration
	SF_CE0 <= '1'; --disable intel strataflash
	LCD_RW <= '0'; --write to lcd_module only

	display: process(clk, reset)
	begin
		if(reset='1') then
			machine_state <= init;
			init_state <= idle; -- back to the top of the init_sequence
			data_converter_en <= '0';
		else
			case machine_state is
			when init =>
				if(init_state = done) then
					machine_state <= idle;	
				elsif (clk = '1' and clk'event) then
					case init_state is
						when idle => 
							init_counter <= 0;
							init_state <= wait_15ms;
						when wait_15ms =>
							if (init_counter = CLK_CYL_15ms) then
								init_counter <= 0;
								init_state <= epulse1;
							else
								init_counter <= init_counter + 1;
							end if;
						when epulse1 =>
							if (init_counter = 12) then
								init_counter <= 0;
								init_state <= wait_4ms;
								cw <= "00000000";
								--LCD_E <= '0';
							else
								--LCD_E <= '1';
								cw <= "00000011";
								init_counter <= init_counter + 1;
							end if;
						when wait_4ms =>
							if (init_counter = CLK_CYL_4ms) then
								init_counter <= 0;
								init_state <= epulse2;
								cw <= "00000000";
							else
								init_counter <= init_counter + 1;
							end if;
						when epulse2 =>
							if (init_counter = 12) then
								init_counter <= 0;
								init_state <= wait_100us;
								cw <= "00000000";
								--LCD_E <= '0';
							else
								--LCD_E <= '1';
								cw <= "00000011";
								init_counter <= init_counter + 1;
							end if;
						when wait_100us =>
							if (init_counter = CLK_CYL_100us) then
								init_counter <= 0;
								init_state <= epulse3;
							else
								init_counter <= init_counter + 1;
							end if;
						when epulse3 =>
							if (init_counter = 12) then
								init_counter <= 0;
								init_state <= wait_40us;
								cw <= "00000000";
								--LCD_E <= '0';
							else
								--LCD_E <= '1';	
								cw <= "00000011";
								init_counter <= init_counter + 1;
							end if;
						when wait_40us  =>
							if (init_counter = CLK_CYL_40us) then
								init_counter <= 0;
								init_state <= epulse4;
							else
								init_counter <= init_counter + 1;
							end if;
						when epulse4 =>
							if (init_counter = 12) then
								init_counter <= 0;
								init_state <= wait2_40us;
								--LCD_E <= '0';
							else
								--LCD_E <= '1';
								cw <= "00000011";
								init_counter <= init_counter + 1;
							end if;
						when wait2_40us =>
							if (init_counter = CLK_CYL_40us) then
								init_counter <= 0;
								init_state <= done;
							else
								init_counter <= init_counter + 1;
							end if;
						when done =>
						end case;	
		end if;
			when idle =>
				if (wr = '1') then
					machine_state <= function_set;
					machine_counter <= 0;
				end if;
			when function_set =>
				LCD_RS <= '0';
				cw <= "00101000";
				machine_state <= entry_set;
			when entry_set =>
				LCD_RS <= '0';
				cw <= "00101000";
				machine_state <= set_display;
			when set_display =>
				LCD_RS <= '0';
				cw <= "00101000";
				machine_state <= clr_display;
			when clr_display =>
				LCD_RS <=  '0';
				cw <= "00101000";
				machine_state <= pause;
				machine_counter <= 0;
			when pause =>
				if (machine_counter = PAUSE_WAIT) then
					machine_state <= set_addr;
				else
					machine_counter <= machine_counter + 1;
				end if;
			when set_addr =>
				LCD_RS <=  '0';
				cw <= "00101000";
				machine_state <= done;
				machine_counter <= 0;
			when done =>
				if(wr = '0') then
					machine_state <= idle;
				end if;
			end case;
		end if;
	end process display;			
	
end Behavioral;

