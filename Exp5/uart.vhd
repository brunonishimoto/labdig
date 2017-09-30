-- VHDL for UART 

library ieee;
use ieee.std_logic_1164.all;

entity uart is
  port(clock               : in std_logic;
       reset               : in std_logic;
       transmiteDado       : in std_logic;
       recebeDado          : in std_logic;
       entrada             : in std_logic;
       dadoTransmissao     : in std_logic_vector(6 downto 0);
       transmissaoAndamento: out std_logic;
       temDadoRecepcao     : out std_logic;
       saida               : out std_logic;
       startTickRecepcao   : out std_logic; --depuracao
       tickRecepcao        : out std_logic; --depuracao
       tickTransmissao     : out std_logic; --depuracao
       dadoRecepcao        : out std_logic_vector(6 downto 0));
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
         estadoRecepcao       : out std_logic_vector(1 downto 0);  --sinal de depuracao
         estadoTransmissao    : out std_logic_vector(1 downto 0)); --sinal de depuracao
  end component;

  component recepcao_serial is
    port(dado_serial  : in  std_logic;
         reset        : in  std_logic;
         clock        : in  std_logic;
         paridade_ok  : out std_logic;
         dados_ascii  : out  std_logic_vector(6 downto 0);
         registrador  : out std_logic_vector(10 downto 0); -- Depuracao
         saidas_estado: out std_logic_vector(3 downto 0);  -- Depuracao
         contador_bits: out std_logic_vector(3 downto 0);  --Depuracao
         tickStartBit : out std_logic; --Depuracao
         tickBit      : out std_logic; --Depuracao
         fim_operacao : out std_logic);
  end component;

  component transmissao_serial is
    port(dados_ascii : in  std_logic_vector(6 downto 0);
        partida      : in  std_logic;
        reset        : in  std_logic;
        clock        : in  std_logic;
        dado_serial  : out std_logic;
        registrador  : out std_logic_vector(11 downto 0);	-- Depuracao
        saidas_estado: out std_logic_vector(4 downto 0);	-- Depuracao
        geradorTick  : out std_logic; --Depuracao
        pronto       : out std_logic);
  end component;

  signal s_dadoRecebido      : std_logic_vector(6 downto 0);
  signal s_dadoTransmitido  : std_logic_vector(6 downto 0);
  signal s_paridadeOk        : std_logic;
  signal s_prontoRecepcao    : std_logic;
  signal s_prontoTransmissao : std_logic;
  signal s_partidaTransmissao: std_logic;
  

begin

  interfaceModule: interface port map(clock, reset, s_dadoRecebido, s_prontoRecepcao, s_paridadeOk, s_prontoTransmissao, recebeDado,
                                      transmiteDado, dadoTransmissao, s_partidaTransmissao, s_dadoTransmitido, dadoRecepcao, temDadoRecepcao,
                                      transmissaoAndamento, open, open);
  
  transmisssaModule: transmissao_serial port map(s_dadoTransmitido, s_partidaTransmissao, reset, clock, saida, open, open, tickTransmissao, s_prontoTransmissao);

  recepcaoModule: recepcao_serial port map(entrada, reset, clock, s_paridadeOk, s_dadoRecebido, open, open, open, startTickRecepcao, tickRecepcao, s_prontoRecepcao);

end uart ;