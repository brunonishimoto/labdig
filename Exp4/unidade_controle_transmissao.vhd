-- VHDL da Unidade de Controle da transmissão

library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle_transmissao is
   port(clock      : in   std_logic;
        RESET      : in   std_logic;
        Liga       : in   std_logic;
        Enviar     : in   std_logic;
        DadoSerial : in   std_logic;
        CTS        : in   std_logic;
        DTR        : out  std_logic;
        RTS        : out  std_logic;
        TD         : out  std_logic;
        envioOK    : out  std_logic;
        saida      : out  std_logic_vector(3 downto 0));  -- controle de estados
end unidade_controle_transmissao;

architecture unidade_controle of unidade_controle_transmissao is
type tipo_estado is (inicial, preparacao, transmissao, desabilitado, final);
signal estado   : tipo_estado;

begin
  process (clock, estado, RESET)
  begin

    if Liga = '0' then
      estado <= desabilitado;
    elsif RESET = '1' then
      estado <= inicial;

    elsif (clock'event and clock = '1') then
      case estado is
      when inicial =>      -- Aguarda sinal de inicio
        if Enviar = '1' then
          estado <= preparacao;
        end if;

      when preparacao =>    -- Espera sinal de controle CTS do modem
        if CTS = '0' then   -- Ativo em baixo
          estado <= transmissao;
        end if;

      when transmissao =>    -- Envia o que estiver na entrada de dados
        if Enviar = '0' then
          estado <= final;
        end if;

      when final =>         -- Fim da transmissao serial
        if CTS = '1' then
          estado <= inicial;
        end if;

      when desabilitado =>         -- Circuito desabilitado
        if Liga = '1' then
          estado <= inicial;
        end if;

      end case;
    end if;
  end process;

  process (estado)
  begin
    case estado is
      when inicial =>
        saida <= "0000";
        envioOK <= '0';
        DTR <= '1';
        RTS <= '1';
        TD <= '1';
      when preparacao =>
        saida <= "0001";
        envioOK <= '0';
        DTR <= '0';
        RTS <= '0';
        TD <= '1';
      when transmissao =>
        saida <= "0010";
        envioOK <= '1';
        DTR <= '0';
        RTS <= '0';
        TD <= DadoSerial;
      when final =>
        saida <= "0011";
        envioOK <= '0';
        DTR <= '1';
        RTS <= '1';
        TD <= '1';
      when desabilitado =>
        saida <= "1111";
        envioOK <= '0';
        DTR <= '1';
        RTS <= '1';
        TD <= '1';
    end case;
   end process;
end unidade_controle;