-- VHDL do Sistema Digital

library ieee;
use ieee.std_logic_1164.all;

entity interface is
  port(clock                : in  std_logic;
       reset                : in  std_logic;
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
       transmissaoAndamento : out  std_logic;
       estadoRecepcao       : out  std_logic_vector(1 downto 0);
       estadoTransmissao    : out  std_logic_vector(1 downto 0));
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
         temDadoRecepcao : out  std_logic;
         estadoRecepcao  : out  std_logic_vector(1 downto 0)); -- sinal de depuração
  end component;

  component unidade_controle_transmissao is
    port(clock               : in  std_logic;
         reset               : in  std_logic;
         transmiteDado       : in  std_logic;
         prontoTransmissao   : in  std_logic;
         partidaTransmissao  : out std_logic;
         transmissaoAndamento: out std_logic;
         zeraRegistrador     : out std_logic;
         estadoTransmissao   : out std_logic_vector(1 downto 0)); --sinal de depuracao
  end component;

  component fluxo_dados_recepcao is
    port(clock          : in std_logic;
         reset          : in std_logic;
         temDadoRecepcao: in std_logic;
         zeraRegistrador: in std_logic;
         dadoRecebido   : in std_logic_vector(6 downto 0);
         dadoRecepcao   : out std_logic_vector(6 downto 0));
  end component;

  component fluxo_dados_transmissao is
    port(clock               : in std_logic;
         reset               : in std_logic;
         transmissaoAndamento: in std_logic;
         zeraRegistrador     : in std_logic;
         dadoTransmissao     : in std_logic_vector(6 downto 0);
         dadoTransmitido     : out std_logic_vector(6 downto 0));
  end component;

signal s_zeraRegistradorRecepcao: std_logic;
signal s_zeraRegistradorTransmissao: std_logic;
signal s_temDadoRecepcao: std_logic;
signal s_transmissaoAndamento: std_logic;

begin

  uc_recepcao: unidade_controle_recepcao port map (clock, reset, prontoRecepcao, recebeDado, s_zeraRegistradorRecepcao, 
                                                   s_temDadoRecepcao, estadoRecepcao);
  uc_transmissao: unidade_controle_transmissao port map (clock, reset, transmiteDado, prontoTransmissao, partidaTransmissao,
                                                         s_transmissaoAndamento, s_zeraRegistradorTransmissao, estadoTransmissao);

  fd_recepcao: fluxo_dados_recepcao port map (clock, reset, s_temDadoRecepcao, s_zeraRegistradorRecepcao, dadoRecebido, dadoRecepcao);
  fd_transmissao: fluxo_dados_transmissao port map (clock, reset, s_transmissaoAndamento, s_zeraRegistradorTransmissao, dadoTransmissao, dadoTransmitido);

  temDadoRecepcao <= s_temDadoRecepcao;
  transmissaoAndamento <= s_transmissaoAndamento;

end interface;