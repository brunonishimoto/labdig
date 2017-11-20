-- VHDL to convert the data received from modem to ASCII

library ieee;
use ieee.std_logic_1164.all;

entity convert_protocol_to_move is
  port(dataReceived: in  std_logic_vector(6 downto 0);
       player      : out std_logic;
       status      : out std_logic;
       move        : out std_logic_vector(6 downto 0));
end convert_protocol_to_move;

architecture convert_protocol_to_move of convert_protocol_to_move is

  begin
    player <= dataReceived(2);
    status <= not (dataReceived(1) or dataReceived(0));
	 
    process (dataReceived)
    begin
      case dataReceived(6 downto 3) is
        when "0000" =>
          move <= "1110001"; -- q
        
        when "0001" =>
          move <= "1110111"; -- w

        when "0010" =>
          move <= "1100101"; -- e

        when "0011" =>
          move <= "1100001"; -- a
        
        when "0100" =>
          move <= "1110011"; -- s
        
        when "0101" =>
          move <= "1100100"; -- d

        when "0110" =>
          move <= "1111010"; -- z

        when "0111" =>
          move <= "1111000"; -- x

        when "1000" =>
          move <= "1100011"; -- c

        when others =>
          move <= "0000000"; -- null
        
        end case;
    end process;

end convert_protocol_to_move;