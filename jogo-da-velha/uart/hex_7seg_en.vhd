-- hex_7seg_en
--             conversor de dados hexadecimais para codigo de 7 segmentos
--             com enable da saida
library ieee;
use ieee.std_logic_1164.all;

entity hex_7seg_en is
	port (
		hex : in std_logic_vector (3 downto 0);
		enable : in std_logic;
		d7seg : out std_logic_vector (6 downto 0)
	);
end hex_7seg_en;

architecture hex_7seg_en of hex_7seg_en is
	signal segmentos :  std_logic_vector(0 to 6);
begin
	
    d7seg <= segmentos;
    
	process (hex,enable)
	begin
		if enable = '0' then
	        segmentos <= "1111111"; -- apaga segmentos
	    else
		case hex is
			when "0000" => segmentos <= "1000000"; -- 0  40 (hexa)
			when "0001" => segmentos <= "1111001"; -- 1  79
			when "0010" => segmentos <= "0100100"; -- 2  24
			when "0011" => segmentos <= "0110000"; -- 3  30
			when "0100" => segmentos <= "0011001"; -- 4  19
			when "0101" => segmentos <= "0010010"; -- 5  12
			when "0110" => segmentos <= "0000010"; -- 6  02
			when "0111" => segmentos <= "1011000"; -- 7  58
			when "1000" => segmentos <= "0000000"; -- 8  00
			when "1001" => segmentos <= "0010000"; -- 9  10
			when "1010" => segmentos <= "0001000"; -- A  08
			when "1011" => segmentos <= "0000011"; -- B  03
			when "1100" => segmentos <= "1000110"; -- C  46
			when "1101" => segmentos <= "0100001"; -- D  21
			when "1110" => segmentos <= "0000110"; -- E  06
			when others => segmentos <= "0001110"; -- F  0E
		end case;
		end if;
	end process;
end hex_7seg_en;
