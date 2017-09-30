-- VHDL da Unidade de Controle da transmissão

library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle_recepcao is
  port(clock           : in   std_logic;
       reset           : in   std_logic;
       prontoRecepcao  : in   std_logic;
       recebeDado      : in   std_logic;
       zeraRegistrador : out  std_logic; -- zera registrador que armazena o sinal
       temDadoRecepcao : out  std_logic;
       estadoRecepcao  : out  std_logic_vector(1 downto 0)); --sinal de depuração
end unidade_controle_recepcao;

architecture unidade_controle of unidade_controle_recepcao is
type tipo_estado is (inicial, recepcao, final);
signal estado   : tipo_estado;

begin
  process (clock, estado, reset)
  begin

    if reset = '1' then
      estado <= inicial;

    elsif (clock'event and clock = '1') then
      case estado is
      when inicial =>      -- Aguarda sinal de inicio
        if prontoRecepcao = '1' then
          estado <= recepcao;
        end if;

      when recepcao =>         -- Exibe dados na saida
        if recebeDado = '1' then
          estado <= final;
        end if;

      when final =>      -- Desativa sinais e limpa registrador
        if recebeDado = '0' then
          estado <= inicial;
        end if;
      end case;
    end if;
  end process;

  process (estado)
  begin
    case estado is
      when inicial =>
        estadoRecepcao <= "00";
        temDadoRecepcao <= '0';
        zeraRegistrador <= '0';
      when recepcao =>
        estadoRecepcao <= "01";
        temDadoRecepcao <= '1';
        zeraRegistrador <= '0';
      when final =>
        estadoRecepcao <= "10";
        temDadoRecepcao <= '1';
        zeraRegistrador <= '1';
    end case;
   end process;
end unidade_controle;