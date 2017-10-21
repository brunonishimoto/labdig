-- VHDL do Sistema Digital

library ieee;
use ieee.std_logic_1164.all;

entity recepcao_serial is
  port(dado_serial     : in  std_logic;
       reset           : in  std_logic;
       clock           : in  std_logic;
       paridade_ok     : out std_logic;
       dados_ascii     : out  std_logic_vector(6 downto 0);
       registrador     : out std_logic_vector(10 downto 0);  -- Depuracao
       saidas_estado   : out std_logic_vector(3 downto 0);  -- Depuracao
       contador_bits   : out std_logic_vector(3 downto 0); --Depuracao
       tickStartBit    : out std_logic; --Depuracao
       tickBit         : out std_logic; --Depuracao
       fim_operacao    : out std_logic);
end recepcao_serial;

architecture recepcao_serial of recepcao_serial is

  component fluxo_de_dados_recepcao_serial is
    port(clock		    : in  std_logic;
         dado_serial  : in  std_logic;
         desloca		  : in  std_logic;
         zera			    : in  std_logic;
         conta			  : in  std_logic;
         paridade_ok  : out std_logic;
         dado_ascii	  : out std_logic_vector(6 downto 0);
         saidaQ			  : out std_logic_vector(10 downto 0);	--depuracao
         contador     : out std_logic_vector(3 downto 0); --depuracao
         geradorTick  : out std_logic; --depuracao
         fim				  : out std_logic);
  end component;

  component unidade_controle_recepcao_serial is
   port(clock    : in  std_logic;
        comeca   : in  std_logic;
        fim      : in  std_logic;
				reseta   : in  std_logic;
				tickStart: in  std_logic;	--tick do start bit (precisamos para )
        saida    : out std_logic_vector(3 downto 0));  -- zera|desloca|conta|pronto
  end component;

  component tick_start is
    generic(M: integer);
    port(
       clk, reset: in std_logic;
       tick: out std_logic
    );
  end component;

signal fim : std_logic;
signal estado : std_logic_vector(3 downto 0);
signal s_registrador : std_logic_vector(10 downto 0);
signal paridade: std_logic := '0';
signal s_ascii: std_logic_vector(6 downto 0);
signal tick_start_bit: std_logic;

begin

  unidade_controle : unidade_controle_recepcao_serial port map (clock, dado_serial, fim, reset, tick_start_bit, estado);
  gerador_tick: tick_start generic map (M => 5) port map (clock, dado_serial, tick_start_bit);
  fluxo_dados : fluxo_de_dados_recepcao_serial   port map (clock, dado_serial, estado(2),estado(3), estado(1),
                                                           paridade, s_ascii, s_registrador, contador_bits, tickBit, fim);

  registrador   <= s_registrador;
  saidas_estado <= estado;
  fim_operacao  <= fim;
  paridade_ok   <= fim and paridade;
  dados_ascii   <= s_ascii;
  tickStartBit  <= tick_start_bit;

end recepcao_serial;