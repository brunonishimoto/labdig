-- VHDL for UART 

library ieee;
use ieee.std_logic_1164.all;

entity uart is
  port(clock;
       reset;
       transmiteDado: in std_logic;
       recebeDado   : in std_logic;
       entrada: in std_logic;
       dadoTransmissao: in std_logic_vector(6 downto 0);
       transmissaoAndamento: out std_logic;
       temDadoRecepcao: out std_logic;
       saida: out std_logic;
       dadoRecepcao: out std_logic_vector(6 downto 0));
end uart;

architecture uart of uart is

  component interface is
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
         temDadoRecepcao      : out std_logic;
         transmissaoAndamento : out std_logic;
         enableRegRecep       : out std_logic;
         estadoRecepcao       : out std_logic_vector(1 downto 0);  --sinal de depuracao
         estadoTransmissao    : out std_logic_vector(1 downto 0)); --sinal de depuracao
  end component;

  component recepcao_serial is
    port(dado_serial     : in  std_logic;
         reset           : in  std_logic;
         clock           : in  std_logic;
         paridade_ok     : out std_logic;
         dados_ascii     : out  std_logic_vector(6 downto 0);
         registrador     : out std_logic_vector(10 downto 0);  -- Depuracao
         saidas_estado   : out std_logic_vector(3 downto 0);  -- Depuracao
         contador_bits   : out std_logic_vector(3 downto 0); --Depuracao
         display_primeiro: out std_logic_vector(0 to 6); --apresentar display
         display_segundo : out std_logic_vector(0 to 6); --apresentar display
         fim_operacao    : out std_logic);
  end component;

  component transmissao_serial is
    port(dados_ascii	 : in  std_logic_vector(6 downto 0);
        partida		 : in  std_logic;
        reset		    : in  std_logic;
        clock		    : in  std_logic;
        dado_serial   : out std_logic;
        registrador	 : out std_logic_vector(11 downto 0);	-- Depuracao
        saidas_estado : out std_logic_vector(4 downto 0);	-- Depuracao
        pronto		    : out std_logic);
  end component;
begin

end uart ; -- uart