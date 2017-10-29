-- VHDL do comparador do paridade

library ieee;
use ieee.std_logic_1164.all;

entity comparador_de_paridade is
    port(paridade_recebida     : in  std_logic;
         dado_recebido         : in  std_logic_vector(6 downto 0);
         indicador_de_paridade : out std_logic);
end comparador_de_paridade;

architecture comparador of comparador_de_paridade is
signal paridade_esperada: std_logic;
begin
	process (paridade_recebida, dado_recebido)
  begin
    paridade_esperada <= dado_recebido(0) xor dado_recebido(1) xor dado_recebido(2) xor dado_recebido(3) xor dado_recebido(4) xor dado_recebido(5) xor dado_recebido(6);
		indicador_de_paridade <= paridade_esperada xnor paridade_recebida;
	end process;
end comparador;