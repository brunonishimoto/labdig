-- VHDL do Fluxo de Dados

library ieee;
use ieee.std_logic_1164.all;

entity fluxo_de_dados is
	port(dado_serial	 : in  std_logic;
		  carrega		 : in  std_logic;
		  desloca		 : in  std_logic;
		  zera			 : in  std_logic;
		  conta			 : in  std_logic;
		  clock			 : in  std_logic;
		  dado_ascii	 : out std_logic_vector(6 downto 0);
		  saidaQ			 : out std_logic_vector(10 downto 0);
		  fim				 : out std_logic);
end fluxo_de_dados;

architecture exemplo of fluxo_de_dados is

	component registrador_deslocamento is 
		port(clock      : in  std_logic; 
           load       : in  std_logic; 
           shift      : in  std_logic;
           bit_in     : in  std_logic;
			  data_ascii : out std_logic_vector(6 downto 0);	  
           saida      : out std_logic_vector(10 downto 0));
	end component;
		
	component contador is
		port(clock     : in  std_logic;
			  zera      : in  std_logic;
			  conta     : in  std_logic;
			  contagem  : out std_logic_vector(3 downto 0);
			  fim       : out std_logic);
	end component;
	
	component receptor is
		port (clock			: in std_logic;
				bit_in      : in  std_logic;
				fim_operacao: in  std_logic;
				saida       : out std_logic);
	end component;

signal generated_clock: std_logic;
signal s1 : std_logic_vector(10 downto 0);	
signal s3 : std_logic_vector(3 downto 0);

begin
	g1 : receptor port map (clock, dado_serial, zera, generated_clock);
	g2 : registrador_deslocamento port map (generated_clock, carrega, desloca, dado_serial, dado_ascii, s1);
	g3 : contador port map (generated_clock, zera, conta, s3, fim);
	
	saidaQ <= s1;	
end exemplo;