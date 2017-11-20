-- VHDL to convert move to protocol

library ieee;
use ieee.std_logic_1164.all;

entity convert_move_to_protocol is
  port (move      : in  std_logic_vector(6 downto 0);
        player    : in  std_logic;
        status    : in  std_logic;
        dataToSend: out std_logic_vector(6 downto 0));
end convert_move_to_protocol;

architecture convert_move_to_protocol of convert_move_to_protocol is

  begin
    dataToSend(1 downto 0) <= not(status) & not(status);
    dataToSend(2) <= player;

    process (move)
    begin
      case move is
        when "1110001" => -- q
        dataToSend(6 downto 3) <= "0000"; 
      
      when "1110111" => -- w
        dataToSend(6 downto 3) <= "0001";

      when "1100101" => -- e
        dataToSend(6 downto 3) <= "0010";

      when "1100001" => -- a
        dataToSend(6 downto 3) <= "0011";
      
      when "1110011" => -- s
        dataToSend(6 downto 3) <= "0100";
      
      when "1100100" => -- d
        dataToSend(6 downto 3) <= "0101";

      when "1111010" => -- z
        dataToSend(6 downto 3) <= "0110";

      when "1111000" => -- x
        dataToSend(6 downto 3) <= "0111";

      when "1100011" => -- c
        dataToSend(6 downto 3) <= "1000";

      when others =>
        dataToSend(6 downto 3) <= "1111"; -- invalid
      
      end case;
  end process;
end convert_move_to_protocol;