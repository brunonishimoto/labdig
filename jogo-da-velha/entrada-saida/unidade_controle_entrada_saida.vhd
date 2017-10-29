-- VHDL for unidade de controle of input/output

library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle_entrada_saida is
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
end unidade_controle_entrada_saida;

architecture uc_entrada_saida of unidade_controle_entrada_saida is
  type tipo_estado is (initial, drawBoard, waitMove, registerMove, analyzeMove, checkEndGame, clear, invalidMoveMessage, outOfRangeMessage, winnerMessage,
                       resetGame, noWinnerMessage);
  signal estado: tipo_estado;

  begin 
    process (clock, reset, estado)
    begin
      if (reset = '1') then
        estado <= initial;
      elsif (clock'event and clock = '1') then
        case estado is 
          when initial => -- wait for start
            if (start = '1') then
              estado <= drawBoard;
            end if;

          when drawBoard => --draw the board
            if (endDraw = '1') then
              estado <= waitMove;
            end if;
          
          when waitMove => --wait for any move
            if (played = '1') then
              estado <= registerMove;
            end if;
          
          when registerMove => --register move received
            if (outOfRange = '1') then
              estado <= outOfRangeMessage;
            else
              estado <= analyzeMove;
            end if;
          
          when analyzeMove => -- regiter move received
            if (invalidMove = '1') then
              estado <= invalidMoveMessage;
            else
              estado <= checkEndGame;
            end if;

          when checkEndGame => --see if there is a winner
            if (hasWinner = '1') then
              estado <= winnerMessage;
            elsif (endGame = '1') then
              estado <= noWinnerMessage;
            else
              estado <= clear;
            end if;
          
          when clear => --clear screen to draw new board
            if (endClear = '1') then
              estado <= drawBoard;
            end if;
          
          when invalidMoveMessage => --send message of invalid move
            if (endInvalidMessage = '1') then
              estado <= waitMove;
            end if;

          when outOfRangeMessage => --send message of invalid key pressed
            if (endOutOfRangeMessage = '1') then
              estado <= waitMove;
            end if;
          
          when winnerMessage => --send a message that the player won the game
            if (endWinnerMessage = '1') then
              estado <= resetGame;
            end if;
          
          when noWinnerMessage => --end a message that no one won the game
            if (endNoWinnerMessage = '1') then
              estado <= resetGame;
            end if;
          
          when resetGame => --clear the board in memory
            estado <= initial;
          
          when others =>
            estado <= initial;
        
        end case;
      end if;
    end process;

    process (estado)
    begin
      case estado is
        when initial =>
          readBoard <= '0';
          writeBoard <= '0';
          clearScreen <= '0';
          writeInvalidMessage <= '0';
          writeOutOfRangeMessage <= '0';
          writeNoWinnerMessage <= '0';
          writeWinnerMessage <= '0';
          resetFD <= '0';
          estate <= "0000";
        when drawBoard =>
          readBoard <= '1';
          writeBoard <= '0';
          clearScreen <= '0';
          writeInvalidMessage <= '0';
          writeOutOfRangeMessage <= '0';
          writeNoWinnerMessage <= '0';
          writeWinnerMessage <= '0';
          resetFD <= '0';
          estate <= "0001";
        when waitMove =>
          readBoard <= '0';
          writeBoard <= '0';
          clearScreen <= '0';
          writeInvalidMessage <= '0';
          writeOutOfRangeMessage <= '0';
          writeNoWinnerMessage <= '0';
          writeWinnerMessage <= '0';
          resetFD <= '0';
          estate <= "0010";
        when registerMove =>
          readBoard <= '0';
          writeBoard <= '1';
          clearScreen <= '0';
          writeInvalidMessage <= '0';
          writeOutOfRangeMessage <= '0';
          writeNoWinnerMessage <= '0';
          writeWinnerMessage <= '0';
          resetFD <= '0';
          estate <= "0011";
        when checkEndGame =>
          readBoard <= '0';
          writeBoard <= '0';
          clearScreen <= '0';
          writeInvalidMessage <= '0';
          writeOutOfRangeMessage <= '0';
          writeNoWinnerMessage <= '0';
          writeWinnerMessage <= '0';
          resetFD <= '0';
          estate <= "0100";
        when clear =>
          readBoard <= '0';
          writeBoard <= '0';
          clearScreen <= '1';
          writeInvalidMessage <= '0';
          writeOutOfRangeMessage <= '0';
          writeNoWinnerMessage <= '0';
          writeWinnerMessage <= '0';
          resetFD <= '0';
          estate <= "0101";
        when invalidMoveMessage =>
          readBoard <= '0';
          writeBoard <= '0';
          clearScreen <= '0';
          writeInvalidMessage <= '1';
          writeOutOfRangeMessage <= '0';
          writeNoWinnerMessage <= '0';
          writeWinnerMessage <= '0';
          resetFD <= '0';
          estate <= "0110";
        when outOfRangeMessage =>
          readBoard <= '0';
          writeBoard <= '0';
          clearScreen <= '0';
          writeInvalidMessage <= '0';
          writeOutOfRangeMessage <= '1';
          writeNoWinnerMessage <= '0';
          writeWinnerMessage <= '0';
          resetFD <= '0';
          estate <= "0111";
        when noWinnerMessage =>
          readBoard <= '0';
          writeBoard <= '0';
          clearScreen <= '0';
          writeInvalidMessage <= '0';
          writeOutOfRangeMessage <= '0';
          writeNoWinnerMessage <= '1';
          writeWinnerMessage <= '0';
          resetFD <= '0';
          estate <= "1000";
        when winnerMessage => 
          readBoard <= '0';
          writeBoard <= '0';
          clearScreen <= '0';
          writeInvalidMessage <= '0';
          writeOutOfRangeMessage <= '0';
          writeNoWinnerMessage <= '0';
          writeWinnerMessage <= '1';
          resetFD <= '0';
          estate <= "1001";
        when resetGame =>
          readBoard <= '0';
          writeBoard <= '0';
          clearScreen <= '0';
          writeInvalidMessage <= '0';
          writeOutOfRangeMessage <= '0';
          writeNoWinnerMessage <= '0';
          writeWinnerMessage <= '0';
          resetFD <= '1';
          estate <= "1010";
        when analyzeMove =>
        readBoard <= '0';
        writeBoard <= '0';
        clearScreen <= '0';
        writeInvalidMessage <= '0';
        writeOutOfRangeMessage <= '0';
        writeNoWinnerMessage <= '0';
        writeWinnerMessage <= '0';
        resetFD <= '0';
        estate <= "1011";
      end case;
    end process;
end  uc_entrada_saida;
            
