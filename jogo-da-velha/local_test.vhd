library ieee;
use ieee.std_logic_1164.all;

entity local_test is
  port (clock, reset: in std_logic;
        start       : in std_logic;
		  player1, player2: in std_logic;
		  serialFromTerminal1, serialFromTerminal2: in std_logic;
		  RC1, RC2: in std_logic;
		  TC1, TC2: out std_logic;
		  serialToTerminal1, serialToTerminal2: out std_logic;
		  estadoComunicacao1, estadoComunicacao2: out std_logic_vector(3 downto 0));
end local_test;

architecture local_test of local_test is

component tic_tac_toe is
  port (clock             : in  std_logic;
        reset             : in  std_logic;
        start             : in  std_logic;
        playerToTransmit  : in  std_logic;
        serialFromTerminal: in  std_logic;
		  RC					  : in  std_logic;
		  TC					  : out std_logic;
        serialToTerminal  : out std_logic;
        tickRecepcao      : out std_logic; --depuracao
        tickTransmissao   : out std_logic; --depuracao
        endTransmissao    : out std_logic; --depuracao
        readBoard         : out std_logic; --depuracao
        endReception      : out std_logic; --depuracao
        writeBoard        : out std_logic; --depuracao
        clearScreen       : out std_logic; --depuracao
        endOutOfRange     : out std_logic; --depuracao
        symbol            : out std_logic_vector(6 downto 0); -- depuracao
        stateReception    : out std_logic_vector(3 downto 0); --depuracao
        moveReceived      : out std_logic_vector(6 downto 0); --depuracao
        estate            : out std_logic_vector(3 downto 0); --depuracao
        estadoComunicacao : out std_logic_vector(3 downto 0); --depuracao
        addressToRead     : out std_logic_vector(6 downto 0)); --depuracao
end component;

begin

  game1: tic_tac_toe port map (clock, reset, start, player1, serialFromTerminal1, RC1,
                               TC1, serialToTerminal1, estadoComunicacao => estadoComunicacao1);
					
  game2: tic_tac_toe port map (clock, reset, start, player2, serialFromTerminal2, RC2,
                               TC2, serialToTerminal2, estadoComunicacao => estadoComunicacao2);
										 
end local_test;