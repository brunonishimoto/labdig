-- VHDL do fluxo de dados da recepcao

library ieee;
use ieee.std_logic_1164.all;

entity fluxo_dados_recepcao is
  port(clock          : in std_logic;
       reset          : in std_logic;
       temDadoRecepcao: in std_logic;
       zeraRegistrador: in std_logic;
       dadoRecebido   : in std_logic_vector(6 downto 0);
       enable         : out std_logic; --sinal de depuracao
       dadoRecepcao   : out std_logic_vector(6 downto 0));
end fluxo_dados_recepcao;

architecture fluxo_dados of fluxo_dados_recepcao is

  component edge_detector is
    port(clock     : in  std_logic;
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
    detector_borda: edge_detector port map (clock, temDadoRecepcao, enableRegistrador);
    registradorRecepcao: registrador port map (clock, reset or zeraRegistrador, enableRegistrador, dadoRecebido, dadoRecepcao);

    enable <= enableRegistrador;

  end fluxo_dados;  