-- VHDL for tic-tac-toe board 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity invalid_move_message is
  port (clock       : in  std_logic;
        read        : in  std_logic;
        address     : in  std_logic_vector(5 downto 0);
        dataOut     : out std_logic_vector(6 downto 0));
end invalid_move_message;

architecture invalid_move_message of invalid_move_message is

  type memory is array (0 to 34) of std_logic_vector(6 downto 0);
  signal invalid_move_mem: memory := ("1001010", "1101111", "1100111", "1100001", "1100100", "1100001", "0100000", "1101001", "1101110", "1110110",
                                      "1100001", "1101100", "1101001", "1100100", "1100001", "0101110", "0100000", "1001010", "1101111", "1100111",
                                      "1110101", "1100101", "0100000", "1101110", "1101111", "1110110", "1100001", "1101101", "1100101", "1101110",
                                      "1110100", "1100101", "0101110", "0001101", "0001010"); -- Jogada invalida. Jogue novamente.
begin
 
  process (clock)
  begin
    
  if (clock'event and clock = '1') then

    if (read = '1') then
      dataOut <= invalid_move_mem(to_integer(unsigned(address)));
    end if;

  end if;
  end process;

end invalid_move_message;