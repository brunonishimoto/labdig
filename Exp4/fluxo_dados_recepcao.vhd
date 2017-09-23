-- VHDL do Fluxo de Dados da recepção

library ieee;
use ieee.std_logic_1164.all;

entity fluxo_dados_recepcao is
  port(enableRecepcao : in std_Logic;
       RD             : in std_logic;
       dadoRecebido   : out std_logic);
end fluxo_dados_recepcao;

architecture fluxo_dados of fluxo_dados_recepcao is

begin
  dadoRecebido <= enableRecepcao and RD;
end fluxo_dados;