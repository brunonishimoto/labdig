-- VHDL do Sistema Digital

library ieee;
use ieee.std_logic_1164.all;

entity interface is
  port(clock                : in  std_logic;
       dadoRecebido         : in  std_logic_vector(6 downto 0);
       prontoRecepcao       : in  std_logic;
       paridadeOk           : in  std_logic;
       prontoTransmissao    : in  std_logic;
       recebeDado           : in  std_logic;
       transmiteDado        : in  std_logic;
       dadoTransmissao      : in  std_logic_vector(6 downto 0);
       partidaTransmissao   : out std_logic;
       dadoTransmitido      : out std_logic_vector(6 downto 0);
       dadoRecepcao         : out std_logic_vector(6 downto 0);
       temDadoRecepcao      : out  std_logic;
       transmissaoAndamento : out  std_logic);
end interface;
-- Criterio Adotado: quando for algo que liga a interface aos modulos
-- de transmissao e recepcao, o nome esta como dadoTransmitido/Recebido
-- Quando sair do modulo para conexao externa, esta como
-- dadoTransmissao/Recepcao (olhando a figura eh mais facil de entender)

architecture interface of interface is

  component unidade_controle_recepcao is
    port(clock           : in   std_logic;
         reset           : in   std_logic;
         prontoRecepcao  : in   std_logic;
         recebeDado      : in   std_logic;
         zeraRegistrador : out  std_logic; -- zera registrador que armazena o sinal
         registraDado    : out  std_logic; -- controla registro do sinal recebido
         temDadoRecepcao : out  std_logic);
  end component;

  component unidade_controle_transmissao is
    port(clock                   : in   std_logic;
         reset                   : in   std_logic;
         dadoTransmissao         : in   std_logic_vector(6 downto 0);
         transmiteDado           : in   std_logic;
         prontoTransmissao       : in   std_logic;
         partidaTransmissao      : out  std_logic;
         dadoTransmitido         : out  std_logic_vector(6 downto 0);
         transmissaoAndamento    : out  std_logic);
  end component;

  component fluxo_dados_transmissao is
    port(enableTransmissao: in  std_logic;
         dadoSerial       : in  std_logic;
         TD               : out std_logic);
  end component;

  component fluxo_dados_recepcao is
    port(enableRecepcao : in std_Logic;
         RD             : in std_logic;
         dadoRecebido   : out std_logic);
  end component;

signal estadoRecepcao : std_logic_vector(3 downto 0);
signal estadoTransmissao : std_logic_vector(3 downto 0);
signal DTRRecepcao : std_logic;
signal DTRTransmissao : std_logic;
signal enableTransmissao : std_logic;
signal enableRecepcao : std_logic;

begin

  uc_recepcao : unidade_controle_recepcao port map (clock, reset, liga, CD, RD, DTRRecepcao, enableRecepcao, estadoRecepcao);
  uc_transmissao : unidade_controle_transmissao port map (clock, reset, liga, enviar, CTS, DTRTransmissao, RTS, enableTransmissao, estadoTransmissao);

  fd_recepcao    : fluxo_dados_recepcao port map (enableRecepcao, RD, dadoRecebido);
  fd_transmissao : fluxo_dados_transmissao port map (enableTransmissao, dadoSerial, TD);



  estado_recepcao <= estadoRecepcao;
  estado_transmissao <= estadoTransmissao;
  DTR <= DTRRecepcao and DTRTransmissao;
  envioOk <= enableTransmissao;
  temDadoRecebido <= enableRecepcao;

end interface;