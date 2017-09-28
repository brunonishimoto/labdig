-- VHDL de um Registrador de Deslocamento para a direita

library ieee;
use ieee.std_logic_1164.all;

entity registrador is
  port(clock            : in  std_logic;
       reset            : in  std_logic;
       enableRegistro   : in  std_logic;
       dadoRecebido     : in  std_logic_vector(6 downto 0);
       dadoRecepcao     : out std_logic_vector(6 downto 0));
end registrador;

architecture exemplo of registrador is
signal IQ        : std_logic_vector(6 downto 0);

begin
  process (clock, reset, enableRegistro, IQ)
  begin

    if reset = '1' then
      IQ <= (others => '0');

    elsif (clock'event and clock = '1') then
      if enableRegistro = '1' then
        IQ <= dadoRecebido;
      end if;
    end if;

    dadoRecepcao <= IQ;
  end process;
end exemplo;