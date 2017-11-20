-- VHDL for tic-tac-toe

library ieee;
use ieee.std_logic_1164.all;

entity tic_tac_toe is
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
end tic_tac_toe;

architecture tic_tac_toe of tic_tac_toe is
  
  component uart is
    port(clock               : in std_logic;
         reset               : in std_logic;
         transmiteDado       : in std_logic;
         recebeDado          : in std_logic;
         entrada             : in std_logic;
         dadoTransmissao     : in std_logic_vector(6 downto 0);
         transmissaoAndamento: out std_logic;
         temDadoRecepcao     : out std_logic;
         saida               : out std_logic;
         startTickRecepcao   : out std_logic; --depuracao
         tickRecepcao        : out std_logic; --depuracao
         tickTransmissao     : out std_logic; --depuracao
         estadoTransInter    : out std_logic_vector(1 downto 0); --depuracao
         estadoRecepInter    : out std_logic_vector(1 downto 0); --depuracao
         prontoTransmissao	 : out std_logic; --depuracao
         prontoRecepcao		   : out std_logic; --depuracao
         paridadeOk				   : out std_logic; --depuracao
         estadoTransSerial	 : out std_logic_vector(4 downto 0); --depuracao
         estadoRecepSerial	 : out std_logic_vector(3 downto 0); --depuracao
         registradorRecepcao : out std_logic_vector(10 downto 0); --depuracao
         dadoRecepcao        : out std_logic_vector(6 downto 0);
         displayUnidade      : out std_logic_vector(6 downto 0);
         displayDezena       : out std_logic_vector(6 downto 0));
  end component;

  component entrada_saida is
    port (clock          : in  std_logic;
          reset          : in  std_logic;
          start          : in  std_logic;
          played         : in  std_logic;
          endTransmission: in  std_logic;
          moveReceived   : in  std_logic_vector(6 downto 0);
          readBoard      : out std_logic;
          clearScreen    : out std_logic;
          dataToSend     : out std_logic_vector(6 downto 0);
          actualPlayer   : out std_logic;
          endGame        : out std_logic;
          writeBoard     : out std_logic; --depuracao
          validMove      : out std_logic; --depuracao
          outOfRange     : out std_logic; --depuracao
          hasWinner      : out std_logic; --depuracao
          endOutOfRange  : out std_logic; --depuracao
          estate         : out std_logic_vector(3 downto 0); --depuracao
          addressToRead  : out std_logic_vector(6 downto 0)); --depuracao
  end component;

  component comunicacao is
    port (clock              : in  std_logic;
          reset              : in  std_logic;
          start              : in  std_logic;
          playerToTransmit   : in  std_logic;
          endGame            : in  std_logic;
          hasDataToTransmit  : in  std_logic;
          endTransmission    : in  std_logic;
          hasDataToReceive   : in  std_logic;
          successfulReception: in  std_logic;
          envioOk            : in  std_logic;
          moveToTransmit     : in  std_logic_vector(6 downto 0);
          dataReceived       : in  std_logic_vector(6 downto 0);
          ligaModem          : out std_logic;
          transmitData       : out std_logic;
          clearUartTerminal  : out std_logic;
          clearUartModem     : out std_logic;
          registerInMemory   : out std_logic;
          playerReceived     : out std_logic;
          stateComunication  : out std_logic_vector(3 downto 0);
          moveReceived       : out std_logic_vector(6 downto 0);
          dataToTransmit     : out std_logic_vector(6 downto 0));
  end component;
  
  component interface_modem is
    port(clock              : in  std_logic;
         reset              : in  std_logic;
         liga               : in  std_logic;
         enviar             : in  std_logic;
         dadoSerial         : in  std_logic;
         CTS                : in  std_logic;
         CD                 : in  std_logic;
         RD                 : in  std_logic;
         DTR                : out std_logic;
         RTS                : out std_logic;
         TD                 : out std_logic;
         envioOk            : out  std_logic;
         temDadoRecebido    : out  std_logic;
         dadoRecebido       : out  std_logic;
         estado_recepcao    : out std_logic_vector(3 downto 0); -- depuracao do circuito de recepcao
         estado_transmissao : out std_logic_vector(3 downto 0)); -- depuracao do circuito de transmissao
  end component;

  component mux_7bits is
    port(selector: in  std_logic;
         data1   : in  std_logic_vector(6 downto 0);
         data2   : in  std_logic_vector(6 downto 0);
         dataOut : out std_logic_vector(6 downto 0));
  end component;

  component modem is
    port ( clock, reset, DTR: in STD_LOGIC;
             -- transmissao
             RTS:               in STD_LOGIC;
             CTS:               out STD_LOGIC;
             TD:                in STD_LOGIC;
             TC:                out STD_LOGIC;
             -- recepcao
             RC:                in STD_LOGIC;
             CD, RD:            out STD_LOGIC);
  end component;

  component mux_1bit is
    port(selector: in  std_logic;
         data1   : in  std_logic;
         data2   : in  std_logic;
         dataOut : out std_logic);
  end component;

  signal s_symbol                     : std_logic_vector(6 downto 0); --char read from board
  signal s_readBoard                  : std_logic; --to transmit one char from board
  signal s_ongoingTransmissionTerminal: std_logic; --see if we can read next char from board
  signal s_moveReceivedFromTerminal   : std_logic_vector(6 downto 0); --move received
  signal s_hasDataToTransmit          : std_logic; --see if the player did his play
  signal s_clearScreen                : std_logic; --to clean the register that receive datas
  signal s_endGame                    : std_logic; --sinalize the end of game
  signal s_ongoinTransmissionModem    : std_logic; --see if the trasmission to the other player is finished
  signal s_hasDataToReceive           : std_logic; --see if the other player has made his move
  signal s_successfulReception        : std_logic; --see if the data received is ok, in other words, if parity is correct
  signal s_dataReceivedFromModem      : std_logic_vector(6 downto 0); --data received from modem
  signal s_transmitModem              : std_logic; --to transmit the data to another palyer
  signal s_registerInMemory           : std_logic; --register i memory only after it has confirmed that transmission is ok
  signal s_playerReceivedFromModem    : std_logic; --the player received from modem
  signal s_moveReceivedFromModem      : std_logic_vector(6 downto 0); --move made by the other player
  signal s_dataToTransmitToModem      : std_logic_vector(6 downto 0); --protocol to send to modem
  signal s_receiveData                : std_logic; --to clear the register in uart
  signal s_dataSerialFromModem        : std_logic; --data serial received from modem;
  signal s_dataSerialToModem          : std_logic; --data serial that will be sent to modem
  signal s_moveReceived               : std_logic_vector(6 downto 0); --the move that will enter in board
  signal s_actualPlayer               : std_logic; --the player that has to make the move
  signal s_validMove                  : std_logic; --check if it's a valid move
  signal s_outOfRange                 : std_logic; --check if it was pressed a valid key in keyboard
  signal s_envioOk                    : std_logic;
  signal s_clearUartTerminal          : std_logic;
  signal s_clearUartModem             : std_logic;
  signal s_ligaModem                  : std_logic;
  signal CTS, CD, RD, DTR, RTS, TD    : std_logic;
  signal s_selectedDataToModem        : std_logic;
  
  begin

    uart_terminal: uart port map (clock, reset, s_readBoard, s_clearUartTerminal, serialFromTerminal, s_symbol, s_ongoingTransmissionTerminal, s_hasDataToTransmit, serialToTerminal,
                                  dadoRecepcao => s_moveReceivedFromTerminal);
    
    comp_entrada_saida: entrada_saida port map (clock, reset, start, s_registerInMemory, not (s_ongoingTransmissionTerminal), s_moveReceivedFromTerminal,
                                                s_readBoard, open, s_symbol, s_actualPlayer, s_endGame, writeBoard, s_validMove, s_outOfRange, open, endOutOfRange, estate, addressToRead);

    comp_comunicacao: comunicacao port map (clock, reset, start, playerToTransmit, s_endGame, s_hasDataToTransmit, not (s_ongoinTransmissionModem), 
                                            s_hasDataToReceive, s_successfulReception, s_envioOk, s_moveReceivedFromTerminal, s_dataReceivedFromModem,
                                            s_ligaModem, s_transmitModem, s_clearUartTerminal, s_clearUartModem, s_registerInMemory, open, 
                                            estadoComunicacao, s_moveReceivedFromModem, s_dataToTransmitToModem);

    uart_modem: uart port map (clock, reset, s_transmitModem, s_clearUartModem, s_dataSerialFromModem, s_dataToTransmitToModem, s_ongoinTransmissionModem, 
                               s_hasDataToReceive, s_dataSerialToModem, dadoRecepcao => s_dataReceivedFromModem);

    data_serial_modem: mux_1bit port map (s_transmitModem, '1', s_dataSerialToModem, s_selectedDataToModem);


    comp_interface: interface_modem port map(clock, reset, s_ligaModem, s_transmitModem, s_selectedDataToModem, CTS, CD, RD, DTR, RTS, TD, s_envioOk, open,
                                             s_dataSerialFromModem, open, open);

    comp_modem: modem port map(clock, reset, DTR, RTS, CTS, TD, TC, RC, CD, RD);

    select_move: mux_7bits port map (s_actualPlayer xor playerToTransmit, s_moveReceivedFromModem, s_moveReceivedFromTerminal, s_moveReceived);

    symbol <= s_symbol;
    readBoard <= s_readBoard;
    moveReceived <= s_moveReceivedFromTerminal;
    clearScreen <= s_clearScreen;
end tic_tac_toe;  