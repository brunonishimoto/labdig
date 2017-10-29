-- VHDL for tic-tac-toe board 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity board is
  port (clock       : in  std_logic;
        reset       : in  std_logic;
        write       : in  std_logic;
        address     : in  std_logic_vector(6 downto 0);
        dataIn      : in  std_logic_vector(6 downto 0);
        successWrite: out std_logic;
        hasWinner   : out std_logic;
        dataOut     : out std_logic_vector(6 downto 0));
end board;

architecture board of board is

  type memory is array (0 to 71) of std_logic_vector(6 downto 0);
  signal board_mem: memory := ("0100000", "0100000", "0100000", "1111100", "0100000", "0100000", "0100000", "1111100", "0100000", "0100000", "0001101", "0001010",
                               "0100000", "0101101", "0100000", "0101011", "0100000", "0101101", "0100000", "0101011", "0100000", "0101101", "0001101", "0001010",
                               "0100000", "0100000", "0100000", "1111100", "0100000", "0100000", "0100000", "1111100", "0100000", "0100000", "0001101", "0001010",
                               "0100000", "0101101", "0100000", "0101011", "0100000", "0101101", "0100000", "0101011", "0100000", "0101101", "0001101", "0001010",
                               "0100000", "0100000", "0100000", "1111100", "0100000", "0100000", "0100000", "1111100", "0100000", "0100000", "0001101", "0001010",
										           "0001101", "0001010", "0001101", "0001010", "0001101", "0001010", "0001101", "0001010", "0001101", "0001010", "0001101", "0001010");
begin
 
  process (clock)
  begin
    
  if (clock'event and clock = '1') then
	  if (reset = '1') then
      board_mem <= ("0100000", "0100000", "0100000", "1111100", "0100000", "0100000", "0100000", "1111100", "0100000", "0100000", "0001101", "0001010",
                    "0100000", "0101101", "0100000", "0101011", "0100000", "0101101", "0100000", "0101011", "0100000", "0101101", "0001101", "0001010",
                    "0100000", "0100000", "0100000", "1111100", "0100000", "0100000", "0100000", "1111100", "0100000", "0100000", "0001101", "0001010",
                    "0100000", "0101101", "0100000", "0101011", "0100000", "0101101", "0100000", "0101011", "0100000", "0101101", "0001101", "0001010",
                    "0100000", "0100000", "0100000", "1111100", "0100000", "0100000", "0100000", "1111100", "0100000", "0100000", "0001101", "0001010",
                    "0001101", "0001010", "0001101", "0001010", "0001101", "0001010", "0001101", "0001010", "0001101", "0001010", "0001101", "0001010");
      successWrite <= '0';
    elsif (write = '1') then
      if (board_mem(to_integer(unsigned(address))) = "0100000") then
        board_mem(to_integer(unsigned(address))) <= dataIn;
        successWrite <= '1';
      else 
        successWrite <= '0';
      end if;
    else
      dataOut <= board_mem(to_integer(unsigned(address)));
      successWrite <= '0';
    end if;
    
    if ((board_mem(1)  /= "0100000"  and board_mem(1)  = board_mem(5)  and board_mem(5)  = board_mem(9))  or  --first line
        (board_mem(25) /= "0100000"  and board_mem(25) = board_mem(29) and board_mem(29) = board_mem(33)) or --second line
        (board_mem(49) /= "0100000"  and board_mem(49) = board_mem(53) and board_mem(53) = board_mem(57)) or --third line
        (board_mem(1)  /= "0100000"  and board_mem(1)  = board_mem(25) and board_mem(25) = board_mem(49)) or --first column
        (board_mem(5)  /= "0100000"  and board_mem(5)  = board_mem(29) and board_mem(29) = board_mem(53)) or --second columns
        (board_mem(9)  /= "0100000"  and board_mem(9)  = board_mem(33) and board_mem(33) = board_mem(57)) or --third column
        (board_mem(1)  /= "0100000"  and board_mem(1)  = board_mem(29) and board_mem(29) = board_mem(57)) or --primary diagonal
        (board_mem(9)  /= "0100000"  and board_mem(9)  = board_mem(29) and board_mem(29) = board_mem(49))    --secondary diagonal
       ) then
      hasWinner <= '1';
    else 
      hasWinner <= '0';
    end if;
  end if;
  end process;

end board;