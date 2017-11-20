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
       estado_recepcao    : out std_logic_vector(3 downto 0); -- depuracao do circuito de recepcao
       estado_transmissao : out std_logic_vector(3 downto 0)); -- depuracao do circuito de transmissao
end interface_modem;

architecture interface of interface_modem is

  component unidade_controle_recepcao_interface is
    port(clock           : in   std_logic;
         reset           : in   std_logic;
         liga            : in   std_logic;
         CD              : in   std_logic;
         RD              : in   std_logic;
         DTR             : out  std_logic;
         temDadoRecebido : out  std_logic;
         saida           : out  std_logic_vector(3 downto 0));  -- controle de estados
  end component;

  component unidade_controle_transmissao_interface is
    port(clock      : in   std_logic;
         reset      : in   std_logic;
         liga       : in   std_logic;
         enviar     : in   std_logic;
         CTS        : in   std_logic;
         DTR        : out  std_logic;
         RTS        : out  std_logic;
         envioOk    : out  std_logic;
         saida      : out  std_logic_vector(3 downto 0));  -- controle de estados
  end component;

  component fluxo_dados_transmissao_interface is
    port(enableTransmissao: in  std_logic;
         dadoSerial       : in  std_logic;
         TD               : out std_logic);
  end component;

  component fluxo_dados_recepcao_interface is
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

  uc_recepcao : unidade_controle_recepcao_interface port map (clock, reset, liga, CD, RD, DTRRecepcao, enableRecepcao, estadoRecepcao);
  uc_transmissao : unidade_controle_transmissao_interface port map (clock, reset, liga, enviar, CTS, DTRTransmissao, RTS, enableTransmissao, estadoTransmissao);

  fd_recepcao    : fluxo_dados_recepcao_interface port map (enableRecepcao, RD, dadoRecebido);
  fd_transmissao : fluxo_dados_transmissao_interface port map (enableTransmissao, dadoSerial, TD);



  estado_recepcao <= estadoRecepcao;
  estado_transmissao <= estadoTransmissao;
  DTR <= DTRRecepcao and DTRTransmissao;
  envioOk <= enableTransmissao;
  temDadoRecebido <= enableRecepcao;

end interface;