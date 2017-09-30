-- VHDL do Fluxo de Dados

library ieee;
use ieee.std_logic_1164.all;

entity fluxo_de_dados is
	port(dados_ascii: in  std_logic_vector(6 downto 0);
		   carrega    : in  std_logic;
		   desloca    : in  std_logic;
		   zera       : in  std_logic;
		   conta      : in  std_logic;
			 clock      : in  std_logic;
			 tick				: in  std_logic;
		   dado_serial: out std_logic;
		   saidaQ     : out std_logic_vector(11 downto 0);
		   fim        : out std_logic);
end fluxo_de_dados;

architecture fluxo_dados of fluxo_de_dados is

	component registrador_deslocamento is 
		port(clock      : in  std_logic; 
			   load       : in  std_logic; 
				 shift      : in  std_logic;
				 tick 			: in  std_logic;
			   entrada    : in  std_logic_vector(6 downto 0);
			   bit_out    : out std_logic;
			   saida      : out std_logic_vector(11 downto 0));
	end component;
		
	component contador is
		port(clock     : in  std_logic;
			   zera      : in  std_logic;
			 	 conta     : in  std_logic;
		 		 tick			 : in  std_logic;
			   contagem  : out std_logic_vector(3 downto 0);
			   fim       : out std_logic);
	end component;
	
signal saida_registrador : std_logic_vector(11 downto 0);
signal contagem : std_logic_vector(3 downto 0);

begin 
	registrador : registrador_deslocamento port map (clock, carrega, desloca, tick, dados_ascii, dado_serial, saida_registrador);
	contador : contador port map (clock, zera, conta, tick, contagem, fim);
	
	saidaQ <= saida_registrador;	
end fluxo_dados;