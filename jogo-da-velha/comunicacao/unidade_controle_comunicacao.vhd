-- VHDL for unidade de controle of input/output

library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle_comunicacao is
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
end unidade_controle_comunicacao;

architecture unidade_controle of unidade_controle_comunicacao is
  type tipo_estado is (initial, selectPlayer, waitTransmission, sendProtocol, waitResponse, analyzeResponse, registerMemoryTransmission, 
                       waitProtocol, analyzeProtocol, requestRetransmission, registerMemoryReception, final, connectModem);
  
  signal estado: tipo_estado;

  begin 
    process (clock, estado, reset)
    begin

      if (reset = '1') then
        estado <= initial;
      elsif (clock'event and clock = '1') then
        case estado is
          when initial =>   --wait for the game start, and see which player it is
            if (start = '1') then
              estado <= connectModem;
            else 
              estado <= initial;
            end if;

          when connectModem => --wait for the modem response that it's everything ok to transmit
            if (envioOk = '1') then
              estado <= selectPlayer;
            else 
              estado <= connectModem;
            end if;
          
          when selectPlayer =>  --see what player is playing in that device
            if (player = '0') then
              estado <= waitTransmission;
            elsif (player = '1') then
              estado <= waitProtocol;
            end if;

          when waitTransmission => --wait for the player make his move
            if (hasDataToTransmit = '1') then
              estado <= sendProtocol;
            else 
              estado <= waitTransmission;
            end if;

          when sendProtocol => --send the move to the other player
            if (endTransmission = '1')  then
              estado <= waitResponse;
            end if;

          when waitResponse => --wait the other machine response 
            if (hasDataToReceive = '1') then
             estado <= analyzeResponse;
            else 
              estado <= waitResponse;
            end if;

          when analyzeResponse => --see if the other player received the move correctly
            if (successfulTransmission = '1') then
              estado <= registerMemoryTransmission;
            else
              estado <= waitTransmission;
            end if;

          when registerMemoryTransmission => --register the move in memory only after the has confirmed that the other player received
            if (endGame = '1') then
              estado <= final;
            else
              estado <= waitProtocol;
            end if;
          
          when waitProtocol => --wait for the other player make his move
            if (hasDataToReceive = '1') then
              estado <= analyzeProtocol;
            else 
              estado <= waitProtocol;
            end if;
          
          when analyzeProtocol => --check if recieved correctly
            if (successfulReception = '1') then
              estado <= registerMemoryReception;
            else
              estado <= requestRetransmission;
            end if;

          when requestRetransmission => --send a message to the other plaer transmit again
            if (endTransmission = '1') then
              estado <= waitProtocol;
            else 
              estado <= requestRetransmission;
            end if;
          
          when registerMemoryReception => --register the move in memory
            if (endGame = '1') then
              estado <= final;
            else
              estado <= waitTransmission;
            end if;
          
          when final => --finished the game
            estado <= initial;

        end case;
      end if;
    end process;

  process (estado)
  begin
    case estado is
      when initial =>
        ligaModem <= '0';
        transmitData <= '0';
        sendFailMessage <= '0';
        clearUartTerminal <= '1';
        clearUartModem <= '1';
        registerInMemory <= '0';
        stateComunication <= "0000";

      when connectModem =>
        ligaModem <= '1';
        transmitData <= '0';
        sendFailMessage <= '0';
        clearUartTerminal <= '1';
        clearUartModem <= '1';
        registerInMemory <= '0';
        stateComunication <= "0001";

      when selectPlayer =>
        ligaModem <= '1';
        transmitData <= '0';
        sendFailMessage <= '0';
        clearUartTerminal <= '1';
        clearUartModem <= '1';
        registerInMemory <= '0';
        stateComunication <= "0010";

      when waitTransmission =>
        ligaModem <= '1';
        transmitData <= '0';
        sendFailMessage <= '0';
        clearUartTerminal <= '0';
        clearUartModem <= '1';
        registerInMemory <= '0';
        stateComunication <= "0011";

      when sendProtocol =>
        ligaModem <= '1';
        transmitData <= '1';
        sendFailMessage <= '0';
        clearUartTerminal <= '0';
        clearUartModem <= '1';
        registerInMemory <= '0';
        stateComunication <= "0100";

      when waitResponse =>
        ligaModem <= '1';
        transmitData <= '0';
        sendFailMessage <= '0';
        clearUartTerminal <= '0';
        clearUartModem <= '0';
        registerInMemory <= '0';
        stateComunication <= "0101";

      when analyzeResponse =>
        ligaModem <= '1';
        transmitData <= '0';
        sendFailMessage <= '0';
        clearUartTerminal <= '0';
        clearUartModem <= '0';
        registerInMemory <= '0';
        stateComunication <= "0110";

      when registerMemoryTransmission =>
        ligaModem <= '1';
        transmitData <= '0';
        sendFailMessage <= '0';
        clearUartTerminal <= '0';
        clearUartModem <= '1';
        registerInMemory <= '1';
        stateComunication <= "0110";

      when waitProtocol =>
        ligaModem <= '1';
        transmitData <= '0';
        sendFailMessage <= '0';
        clearUartTerminal <= '1';
        clearUartModem <= '0';
        registerInMemory <= '0';
        stateComunication <= "0111";

      when analyzeProtocol =>
        ligaModem <= '1';
        transmitData <= '0';
        sendFailMessage <= '0';
        clearUartTerminal <= '1';
        clearUartModem <= '0';
        registerInMemory <= '0';
        stateComunication <= "1000";

      when requestRetransmission =>
        ligaModem <= '1';
        transmitData <= '1';
        sendFailMessage <= '1';
        clearUartTerminal <= '1';
        clearUartModem <= '0';
        registerInMemory <= '0';
        stateComunication <= "1001";

      when registerMemoryReception => 
        ligaModem <= '1';  
        transmitData <= '0';
        sendFailMessage <= '0';
        clearUartTerminal <= '1';
        clearUartModem <= '0';
        registerInMemory <= '1';
        stateComunication <= "1010";

      when final =>
        ligaModem <= '0';
        transmitData <= '0';
        sendFailMessage <= '0';
        clearUartTerminal <= '1';
        clearUartModem <= '1';
        registerInMemory <= '0';
        stateComunication <= "1011";

    end case;
  end process;

end unidade_controle;