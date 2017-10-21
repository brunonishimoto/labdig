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
       estadoTransInter    : out std_logic_vector(1 downto 0); --depuracao
       estadoRecepInter    : out std_logic_vector(1 downto 0); --depuracao
		 prontoTransmissao	: out std_logic; --depuracao
		 prontoRecepcao		: out std_logic; --depuracao
		 paridadeOk				: out std_logic; --depuracao
		 estadoTransSerial	: out std_logic_vector(4 downto 0); --depuracao
		 estadoRecepSerial	: out std_logic_vector(3 downto 0); --depuracao
		 registradorRecepcao	: out std_logic_vector(10 downto 0); --depuracao
       dadoRecepcao        : out std_logic_vector(6 downto 0);
       displayUnidade      : out std_logic_vector(6 downto 0);
       displayDezena       : out std_logic_vector(6 downto 0));
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
         tick         : out std_logic; --Depuracao
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

  component hex_7seg_en is
    port (
      hex   : in std_logic_vector (3 downto 0);
      enable: in std_logic;
      d7seg : out std_logic_vector (6 downto 0)
    );
  end component;

  signal s_dadoRecebido      : std_logic_vector(6 downto 0);
  signal s_dadoTransmitido   : std_logic_vector(6 downto 0);
  signal s_paridadeOk        : std_logic;
  signal s_prontoRecepcao    : std_logic;
  signal s_prontoTransmissao : std_logic;
  signal s_partidaTransmissao: std_logic;
  signal s_dadoRecepcao      : std_logic_vector(6 downto 0);
  signal s_temDadoRecepcao   : std_logic;

begin

  interfaceModule: interface port map(clock, reset, s_dadoRecebido, s_prontoRecepcao, s_paridadeOk, s_prontoTransmissao, recebeDado,
                                      transmiteDado, dadoTransmissao, s_partidaTransmissao, s_dadoTransmitido, s_dadoRecepcao, s_temDadoRecepcao,
                                      transmissaoAndamento, estadoRecepInter, estadoTransInter);
  
  transmisssaModule: transmissao_serial port map(s_dadoTransmitido, s_partidaTransmissao, reset, clock, saida, open, estadoTransSerial, tickTransmissao, s_prontoTransmissao);

  recepcaoModule: recepcao_serial port map(entrada, reset, clock, s_paridadeOk, s_dadoRecebido, registradorRecepcao, estadoRecepSerial, open, tickRecepcao, s_prontoRecepcao);

  display_unidade: hex_7seg_en port map (s_dadoRecepcao(3 downto 0), s_temDadoRecepcao and not (recebeDado), displayUnidade);
  display_dezena: hex_7seg_en port map ('0' & s_dadoRecepcao(6 downto 4), s_temDadoRecepcao and not (recebeDado), displayDezena);

  temDadoRecepcao <= s_temDadoRecepcao;
  prontoTransmissao <= s_prontoTransmissao;
  paridadeOk <= s_paridadeOk;
  prontoRecepcao <= s_prontoRecepcao;
  dadoRecepcao <= s_dadoRecepcao;
end uart ;