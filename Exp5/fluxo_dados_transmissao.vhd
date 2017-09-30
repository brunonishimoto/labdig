-- VHDL do fluxo de dados da transmissao

library ieee;
use ieee.std_logic_1164.all;

entity fluxo_dados_transmissao is
  port(clock               : in std_logic;
       reset               : in std_logic;
       transmissaoAndamento: in std_logic;
       zeraRegistrador     : in std_logic;
       dadoTransmissao     : in std_logic_vector(6 downto 0);
       dadoTransmitido     : out std_logic_vector(6 downto 0));
end fluxo_dados_transmissao;

architecture fluxo_dados of fluxo_dados_transmissao is

  component edge_detector is
    port(clock    : in  std_logic;
         signalIn : in  std_logic;
         signalOut: out std_logic);
  end component;

  component registrador is
    port(clock         : in  std_logic;
         reset         : in  std_logic;
         enableRegistro: in  std_logic;
         dataIn        : in  std_logic_vector(6 downto 0);
         dataOut       : out std_logic_vector(6 downto 0));
  end component; 

  signal enableRegistrador: std_logic; -- sinal interno do fluxo de dados
  
  begin
    detector_borda: edge_detector port map (clock, transmissaoAndamento, enableRegistrador);
    registradorTransmissao: registrador port map (clock, reset or zeraRegistrador, enableRegistrador, dadoTransmissao, dadoTransmitido);

end fluxo_dados;  