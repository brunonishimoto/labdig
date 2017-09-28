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
       estadoRecepcao       : out  std_logic_vector(2 downto 0);
       estadoTransmissao    : out  std_logic_vector(2 downto 0));
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
         temDadoRecepcao : out  std_logic;
         estadoRecepcao  : out  std_logic_vector(2 downto 0));
  end component;

  component unidade_controle_transmissao is
    port(clock                   : in   std_logic;
         reset                   : in   std_logic;
         dadoTransmissao         : in   std_logic_vector(6 downto 0);
         transmiteDado           : in   std_logic;
         prontoTransmissao       : in   std_logic;
         partidaTransmissao      : out  std_logic;
         dadoTransmitido         : out  std_logic_vector(6 downto 0);
         transmissaoAndamento    : out  std_logic;
         estadoTransmissao       : out  std_logic_vector(2 downto 0));
  end component;

  component registrador is
    port(clock            : in  std_logic;
         reset            : in  std_logic;
         enableRegistro   : in  std_logic;
         dadoRecebido     : in  std_logic_vector(6 downto 0);
         dadoRecepcao     : out std_logic_vector(6 downto 0));
  end component;

signal zeraRegistrador : std_logic;
signal registraDado    : std_logic;

begin

  uc_recepcao : unidade_controle_recepcao port map (clock, reset, prontoRecepcao, recebeDado, zeraRegistrador, registraDado, temDadoRecepcao, estadoRecepcao);
  uc_transmissao : unidade_controle_transmissao port map (clock, reset, dadoTransmissao, transmiteDado, prontoTransmissao, partidaTransmissao, dadoTransmitido, transmissaoAndamento, estadoTransmissao);

  fd_recepcao    : registrador port map (clock, reset or zeraRegistrador, registraDado, dadoRecebido, dadoRecepcao);

end interface;