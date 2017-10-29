-- VHDL da Unidade de Controle da transmissão

library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle_transmissao is
   port(clock               : in  std_logic;
        reset               : in  std_logic;
        transmiteDado       : in  std_logic;
        prontoTransmissao   : in  std_logic;
        partidaTransmissao  : out std_logic;
        transmissaoAndamento: out std_logic;
        zeraRegistrador     : out std_logic;
        estadoTransmissao   : out std_logic_vector(1 downto 0));
end unidade_controle_transmissao;

architecture unidade_controle of unidade_controle_transmissao is
type tipo_estado is (inicial, transmissao, final);
signal estado   : tipo_estado;

begin
  process (clock, estado, reset)
  begin

    if reset = '1' then
      estado <= inicial;
    elsif (clock'event and clock = '1') then
      case estado is
      when inicial =>      -- Aguarda sinal de inicio
        if transmiteDado = '1' then
          estado <= transmissao;
        end if;

      when transmissao =>    -- Envia o que estiver na entrada de dados
        if prontoTransmissao = '1' then
          estado <= inicial;
        end if;

      when final =>         -- Fim da transmissao serial
        if transmiteDado = '0' then
          estado <= inicial;
        end if;

      end case;
    end if;
  end process;

  process (estado)
  begin
    case estado is
      when inicial =>
        estadoTransmissao <= "00";
        transmissaoAndamento <= '0';
        partidaTransmissao <= '0';
        zeraRegistrador <= '0';
      when transmissao =>
        estadoTransmissao <= "01";
        transmissaoAndamento <= '1';
        partidaTransmissao <= '1';
        zeraRegistrador <= '0';
      when final =>
        estadoTransmissao <= "10";
        transmissaoAndamento <= '0';
        partidaTransmissao <= '0';
        zeraRegistrador <= '1';
    end case;
   end process;
end unidade_controle;