-- VHDL do ativador do receptor (basicamente um latch SR)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity ativador is
    port(set     : in  std_logic;
         reset   : in  std_logic;
         ativa   : out std_logic);
end ativador;

architecture exemplo of ativador is

begin
	process (set, reset)
	begin
	
		if set = '0' then
			ativa <= '1';
		elsif reset = '1' then
			ativa <= '0';
	   end if;
		   
	end process;
end exemplo;