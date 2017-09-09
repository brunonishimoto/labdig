-- VHDL do ativador do receptor (basicamente um flip-flop SR)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity ativador is
    port(set     : in  std_logic;
         reset   : in  std_logic;
         ativa   : out std_logic);
end ativador;

architecture exemplo of ativador is
signal IQ: std_logic := '0';

begin
	process (set, reset)
	begin
	
	if set'event and set = '1' then
		IQ <= '1';
	end if;
	
   if reset'event and reset = '1' then
		IQ <= '0';
   end if;
	
	ativa <= IQ;  
   
	end process;
end exemplo;