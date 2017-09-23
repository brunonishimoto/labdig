-- VHDL do Sistema Digital

library ieee;
use ieee.std_logic_1164.all;

entity interface_modem is
  port(clock              : in  std_logic;
       reset              : in  std_logic;
       liga               : in  std_logic;
       enviar             : in  std_logic;
       dadoSerial         : in  std_logic;
       CTS                : in  std_logic;
       CD                 : in  std_logic;
       RD                 : in  std_logic;
       DTR                : out std_logic;
       RTS                : out std_logic;
       TD                 : out std_logic;
       envioOk            : out  std_logic;
       temDadoRecebido    : out  std_logic;
       dadoRecebido       : out  std_logic;
       estado_recepcao    : out std_logic_vector(3 downto 0);
       estado_transmissao : out std_logic_vector(3 downto 0));
end interface_modem;

architecture interface of interface_modem is

  component unidade_controle_recepcao is
    port(clock           : in   std_logic;
         reset           : in   std_logic;
         liga            : in   std_logic;
         CD              : in   std_logic;
         RD              : in   std_logic;
         DTR             : out  std_logic;
         temDadoRecebido : out  std_logic;
         dadoRecebido    : out  std_logic;
         saida           : out  std_logic_vector(3 downto 0));  -- controle de estados
  end component;

  component unidade_controle_transmissao is
    port(clock      : in   std_logic;
         reset      : in   std_logic;
         liga       : in   std_logic;
         enviar     : in   std_logic;
         dadoSerial : in   std_logic;
         CTS        : in   std_logic;
         DTR        : out  std_logic;
         RTS        : out  std_logic;
         TD         : out  std_logic;
         envioOk    : out  std_logic;
         saida      : out  std_logic_vector(3 downto 0));  -- controle de estados
  end component;

signal estadoRecepcao : std_logic_vector(3 downto 0);
signal estadoTransmissao : std_logic_vector(3 downto 0);
signal DTRRecepcao : std_logic;
signal DTRTransmissao : std_logic;

begin

  recepcao : unidade_controle_recepcao port map (clock, reset, liga, CD, RD, DTRRecepcao, temDadoRecebido, dadoRecebido, estadoRecepcao);
  transmissao : unidade_controle_transmissao port map (clock, reset, liga, enviar, dadoSerial, CTS, DTRTransmissao, RTS, TD, envioOk, estadoTransmissao);

  estado_recepcao <= estadoRecepcao;
  estado_transmissao <= estadoTransmissao;
  DTR <= DTRRecepcao and DTRTransmissao;

end interface;