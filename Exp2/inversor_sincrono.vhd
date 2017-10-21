-- VHDL do inversor síncrono

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity inversor_sincrono is
    port(clock   : in  std_logic;
				 desativa: in  std_logic;
         saida   : out std_logic := '0');
end inversor_sincrono;

architecture exemplo of inversor_sincrono is
	signal s: std_logic;

begin
	process (clock)
	begin
		
		if clock'event and clock = '1' then
			if desativa = '1' then
				s <= '0';
			else
				if (s = '0') then
					s <= '1';
				else 
					s <= '0';
				end if;
			end if;
		end if;
		   
	end process;
	saida <= s;
end exemplo;