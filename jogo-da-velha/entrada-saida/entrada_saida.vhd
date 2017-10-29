-- VDHL for entrada_saida of tic-tac-toe game

library ieee;
use ieee.std_logic_1164.all;

entity entrada_saida is
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
        estate         : out std_logic_vector(3 downto 0); --depuracao
        addressToRead  : out std_logic_vector(6 downto 0)); --depuracao
end entrada_saida;

architecture entrada_saida of entrada_saida is 
  component unidade_controle_entrada_saida is
    port(clock                 : in  std_logic;
         reset                 : in  std_logic;
         start                 : in  std_logic;
         endDraw               : in  std_logic;
         endClear              : in  std_logic;
         endInvalidMessage     : in  std_logic;
         endOutOfRangeMessage  : in  std_logic;
         endNoWinnerMessage    : in  std_logic;
         endWinnerMessage      : in  std_logic;
         endGame               : in  std_logic;
         played                : in  std_logic;
         hasWinner             : in  std_logic;
         invalidMove           : in  std_logic;
         outOfRange            : in  std_logic;
         readBoard             : out std_logic;
         writeBoard            : out std_logic;
         clearScreen           : out std_logic;
         writeInvalidMessage   : out std_logic;
         writeOutOfRangeMessage: out std_logic;
         writeNoWinnerMessage  : out std_logic;
         writeWinnerMessage    : out std_logic;
         resetFD               : out std_logic;
         estate                : out std_logic_vector(3 downto 0)); --depuracao
  end component;

  component fluxo_dados_entrada_saida is
    port( clock                 : in  std_logic;
          reset                 : in  std_logic;
          readBoard             : in  std_logic;
          writeBoard            : in  std_logic;
          clearScreen           : in  std_logic;
          checkWinner           : in  std_logic;
          writeInvalidMessage   : in  std_logic;
          writeOutOfRangeMessage: in std_logic;
          writeNoWinnerMessage  : in  std_logic;
          writeWinnerMessage    : in  std_logic;
          moveReceived          : in  std_logic_vector(6 downto 0);
          endDraw               : out std_logic;
          endClear              : out std_logic;
          endInvalidMessage     : out std_logic;
          endOutOfRangeMessage  : out std_logic;
          endNoWinnerMessage    : out std_logic;
          endWinnerMessage      : out std_logic;
          endGame               : out std_logic;
          validMove             : out std_logic;
          outOfRangeMove        : out std_logic;
          hasWinner             : out std_logic;
          dataToSend            : out std_logic_vector(6 downto 0);
          dep_player            : out std_logic; --depuracao
          dep_addressToRead     : out std_logic_vector(6 downto 0); --depuracao
          dep_addressToWrite    : out std_logic_vector(6 downto 0); --depuracao
          dep_address           : out std_logic_vector(6 downto 0); --depuracao
          dep_symbolToTransmit  : out std_logic_vector(6 downto 0)); --depuracao
  end component;

    signal s_writeBoard            : std_logic;
    signal s_readBoard             : std_logic;
    signal s_clearScreen           : std_logic;
    signal s_endDraw               : std_logic;
    signal s_endClear              : std_logic;
    signal s_checkWinner           : std_logic;
    signal s_validMove             : std_logic;
    signal s_outOfRangeMove        : std_logic;
    signal s_writeInvalidMessage   : std_logic;
    signal s_writeOutOfRangeMessage: std_logic;
    signal s_writeNoWinnerMessage  : std_logic;
    signal s_writeWinnerMessage    : std_logic;
    signal s_endInvalidMessage     : std_logic;
    signal s_endOutOfRangeMessage  : std_logic;
    signal s_hasWinner             : std_logic;
    signal s_endGame               : std_logic;
    signal s_endNoWinnerMessage    : std_logic;
    signal s_endWinnerMessage      : std_logic;
    signal s_resetFD               : std_logic;
  begin

    uc: unidade_controle_entrada_saida port map (clock, reset, start, s_endDraw, s_endClear, s_endInvalidMessage, s_endOutOfRangeMessage, s_endNoWinnerMessage, 
                                                 s_endWinnerMessage, s_endGame, played, s_hasWinner, not(s_validMove), s_outOfRangeMove, s_readBoard, 
                                                 s_writeBoard, s_clearScreen,  s_writeInvalidMessage, s_writeOutOfRangeMessage, 
                                                 s_writeNoWinnerMessage, s_writeWinnerMessage, s_resetFD, estate);
    fd: fluxo_dados_entrada_saida port map (clock, reset or s_resetFD, s_readBoard and endTransmission, s_writeBoard, s_clearScreen, s_checkWinner, s_writeInvalidMessage,
                                            s_writeOutOfRangeMessage, s_writeNoWinnerMessage, s_writeWinnerMessage, moveReceived, s_endDraw, s_endClear, s_endInvalidMessage, s_endOutOfRangeMessage,
                                            s_endNoWinnerMessage, s_endWinnerMessage, s_endGame, s_validMove, s_outOfRangeMove, s_hasWinner, dataToSend, open, addressToRead, open, open, open);

    readBoard <= s_readBoard;
    writeBoard <= s_writeBoard;
    clearScreen <= s_clearScreen;
    validMove <= s_validMove;
    outOfRange <= s_outOfRangeMove;
    hasWinner <= s_hasWinner;
end  entrada_saida;