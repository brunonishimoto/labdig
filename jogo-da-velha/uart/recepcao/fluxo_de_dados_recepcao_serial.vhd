-- VHDL do Fluxo de Dados

library ieee;
use ieee.std_logic_1164.all;

entity fluxo_de_dados_recepcao_serial is
	port(clock		    : in  std_logic;
		   dado_serial  : in  std_logic;
		   desloca		 : in  std_logic;
		   zera			 : in  std_logic;
		   conta			 : in  std_logic;
		   paridade_ok  : out std_logic;
		   dado_ascii	 : out std_logic_vector(6 downto 0);
		   saidaQ		 : out std_logic_vector(10 downto 0);	--depuracao
			contador     : out std_logic_vector(3 downto 0); --depuracao
			geradorTick  : out std_logic; --depuracao
		   fim			 : out std_logic);
end fluxo_de_dados_recepcao_serial;

architecture exemplo of fluxo_de_dados_recepcao_serial is

	component registrador_deslocamento_recepcao_serial is 
		port(clock     : in  std_logic; 
           clear     : in  std_logic; 
           shift     : in  std_logic;
			  bit_in    : in  std_logic;
			  tick		: in  std_logic;
			  paridade  : out std_logic;
			  data_ascii: out std_logic_vector(6 downto 0);
           saida     : out std_logic_vector(10 downto 0));
	end component;
		
	component contador_bits_recepcao_serial is
		port(clock   : in  std_logic;
			  zera    : in  std_logic;
			  conta   : in  std_logic;
			  tick	 : in  std_logic;
			  contagem: out std_logic_vector(3 downto 0);
			  fim     : out std_logic);
	end component;
	
	component comparador_de_paridade is
		port(paridade_recebida	  : in  std_logic;
			  dado_recebido   	  : in  std_logic_vector(6 downto 0);
			  indicador_de_paridade: out std_logic);
	end component;

	component contador_tick_recepcao_serial is
		generic(M: integer);
		port(
			 clk, reset: in std_logic;
			 tick: out std_logic);
 	end component;
	
	component tick_start is
		generic(M: integer);
		port(
			clk, reset: in std_logic;
			tick: out std_logic
		);
	end component;
  
	component multiplexador is
		port (entrada1, entrada2: in std_logic;
				mux: in std_logic;
				saida: out std_logic);
	end component;

signal saida_registrador : std_logic_vector(10 downto 0);	
signal s_ascii: std_logic_vector(6 downto 0);
signal paridade: std_logic;
signal tick_bit: std_logic;
signal tick_start_bit: std_logic;
signal tick: std_logic;
signal s_contador: std_logic_vector(3 downto 0);
signal multiplex: std_logic;

begin
	multiplex <= s_contador(3) or s_contador(2) or s_contador(1) or s_contador(0);

	registrador_deslocamento : registrador_deslocamento_recepcao_serial port map (clock, zera, desloca, dado_serial, tick, paridade, s_ascii, saida_registrador);
	contador_de_bits : contador_bits_recepcao_serial port map (clock, zera, conta, tick, s_contador, fim);
	comparador_paridade : comparador_de_paridade port map (paridade, s_ascii, paridade_ok);
	
	
	gerador_ticks: contador_tick_recepcao_serial generic map (M => 50000000/110) port map (clock, (not (desloca)) or (not (multiplex)), tick_bit);
	gerador_start_tick: tick_start generic map (M => 50000000/220) port map (clock, (not (desloca)) or multiplex, tick_start_bit);
	multiplexador_ticks: multiplexador port map (tick_start_bit, tick_bit, multiplex, tick);

	saidaQ <= saida_registrador;
	dado_ascii <= s_ascii;
	geradorTick <= tick;
	contador <= s_contador;
end exemplo;