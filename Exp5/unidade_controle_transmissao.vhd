-- VHDL da Unidade de Controle da transmissão

library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle_transmissao is
   port(clock                   : in   std_logic;
        reset                   : in   std_logic;
        dadoTransmissao         : in   std_logic_vector(6 downto 0);
        transmiteDado           : in   std_logic;
        prontoTransmissao       : in   std_logic;
        partidaTransmissao      : out  std_logic;
        dadoTransmitido         : out  std_logic_vector(6 downto 0);
        transmissaoAndamento    : out  std_logic);
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
        if pronto = '1' then
          estado <= final;
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
        transmissaoAndamento <= '0';
        partidaTransmissao <= '0';
        dadoTransmitido <= (others => '1');
      when transmissao =>
        transmissaoAndamento <= '1';
        partidaTransmissao <= '1';
        dadoTransmitido <= dadoTransmissao;
      when final =>
        transmissaoAndamento <= '0';
        partidaTransmissao <= '0';
        dadoTransmitido <= (others => '1');
    end case;
   end process;
end unidade_controle;