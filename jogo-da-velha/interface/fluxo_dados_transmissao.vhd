-- VHDL do Fluxo de Dados da transmissão

library ieee;
use ieee.std_logic_1164.all;

entity fluxo_dados_transmissao_interface is
  port(enableTransmissao: in  std_logic;
       dadoSerial       : in  std_logic;
       TD               : out std_logic);
end fluxo_dados_transmissao_interface;

architecture fluxo_dados of fluxo_dados_transmissao_interface is

begin
  TD <= not (enableTransmissao) or dadoSerial;
end fluxo_dados;