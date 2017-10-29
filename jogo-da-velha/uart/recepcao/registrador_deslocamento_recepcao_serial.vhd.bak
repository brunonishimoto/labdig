-- VHDL de um Registrador de Deslocamento para a direita

library ieee;
use ieee.std_logic_1164.all;

entity registrador_deslocamento_recepcao_serial is
    port(clock      : in  std_logic; 
         clear      : in  std_logic; 
         shift      : in  std_logic;
				 bit_in     : in  std_logic;
				 tick				: in  std_logic;
				 paridade   : out std_logic;
				 data_ascii : out std_logic_vector(6 downto 0);
         saida      : out std_logic_vector(10 downto 0));
end registrador_deslocamento_recepcao_serial;

architecture registrdor of registrador_deslocamento_recepcao_serial is
signal IQ: std_logic_vector(10 downto 0) := "00000000000";

begin
	process (clock, clear, shift, IQ)
	begin
	if (clear = '1') then
		IQ <= (others => '0');
	elsif (clock'event and clock = '1') then
		if (shift = '1' and tick = '1') then	--desloca e acrescenta o bit de entrada
			IQ <= bit_in & IQ(10 downto 1);
		end if;
	 
	   data_ascii <= IQ(7 downto 1);
		
		--bit de paridade vem depois dos bits de dados
	   paridade <= IQ(8);
	end if;
    
		saida <= IQ;     
	end process;
end registrdor;