-- VHDL do Sistema Digital

library ieee;
use ieee.std_logic_1164.all;

entity sistema_digital is
	port(dado_serial   : in  std_logic;
		  partida		 : in  std_logic;
		  reset		    : in  std_logic;
		  clock		    : in  std_logic;
		  dados_ascii	 : out  std_logic_vector(6 downto 0);
		  registrador	 : out std_logic_vector(10 downto 0);	-- Depuracao
		  saidas_estado : out std_logic_vector(4 downto 0);	-- Depuracao
		  fim_operacao  : out std_logic);
end sistema_digital;

architecture exemplo of sistema_digital is 
	
	component fluxo_de_dados is 
		port(dado_serial	: in  std_logic;
			 carrega		: in  std_logic;
			 desloca		: in  std_logic;
			 zera			: in  std_logic;
			 conta	   : in  std_logic;
			 clock		: in  std_logic;
			 dado_ascii	: out std_logic_vector(6 downto 0);
		    saidaQ		: out std_logic_vector(10 downto 0);
	  	    fim			: out std_logic);
	end component;

	component unidade_controle is
		port(clock    : in   std_logic;
			  comeca   : in   std_logic;
			  fim      : in   std_logic;
		     reseta   : in   std_logic;
		     saida    : out  std_logic_vector(4 downto 0));  -- carrega|zera|desloca|conta|pronto
	end component;
	
signal f1 : std_logic;
signal f2 : std_logic_vector(4 downto 0);
signal f3 : std_logic_vector(10 downto 0);
	
begin 
	
	k1 : unidade_controle port map (clock, partida, f1, reset, f2);
	k2 : fluxo_de_dados   port map (dado_serial, f2(4), f2(2), f2(3), f2(1), clock, dados_ascii, f3, f1);
				
	registrador   <= f3;
	saidas_estado <= f2;
	fim_operacao  <= f1;

end exemplo;