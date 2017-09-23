-- VHDL do Fluxo de Dados da transmissão

library ieee;
use ieee.std_logic_1164.all;

entity fluxo_dados_transmissao is
  port(enableTransmissao: in  std_logic;
       dadoSerial       : in  std_logic;
       TD               : out std_logic);
end fluxo_dados_transmissao;

architecture fluxo_dados of fluxo_dados_transmissao is

begin
  TD <= enableTransmissao and dadoSerial;
end fluxo_dados;