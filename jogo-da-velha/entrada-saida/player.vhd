-- VHDL to decide who plays in each round

library ieee;
use ieee.std_logic_1164.all;

entity player is 
  port (changePlayer: in  std_logic;
        player      : out std_logic := '0');
end player;

architecture player of player is

  signal s_player: std_logic := '0';

  begin
	 process(changePlayer)
	 begin
    if (changePlayer = '1') then
      s_player <= not (s_player);
    end if;
	 end process;
    
    player <= s_player;
end player;