-- receive the move that player didc

library ieee;
use ieee.std_logic_1164.all;

entity convert_symbol is
  port(player: in std_logic;
       symbol: out std_logic_vector(6 downto 0));
end convert_symbol;

architecture convert_symbol of convert_symbol is
  
  begin
    process (player) --map the palyer with the corresponding symbol (player 0 -> X and player 1 -> O)
    begin
      case player is
        when '0' => -- player 0
          symbol <= "1011000";
        when '1' => -- player 1
          symbol <= "1001111";
      end case;
    end process;

end convert_symbol;