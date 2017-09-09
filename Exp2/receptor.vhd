-- VHDL do receptor dos dados seriais

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity receptor is
    port(clock			: in std_logic;
			bit_in      : in  std_logic;
         fim_operacao: in  std_logic;
         saida       : out std_logic);
end receptor;

architecture exemplo of receptor is

	component ativador is 
		port(set     : in  std_logic;
           reset   : in  std_logic;
           ativa   : out std_logic := '0');
	end component;
		
	component contador_mod_quatro is
		port(clock     : in  std_logic;
			  zera      : in  std_logic;
			  conta     : in  std_logic;
			  fim       : out std_logic);
	end component;
	
	component inversor_sincrono is
		port(clock   : in  std_logic;
           saida   : out  std_logic := '0');
	end component;
	
	signal ativa: std_logic;
	signal fim_contagem: std_logic;
	
	begin
		r1: ativador port map (bit_in, fim_operacao, ativa);
		r2: contador_mod_quatro port map (clock, fim_operacao, ativa, fim_contagem);
		r3: inversor_sincrono port map (fim_contagem, saida);
end exemplo;