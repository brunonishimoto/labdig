-- VHDL for fluxo de dados of input/output

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fluxo_dados_entrada_saida is
  port(clock                 : in  std_logic;
       reset                 : in  std_logic;
       readBoard             : in  std_logic;
       writeBoard            : in  std_logic;
       clearScreen           : in  std_logic;
       checkWinner           : in  std_logic;
       writeInvalidMessage   : in  std_logic;
       writeOutOfRangeMessage: in  std_logic;
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
end fluxo_dados_entrada_saida;

architecture fd_entrada_saida of fluxo_dados_entrada_saida is

  component board is
    port (clock       : in  std_logic;
          reset       : in  std_logic;
          write       : in  std_logic;
          address     : in  std_logic_vector(6 downto 0);
          dataIn      : in  std_logic_vector(6 downto 0);
          successWrite: out std_logic;
          hasWinner   : out std_logic;
          dataOut     : out std_logic_vector(6 downto 0));
  end component;

  component counter is
    generic (module: unsigned);
    port(clock     : in  std_logic;
         clear     : in  std_logic;
			   count     : in  std_logic;
         counter   : out std_logic_vector(6 downto 0);
         end_count : out std_logic);
  end component;

  component convert_symbol is
    port(player: in std_logic;
         symbol: out std_logic_vector(6 downto 0));
  end component;

  component convert_move is
    port (char      : in std_logic_vector(6 downto 0);
          outOfRange: out std_logic;
          address   : out std_logic_vector(6 downto 0));
  end component;

  component player is 
    port (changePlayer: in  std_logic;
          player      : out std_logic := '0');
  end component;

  component mux_7bits is
    port(selector: in  std_logic;
         data1   : in  std_logic_vector(6 downto 0);
         data2   : in  std_logic_vector(6 downto 0);
         dataOut : out std_logic_vector(6 downto 0));
  end component;

  component mux_8in_7bits is
    port(selector: in  std_logic_vector(6 downto 0);
         data1   : in  std_logic_vector(6 downto 0);
         data2   : in  std_logic_vector(6 downto 0);
         data3   : in  std_logic_vector(6 downto 0);
         data4   : in  std_logic_vector(6 downto 0);
         data5   : in  std_logic_vector(6 downto 0);
         data6   : in  std_logic_vector(6 downto 0);
         data7   : in  std_logic_vector(6 downto 0);
         data8   : in  std_logic_vector(6 downto 0);
         dataOut : out std_logic_vector(6 downto 0));
  end component;

  component invalid_move_message is
    port (clock       : in  std_logic;
          read        : in  std_logic;
          address     : in  std_logic_vector(5 downto 0);
          dataOut     : out std_logic_vector(6 downto 0));
  end component;

  component out_of_range_move_message is
    port (clock       : in  std_logic;
          read        : in  std_logic;
          address     : in  std_logic_vector(5 downto 0);
          dataOut     : out std_logic_vector(6 downto 0));
  end component;

  component no_winner_message is
    port (clock       : in  std_logic;
          read        : in  std_logic;
          address     : in  std_logic_vector(3 downto 0);
          dataOut     : out std_logic_vector(6 downto 0));
  end component;

  component winner1_message is
    port (clock       : in  std_logic;
          read        : in  std_logic;
          address     : in  std_logic_vector(4 downto 0);
          dataOut     : out std_logic_vector(6 downto 0));
  end component;

  component winner2_message is
    port (clock       : in  std_logic;
          read        : in  std_logic;
          address     : in  std_logic_vector(4 downto 0);
          dataOut     : out std_logic_vector(6 downto 0));
  end component;

  signal s_addressToRead: std_logic_vector(6 downto 0);
  signal s_addressToWrite: std_logic_vector(6 downto 0);
  signal s_address: std_logic_vector(6 downto 0);
  signal s_symbolToWrite : std_logic_vector(6 downto 0);
  signal s_player: std_logic := '0';
  signal s_symbolBoard: std_logic_vector(6 downto 0);
  signal s_symbolToTransmit: std_logic_vector(6 downto 0);
  signal s_validMove: std_logic;
  signal s_outOfRangeMove: std_logic;
  signal s_hasWinner: std_logic;
  signal s_positionInvalidMessage, s_positionOutOfRangeMessage, s_positionNoWinnerMessage, s_positionWinnerMessage: std_logic_vector(6 downto 0);
  signal s_charInvalidMessage, s_charOutOfRangeMessage, s_charNoWinnerMessage, s_charWinner1Message, s_charWinner2Message, s_char: std_logic_vector(6 downto 0);
  signal s_charWinner, s_charInvalidMove: std_logic_vector(6 downto 0);
  signal s_dataToSend: std_logic_vector(6 downto 0);
  signal s_selector: std_logic_vector(6 downto 0);

  begin

    s_selector <= (writeWinnerMessage and s_player) & (writeWinnerMessage and not s_player) & writeNoWinnerMessage & writeInvalidMessage & writeOutOfRangeMessage & "00";

    counter_symbols: counter generic map (module => to_unsigned(72, 7)) port map (clock, reset or clearScreen, readBoard, s_addressToRead, endDraw);
    board_tic_tac_toe: board port map (clock, reset, writeBoard and not(s_outOfRangeMove), s_address, s_symbolToWrite, s_validMove, s_hasWinner, s_symbolBoard);

    move_to_address: convert_move port map (moveReceived, s_outOfRangeMove, s_addressToWrite);
    change_player: player port map (s_validMove, s_player);
    player_to_symbol: convert_symbol port map (s_player, s_symbolToWrite);
    select_address: mux_7bits port map (writeBoard, s_addressToRead, s_addressToWrite, s_address);

    counter_plays: counter generic map (module => to_unsigned(9, 7)) port map (clock, reset, s_validMove, open, endGame);

    counter_backspaces: counter generic map (module => to_unsigned(72, 7)) port map (clock, reset or readBoard, clearScreen, open, endClear);
    select_symbolToTransmit: mux_7bits port map (clearScreen, s_symbolBoard, "0001000", s_symbolToTransmit); --select between the symbol in board, or backspace (to clear screen);

    --message for invalid move
    counter_invalid_message: counter generic map (module => to_unsigned(35, 7)) port map (clock, reset, writeInvalidMessage, s_positionInvalidMessage, endInvalidMessage);
    invalid_move: invalid_move_message port map(clock, writeInvalidMessage, s_positionInvalidMessage(5 downto 0), s_charInvalidMessage);

    --message for out of range move
    counter_out_of_range_message: counter generic map (module => to_unsigned(62,7)) port map (clock, reset, writeOutOfRangeMessage, s_positionOutOfRangeMessage, endOutOfRangeMessage);
    out_of_range_move: out_of_range_move_message port map (clock, writeOutOfRangeMessage, s_positionOutOfRangeMessage(5 downto 0), s_charOutOfRangeMessage);

    --message for end game with no winner
    counter_no_winner_message: counter generic map (module => "0001100") port map (clock, reset, writeNoWinnerMessage, s_positionNoWinnerMessage, endNoWinnerMessage);
    no_winner: no_winner_message port map (clock, writeNoWinnerMessage, s_positionNoWinnerMessage(3 downto 0), s_charNoWinnerMessage);

    --message for winner
    counter_winner_message: counter generic map (module => to_unsigned(19, 7)) port map (clock, reset, writeWinnerMessage, s_positionWinnerMessage, endWinnerMessage);
    winner1: winner1_message port map (clock, writeWinnerMessage, s_positionWinnerMessage(4 downto 0), s_charWinner1Message);
    winner2: winner2_message port map (clock, writeWinnerMessage, s_positionWinnerMessage(4 downto 0), s_charWinner2Message);
    
    --select what data will be sent
    select_data: mux_8in_7bits port map (s_selector, s_symbolToTransmit, s_charWinner1Message, s_charWinner2Message, s_charNoWinnerMessage, 
                                         s_charInvalidMessage, s_charOutOfRangeMessage, "0111110", "0111100", s_dataToSend);

    dep_addressToRead <= s_addressToRead;
    dep_addressToWrite <= s_addressToWrite;
    dep_address <= s_address;
    dep_symbolToTransmit <= s_symbolToTransmit;
    dep_player <= s_player;
    dataToSend <= s_dataToSend;
    outOfRangeMove <= s_outOfRangeMove;
    validMove <= s_validMove;
    hasWinner <= s_hasWinner;
end fd_entrada_saida;