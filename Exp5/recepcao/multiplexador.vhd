-- VHDL de um multiplexador

library ieee;
use ieee.std_logic_1164.all;

entity multiplexador is
	port (entrada1, entrada2: in std_logic;
			mux: in std_logic;
			saida: out std_logic);
end multiplexador;

architecture multiplexador of multiplexador is

begin

	saida <= (not (mux) and entrada1) or (mux and entrada2);

end multiplexador;