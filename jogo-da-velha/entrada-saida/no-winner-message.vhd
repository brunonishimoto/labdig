-- VHDL for message 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity no_winner_message is
  port (clock       : in  std_logic;
        read        : in  std_logic;
        address     : in  std_logic_vector(3 downto 0);
        dataOut     : out std_logic_vector(6 downto 0));
end no_winner_message;

architecture no_winner_message of no_winner_message is
  type memory is array (0 to 11) of std_logic_vector(6 downto 0);
  signal no_winner_mem: memory := ( "1000100", "1100101", "1110101", "0100000", "1110110", "1100101", "1101100", "1101000", "1100001", "0100001", "0001101", "0001010" );
                                            --Deu velha!
begin
 
  process (clock)
  begin
    
  if (clock'event and clock = '1') then

    if (read = '1') then
      dataOut <= no_winner_mem(to_integer(unsigned(address)));
    end if;

  end if;
  end process;

end no_winner_message;