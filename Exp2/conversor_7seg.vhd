library ieee;
use ieee.std_logic_1164.all;

entity conversor_7seg is
	port (
		number : in std_logic_vector(3 downto 0);
		enable : in std_logic;
		display: out std_logic_vector(0 to 6));
end conversor_7seg;

architecture conversor_7seg_arch of conversor_7seg is
	signal a_to_g :  std_logic_vector(0 to 6);
begin
	
    display <= a_to_g;
    
	process (number,enable)
		variable x: std_logic_vector(3 downto 0);
	begin
		if enable = '0' then
	        a_to_g <= "1111111"; -- apaga segmentos
	    else
		case number is
			when "0000" => a_to_g <= "0000001"; -- 0
			when "0001" => a_to_g <= "1001111"; -- 1
			when "0010" => a_to_g <= "0010010"; -- 2
			when "0011" => a_to_g <= "0000110"; -- 3
			when "0100" => a_to_g <= "1001100"; -- 4
			when "0101" => a_to_g <= "0100100"; -- 5
			when "0110" => a_to_g <= "0100000"; -- 6
			when "0111" => a_to_g <= "0001101"; -- 7
			when "1000" => a_to_g <= "0000000"; -- 8
			when "1001" => a_to_g <= "0000100"; -- 9
			when "1010" => a_to_g <= "0001000"; -- A
			when "1011" => a_to_g <= "1100000"; -- B
			when "1100" => a_to_g <= "0110001"; -- C
			when "1101" => a_to_g <= "1000010"; -- D
			when "1110" => a_to_g <= "0110000"; -- E
			when others => a_to_g <= "0111000"; -- F
		end case;
		end if;
	end process;
end conversor_7seg_arch;