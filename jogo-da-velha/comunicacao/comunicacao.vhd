library ieee;
use ieee.std_logic_1164.all;

entity comunicacao is
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
end comunicacao;

architecture comunicacao of comunicacao is
  
  component convert_move_to_protocol is
    port (move      : in  std_logic_vector(6 downto 0);
          player    : in  std_logic;
          status    : in  std_logic;
          dataToSend: out std_logic_vector(6 downto 0));
  end component;

  component convert_protocol_to_move is
    port(dataReceived: in  std_logic_vector(6 downto 0);
         player      : out std_logic;
         status      : out std_logic;
         move        : out std_logic_vector(6 downto 0));
  end component;

  component unidade_controle_comunicacao is
    port(clock                 : in  std_logic;
         reset                 : in  std_logic;
         start                 : in  std_logic;
         player                : in  std_logic; --signal from outside
         endGame               : in  std_logic; --signal from tic-tac-toe
         hasDataTotransmit     : in  std_logic; --signal from uart-terminal (temDadoRecepcao)
         endTransmission       : in  std_logic; --signal from uart-modem (not transmissaoAndamento)
         successfulTransmission: in  std_logic; --signal internal (convert protocol to move)
         hasDataToReceive      : in  std_logic; --signal from uart-modem (temDadoRecepcao)
         successfulReception   : in  std_logic; --signal internal (check parity)
         envioOk               : in  std_logic; --signal from interface-modem
         ligaModem             : out std_logic; --signal to interface-modem (liga)
         transmitData          : out std_logic; --signal to interface-modem and uart-modem (enviar, transmiteDado)
         clearUartTerminal     : out std_logic; --signal to uart-terminal (recebeDado)
         clearUartModem        : out std_logic; --signal to uart-modem (recebeDado)
         sendFailMessage       : out std_logic;
         registerInMemory      : out std_logic;
         stateComunication     : out std_logic_vector(3 downto 0));
  end component;

  signal s_successfulTransmission: std_logic;
  signal s_sendFailMessage: std_logic;

  begin

    uc: unidade_controle_comunicacao port map (clock, reset, start, playerToTransmit, endGame, hasDataToTransmit, endTransmission,
                                               s_successfulTransmission, hasDataToReceive, successfulReception, envioOk, ligaModem, transmitData, 
                                               clearUartTerminal, clearUartModem, s_sendFailMessage, registerInMemory, stateComunication);

    convert_move: convert_move_to_protocol port map (moveToTransmit, playerToTransmit, not(s_sendFailMessage), dataToTransmit);
    convert_protocol: convert_protocol_to_move port map (dataReceived, playerReceived, s_successfulTransmission, moveReceived);

end comunicacao;