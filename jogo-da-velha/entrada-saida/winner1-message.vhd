-- VHDL for message 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity winner1_message is
  port (clock       : in  std_logic;
        read        : in  std_logic;
        address     : in  std_logic_vector(4 downto 0);
        dataOut     : out std_logic_vector(6 downto 0));
end winner1_message;

architecture winner1_message of winner1_message is
  
  type memory is array (0 to 18) of std_logic_vector(6 downto 0);
  signal winner1_mem: memory := ( "1001010", "1101111", "1100111", "1100001", "1100100", "1101111", "1110010", "0100000", "0110001", "0100000",
                                  "1110110", "1100101", "1101110", "1100011", "1100101", "1110101", "0100001", "0001101", "0001010");
                                  -- Jogador 1 venceu!
begin
 
  process (clock)
  begin
    
  if (clock'event and clock = '1') then

    if (read = '1') then
      dataOut <= winner1_mem(to_integer(unsigned(address)));
    end if;

  end if;
  end process;

end winner1_message;