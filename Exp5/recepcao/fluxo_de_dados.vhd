-- VHDL do Fluxo de Dados

library ieee;
use ieee.std_logic_1164.all;

entity fluxo_de_dados is
	port(clock		    : in  std_logic;
		   dado_serial  : in  std_logic;
		   desloca		  : in  std_logic;
		   zera			    : in  std_logic;
		   conta			  : in  std_logic;
		   paridade_ok  : out std_logic;
		   dado_ascii	  : out std_logic_vector(6 downto 0);
		   saidaQ			  : out std_logic_vector(10 downto 0);	--depuracao
		   contador_bits: out std_logic_vector(3 downto 0); --depuracao
		   fim				  : out std_logic);
end fluxo_de_dados;

architecture exemplo of fluxo_de_dados is

	component registrador_deslocamento is 
		port(clock     : in  std_logic; 
         clear     : in  std_logic; 
         shift     : in  std_logic;
				 bit_in    : in  std_logic;
				 tick			 : in  std_logic;
			   paridade  : out std_logic;
			   data_ascii: out std_logic_vector(6 downto 0);
         saida     : out std_logic_vector(10 downto 0));
	end component;
		
	component contador_bits is
		port(clock  : in  std_logic;
			  zera    : in  std_logic;
				conta   : in  std_logic;
				tick		: in  std_logic;
			  contagem: out std_logic_vector(3 downto 0);
			  fim     : out std_logic);
	end component;
	
	component comparador_de_paridade is
		port(paridade_recebida		: in  std_logic;
			   dado_recebido   			: in  std_logic_vector(6 downto 0);
			   indicador_de_paridade: out std_logic);
	end component;

	component contador_tick is
		generic(M: integer);
		port(
			 clk, reset: in std_logic;
			 tick: out std_logic);
 	end component;

signal saida_registrador : std_logic_vector(10 downto 0);	
signal s_ascii: std_logic_vector(6 downto 0);
signal paridade: std_logic;
signal tick: std_logic;


begin
	registrador_deslocamento : registrador_deslocamento port map (clock, zera, desloca, dado_serial, tick, paridade, s_ascii, saida_registrador);
	contador_bits : contador port map (clock, zera, conta, tick, contador_bits, fim);
	comparador_paridade : comparador_de_paridade port map (paridade, s_ascii, paridade_ok);
	gerador_ticks : contador_tick port map (clock, reset, tick);

	saidaQ <= saida_registrador;
	dado_ascii <= s_ascii;
end exemplo;