-- VHDL for message 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity out_of_range_move_message is
  port (clock       : in  std_logic;
        read        : in  std_logic;
        address     : in  std_logic_vector(5 downto 0);
        dataOut     : out std_logic_vector(6 downto 0));
end out_of_range_move_message;

architecture out_of_range_move_message of out_of_range_move_message is

  type memory is array (0 to 61) of std_logic_vector(6 downto 0);
  signal out_of_range_move_mem: memory := ( "1010100", "1100101", "1100011", "1101100", "1100001", "0100000", "1101001", "1101110", "1110110", "1100001",
                                            "1101100", "1101001", "1100100", "1100001", "0101110", "0100000", "1010101", "1110100", "1101001", "1101100",
                                            "1101001", "1111010", "1100101", "0100000", "1110011", "1101111", "1101101", "1100101", "1101110", "1110100",
                                            "1100101", "0100000", "1010001", "0101100", "0100000", "1010111", "0101100", "0100000", "1000101", "0101100",
                                            "0100000", "1000001", "0101100", "0100000", "1010011", "0101100", "0100000", "1000100", "0101100", "0100000",
                                            "1011010", "0101100", "0100000", "1011000", "0100000", "1101111", "1110101", "0100000", "1000011", "0101110",
                                            "0001101", "0001010" );
                                            --Tecla invalida. Utilize somente Q, W, E, A, S, D, Z, X ou C.
begin
 
  process (clock)
  begin
    
  if (clock'event and clock = '1') then

    if (read = '1') then
      dataOut <= out_of_range_move_mem(to_integer(unsigned(address)));
    end if;

  end if;
  end process;

end out_of_range_move_message;