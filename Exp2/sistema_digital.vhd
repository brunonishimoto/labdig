-- VHDL do Sistema Digital

library ieee;
use ieee.std_logic_1164.all;

entity sistema_digital is
	port(dado_serial    : in  std_logic;
		  partida		  : in  std_logic;
		  reset		     : in  std_logic;
		  clock		     : in  std_logic;
		  paridade_ok    : out std_logic;
		  dados_ascii	  : out  std_logic_vector(6 downto 0);
		  registrador	  : out std_logic_vector(10 downto 0);	-- Depuracao
		  saidas_estado  : out std_logic_vector(4 downto 0);	-- Depuracao
		  generated_clock: out std_logic; --Depuracao
		  contador_bits  : out std_logic_vector(3 downto 0); --Depuracao
		  fim_operacao   : out std_logic);
end sistema_digital;

architecture exemplo of sistema_digital is 
	
	component fluxo_de_dados is 
		port(clock			  : in  std_logic;
			  dado_serial	  : in  std_logic;
			  carrega		  : in  std_logic;
		     desloca		  : in  std_logic;
			  zera			  : in  std_logic;
			  conta			  : in  std_logic;
			  paridade_ok	  : out std_logic;
			  dado_ascii	  : out std_logic_vector(6 downto 0);
			  saidaQ			  : out std_logic_vector(10 downto 0);	--depuracao
			  generated_clock: out std_logic; --depuracao
			  contador_bits  : out std_logic_vector(3 downto 0); --depuracao
			  fim				  : out std_logic);
	end component;

	component unidade_controle is
		port(clock    : in   std_logic;
			  comeca   : in   std_logic;
			  fim      : in   std_logic;
		     reseta   : in   std_logic;
		     saida    : out  std_logic_vector(4 downto 0));  -- carrega|zera|desloca|conta|pronto
	end component;
	
signal fim : std_logic;
signal estado : std_logic_vector(4 downto 0);
signal f3 : std_logic_vector(10 downto 0);
	
begin 
	
	k1 : unidade_controle port map (clock, partida, fim, reset, estado);
	k2 : fluxo_de_dados   port map (clock, dado_serial, estado(4), estado(2),estado(3), 
											  estado(1), paridade_ok, dados_ascii, f3, generated_clock, contador_bits, fim);
				
	registrador   <= f3;
	saidas_estado <= estado;
	fim_operacao  <= fim;

end exemplo;