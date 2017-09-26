-- VHDL de um contador de modulo 4

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity contador_mod_quatro is
    port(clock     : in  std_logic;
         zera      : in  std_logic;
         conta     : in  std_logic;
         fim       : out std_logic := '0');
end contador_mod_quatro;

architecture exemplo of contador_mod_quatro is
signal IQ: unsigned(1 downto 0);
signal output: std_logic := '0';

begin
	process (clock, conta, IQ, zera)
	begin
		if zera = '1' then
			IQ <= (others => '0');
			output <= '0';
		elsif clock'event and clock = '1' then
			if conta = '1' then 
				IQ <= IQ + 1;
				if IQ = 3 then
					output <= not output;
				end if;
			end if;
		end if;
	
	fim <= output;
	end process;
	
end exemplo;