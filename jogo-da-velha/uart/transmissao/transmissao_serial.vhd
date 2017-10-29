-- VHDL do Sistema Digital

library ieee;
use ieee.std_logic_1164.all;

entity transmissao_serial is
	port(dados_ascii	: in  std_logic_vector(6 downto 0);
		  partida		: in  std_logic;
		  reset		   : in  std_logic;
		  clock		   : in  std_logic;
		  dado_serial  : out std_logic;
		  registrador	: out std_logic_vector(11 downto 0);	-- Depuracao
		  saidas_estado: out std_logic_vector(4 downto 0);	-- Depuracao
		  geradorTick	: out std_logic; --Depuracao
		  pronto		   : out std_logic);
end transmissao_serial;

architecture transmissao_serial of transmissao_serial is 
	
	component fluxo_de_dados_transmissao_serial is 
		port(dados_ascii: in  std_logic_vector(6 downto 0);
				 carrega    : in  std_logic;
				 desloca    : in  std_logic;
				 zera       : in  std_logic;
				 conta      : in  std_logic;
				 clock      : in  std_logic;
				 tick			: in  std_logic;
				 dado_serial: out std_logic;
				 saidaQ     : out std_logic_vector(11 downto 0);
				 fim        : out std_logic);
	end component;

	component unidade_controle_transmissao_serial is
		port(clock : in  std_logic;
			  comeca: in  std_logic;
			  fim   : in  std_logic;
			  reseta: in  std_logic;
			  saida : out  std_logic_vector(4 downto 0));  -- carrega|zera|desloca|conta|pronto
	end component;

	component contador_tick_transmissao_serial is
		generic(M: integer);
		port(
			 clk, reset: in std_logic;
			 tick: out std_logic
		);
 end component;
	
signal s_fim: std_logic;
signal tick: std_logic;
signal estado: std_logic_vector(4 downto 0);
signal saida_registrador: std_logic_vector(11 downto 0);
	
begin 
	
	uc : unidade_controle_transmissao_serial port map (clock, partida, s_fim, reset, estado);
	fd : fluxo_de_dados_transmissao_serial   port map (dados_ascii, estado(4), estado(2), estado(3), estado(1), clock, tick, dado_serial, saida_registrador, s_fim);
	gerador_tick : contador_tick_transmissao_serial generic map (M => 5) port map (clock, estado(4), tick);
				
	registrador   <= saida_registrador;
	saidas_estado <= estado;
	pronto        <= estado(0);
	geradorTick	  <= tick;

end transmissao_serial;