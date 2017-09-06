-- VHDL de um Registrador de Deslocamento para a direita

library ieee;
use ieee.std_logic_1164.all;

entity registrador_deslocamento is
    port(clock      : in  std_logic; 
         load       : in  std_logic; 
         shift      : in  std_logic;
         RIN        : in  std_logic;
         entrada    : in  std_logic_vector(6 downto 0);
         bit_out    : out std_logic := '1';					
         saida      : out std_logic_vector(11 downto 0));
end registrador_deslocamento;

architecture exemplo of registrador_deslocamento is
signal IQ				: std_logic_vector(11 downto 0);
signal paridade		: std_logic;

begin
	process (clock, load, shift, IQ)
	begin
	
	-- usaremos paridade PAR
	paridade <= entrada(0) xor entrada(1) xor entrada(2) 
				xor entrada(3) xor entrada(4) xor entrada(5) 
				xor entrada (6);
	
	if (clock'event and clock = '1') then
		if (load = '1') then 
			IQ(0) <= '1';						-- bit de repouso
			IQ(1) <= '0';						-- start bit
			IQ(8 downto 2) <= entrada;		-- bits do caractere ASCII
			IQ(9) <= paridade;				-- paridade
			IQ(11 downto 10) <= "11";		-- stop bits
		end if;
		
		if (shift = '1') then 
			bit_out <= IQ(0);
			IQ <= RIN & IQ(11 downto 1);
		end if;
    end if;
    
    saida <= IQ;     
	end process;
end exemplo;