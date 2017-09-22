-- VHDL da Unidade de Controle da transmissão

library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle_transmissao is
   port(clock      : in   std_logic;
        reset      : in   std_logic;
        liga       : in   std_logic;
        enviar     : in   std_logic;
        dadoSerial : in   std_logic;
        CTS        : in   std_logic;
        DTR        : out  std_logic;
        RTS        : out  std_logic;
        TD         : out  std_logic;
        envioOk    : out  std_logic;
        saida      : out  std_logic_vector(3 downto 0));  -- controle de estados
end unidade_controle_transmissao;

architecture unidade_controle of unidade_controle_transmissao is
type tipo_estado is (inicial, preparacao, transmissao, desabilitado, final);
signal estado   : tipo_estado;

begin
  process (clock, estado, reset)
  begin

    if liga = '0' then
      estado <= desabilitado;
    elsif reset = '1' then
      estado <= inicial;

    elsif (clock'event and clock = '1') then
      case estado is
      when inicial =>      -- Aguarda sinal de inicio
        if enviar = '1' then
          estado <= preparacao;
        end if;

      when preparacao =>    -- Espera sinal de controle CTS do modem
        if CTS = '0' then   -- Ativo em baixo
          estado <= transmissao;
        end if;

      when transmissao =>    -- Envia o que estiver na entrada de dados
        if enviar = '0' then
          estado <= final;
        end if;

      when final =>         -- Fim da transmissao serial
        if CTS = '1' then
          estado <= inicial;
        end if;

      when desabilitado =>         -- Circuito desabilitado
        if liga = '1' then
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
        envioOk <= '0';
        DTR <= '1';
        RTS <= '1';
        TD <= '1';
      when preparacao =>
        saida <= "0001";
        envioOk <= '0';
        DTR <= '0';
        RTS <= '0';
        TD <= '1';
      when transmissao =>
        saida <= "0010";
        envioOk <= '1';
        DTR <= '0';
        RTS <= '0';
        TD <= dadoSerial;
      when final =>
        saida <= "0011";
        envioOk <= '0';
        DTR <= '1';
        RTS <= '1';
        TD <= '1';
      when desabilitado =>
        saida <= "1111";
        envioOk <= '0';
        DTR <= '1';
        RTS <= '1';
        TD <= '1';
    end case;
   end process;
end unidade_controle;