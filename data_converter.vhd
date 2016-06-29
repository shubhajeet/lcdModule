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
USE ieee.std_logic_arith.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_converter is
    Port ( 
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
end data_converter;

architecture Behavioral of data_converter is
	type states is (transmitting, done);
	signal state : states := done;
	signal data_count : integer := 0;
	signal reg: STD_LOGIC_VECTOR (7 downto 0);
	type nibble is array (3 downto 0) of STD_LOGIC_VECTOR(3 downto 0);
	signal tx_data : nibble;
begin
	conv: process(clk,reset)
	begin
		if(reset = '1') then
			tx_data <=  (others => "0000");
			SF_D <= "0000";
			state <= done;
		elsif (clk = '1' and clk'event and en = '1') then
			state <= transmitting;
			if(LCD_RS = '0') then
				reg <= cw;
				data_count <= 2;
			elsif (LCD_RS = '1') then
				reg <= data;
				if (data_type = '0') then
					tx_data(0) <= reg(3 downto 0);
					tx_data(1) <= reg(7 downto 4);
				else
					if reg(7 downto 4) < "1010" then
						tx_data(1) <= "0011";
						tx_data(0) <= reg(7 downto 4);
					else 
						tx_data(1) <= "0100";
						tx_data(0) <= reg(7 downto 4);
						case tx_data(0) is
							when "1010" =>
								tx_data(0) <= "0000";
							when "1011" =>
								tx_data(0) <= "0001";
							when "1100" =>
								tx_data(0) <= "0010";
							when "1101" =>
								tx_data(0) <= "0011";
							when "1110" =>
								tx_data(0) <= "0100";
							when "1111" =>
								tx_data(0) <= "0101";
							when others =>
							end case;
						
					end if;
					if reg(3 downto 0) < "1010" then
						tx_data(3) <= "0011";
						tx_data(2) <= reg(7 downto 4);
					else 
						tx_data(3) <= "0100";
						tx_data(2) <= reg(7 downto 4);
						case tx_data(2) is
							when "1010" =>
								tx_data(2) <= "0000";
							when "1011" =>
								tx_data(2) <= "0001";
							when "1100" =>
								tx_data(2) <= "0010";
							when "1101" =>
								tx_data(2) <= "0011";
							when "1110" =>
								tx_data(2) <= "0100";
							when "1111" =>
								tx_data(2) <= "0101";
							when others =>
							end case;
						
					end if; 
									
				end if;
			end if;
			if (nibble_mux = '0') then
				SF_D <= tx_data(data_count);
				data_count <= data_count - 1;
			elsif (nibble_mux = '1') then
				SF_D <= tx_data(data_count);
				data_count <= data_count - 1;
			end if;
			if data_count <= 0 then
				state <= done;
			end if;
		end if;
	end process conv;
end Behavioral;

