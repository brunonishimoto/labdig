-- receive the move that player didc

library ieee;
use ieee.std_logic_1164.all;

entity convert_move is
  port (char      : in std_logic_vector(6 downto 0);
        outOfRange: out std_logic;
        address   : out std_logic_vector(6 downto 0));
end convert_move;

architecture convert_move of convert_move is

  begin
    process (char) -- map the move received to the address of memory
    begin
      case char is 
        when "1010001" | "1110001" => -- receive Q or q
          address <= "0000001";
          outOfRange <= '0';
        when "1010111" | "1110111" => -- receive W or w
          address <= "0000101";
          outOfRange <= '0';
        when "1000101" | "1100101" => -- receive E or e
          address <= "0001001";
          outOfRange <= '0';
        when "1000001" | "1100001" => -- receive A or a
          address <= "0011001";
          outOfRange <= '0';
        when "1010011" | "1110011" => -- receive S or s
          address <= "0011101";
          outOfRange <= '0';
        when "1000100" | "1100100" => -- receive D or d
          address <= "0100001";
          outOfRange <= '0';
        when "1011010" | "1111010" => -- receive Z or z
          address <= "0110001";
          outOfRange <= '0';
        when "1011000" | "1111000" => -- receive X or x
          address <= "0110101";
          outOfRange <= '0';
        when "1000011" | "1100011" => -- receive C or c
          address <= "0111001";
          outOfRange <= '0';
        when others =>
          address <= "1111111";
          outOfRange <= '1';
      end case;
    end process;

end convert_move;