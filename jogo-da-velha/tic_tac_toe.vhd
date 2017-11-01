-- VHDL for tic-tac-toe

library ieee;
use ieee.std_logic_1164.all;

entity tic_tac_toe is
  port (clock          : in std_logic;
        reset          : in std_logic;
        start          : in std_logic;
        entrada        : in std_logic;
        saida          : out std_logic;
        tickRecepcao   : out std_logic; --depuracao
        tickTransmissao: out std_logic; --depuracao
        endTransmissao : out std_logic; --depuracao
        readBoard      : out std_logic; --depuracao
        endReception   : out std_logic; --depuracao
        writeBoard     : out std_logic; --depuracao
        clearScreen    : out std_logic; --depuracao
		    endOutOfRange  : out std_logic; --depuracao
        symbol         : out std_logic_vector(6 downto 0); -- depuracao
        played         : out std_logic; --depuracao
        stateReception : out std_logic_vector(3 downto 0); --depuracao
        moveReceived   : out std_logic_vector(6 downto 0); --depuracao
        estate         : out std_logic_vector(3 downto 0); --depuracao
        addressToRead  : out std_logic_vector(6 downto 0)); --depuracao
end tic_tac_toe;

architecture tic_tac_toe of tic_tac_toe is
  
  component uart is
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
         prontoTransmissao	 : out std_logic; --depuracao
         prontoRecepcao		   : out std_logic; --depuracao
         paridadeOk				   : out std_logic; --depuracao
         estadoTransSerial	 : out std_logic_vector(4 downto 0); --depuracao
         estadoRecepSerial	 : out std_logic_vector(3 downto 0); --depuracao
         registradorRecepcao : out std_logic_vector(10 downto 0); --depuracao
         dadoRecepcao        : out std_logic_vector(6 downto 0);
         displayUnidade      : out std_logic_vector(6 downto 0);
         displayDezena       : out std_logic_vector(6 downto 0));
  end component;

  component entrada_saida is
    port (clock          : in  std_logic;
          reset          : in  std_logic;
          start          : in  std_logic;
          played         : in  std_logic;
          endTransmission: in  std_logic;
          moveReceived   : in std_logic_vector(6 downto 0);
          readBoard      : out std_logic;
          clearScreen    : out std_logic;
          dataToSend     : out std_logic_vector(6 downto 0);
          writeBoard     : out std_logic; --depuracao
          validMove      : out std_logic; --depuracao
          outOfRange     : out std_logic; --depuracao
          hasWinner      : out std_logic; --depuracao
			    endOutOfRange  : out std_logic; --depuracao
          estate         : out std_logic_vector(3 downto 0); --depuracao
          addressToRead  : out std_logic_vector(6 downto 0)); --depuracao
  end component;

  signal s_symbol: std_logic_vector(6 downto 0); --char read from board
  signal s_readBoard: std_logic; --to transmit one char from board
  signal s_ongoingTransmission: std_logic; --see if we can read next char from board
  signal s_moveReceived: std_logic_vector(6 downto 0); --move received
  signal s_played: std_logic; --see if the player did his play
  signal s_clearScreen: std_logic; --to clean the register that receive datas
  begin

    comp_uart: uart port map (clock, reset, s_readBoard, s_clearScreen, entrada, s_symbol, s_ongoingTransmission, s_played, saida, open, tickRecepcao,
                              tickTransmissao, open, open, endTransmissao, endReception, open, open, stateReception, open, s_moveReceived, open, open);
    
    comp_entrada_saida: entrada_saida port map (clock, reset, start, s_played, not (s_ongoingTransmission), s_moveReceived,
                                                s_readBoard, s_clearScreen, s_symbol, writeBoard, open, open, open, endOutOfRange, estate, addressToRead);

    symbol <= s_symbol;
    readBoard <= s_readBoard;
    moveReceived <= s_moveReceived;
    played <= s_played;
    clearScreen <= s_clearScreen;
end tic_tac_toe;