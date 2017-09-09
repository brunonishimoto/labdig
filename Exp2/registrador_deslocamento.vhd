-- VHDL de um Registrador de Deslocamento para a direita

library ieee;
use ieee.std_logic_1164.all;

entity registrador_deslocamento is
    port(clock      : in  std_logic; 
         load       : in  std_logic; 
         shift      : in  std_logic;
         bit_in     : in  std_logic;
			paridade   : out std_logic;
			data_ascii : out std_logic_vector(6 downto 0);
         saida      : out std_logic_vector(10 downto 0));
end registrador_deslocamento;

architecture exemplo of registrador_deslocamento is
signal IQ				: std_logic_vector(10 downto 0) := "00000000000";
signal data_bit		: std_logic;

begin
	process (clock, load, shift, IQ)
	begin
	
	if (clock'event and clock = '1') then
		if (load = '1') then
			data_bit <= bit_in;	--bit serial
		end if;
		
		if (shift = '1') then	--desloca e acrescenta o bit de entrada
			IQ <= data_bit & IQ(10 downto 1);
		end if;
	 
	   data_ascii <= IQ(7 downto 1);
	 
	   -- usaremos paridade PAR
	   paridade <= IQ(1) xor IQ(2) xor IQ(3) 
				xor IQ(4) xor IQ(5) xor IQ(6) 
				xor IQ(7);
				
	 end if;
    
    saida <= IQ;     
	end process;
end exemplo;