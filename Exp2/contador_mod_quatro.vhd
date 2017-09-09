-- VHDL de um contador de modulo 4

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity contador_mod_quatro is
    port(clock     : in  std_logic;
         zera      : in  std_logic;
         conta     : in  std_logic;
         fim       : out std_logic);
end contador_mod_quatro;

architecture exemplo of contador_mod_quatro is
signal IQ: unsigned(1 downto 0);
signal output: std_logic;

begin
	process (clock, conta, IQ, zera)
	begin
	
		if clock'event and clock = '1' then
			if zera = '1' then 
				IQ <= (others => '0');
			elsif conta = '1' then 
				IQ <= IQ + 1;
			end if;
		end if;
		
		if IQ = 3 then 
			fim <= '1';
		else
			fim <= '0';
		end if;  
		
	end process;
	
end exemplo;