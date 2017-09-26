-- VHDL da Unidade de Controle da transmissão

library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle_recepcao is
   port(clock           : in   std_logic;
        reset           : in   std_logic;
        prontoRecepcao  : in   std_logic;
        recebeDado      : in   std_logic;
        zeraRegistrador : out  std_logic; -- zera registrador que armazena o sinal
        registraDado    : out  std_logic; -- controla registro do sinal recebido
        temDadoRecepcao : out  std_logic);
end unidade_controle_recepcao;

architecture unidade_controle of unidade_controle_recepcao is
type tipo_estado is (inicial, recepcao, registra, preparacao);
signal estado   : tipo_estado;

begin
  process (clock, estado, reset)
  begin

    if reset = '1' then
      estado <= inicial;

    elsif (clock'event and clock = '1') then
      case estado is
      when inicial =>      -- Aguarda sinal de inicio
        if recebeDado = '1' then
          estado <= preparacao;
        end if;

      when preparacao =>         -- Zera circuitos e saidas
        estado <= recepcao;

      when recepcao =>   -- Espera receber o sinal do final
        if pronto = '1' then
          estado <= registra';
        end if;

      when registra =>   -- Registra os dados recebidos
        estado <= inicial;

      end case;
    end if;
  end process;

  process (estado)
  begin
    case estado is
      when inicial =>
        temDadoRecepcao <= '0';
        zeraRegistrador <= '0';
        registraDado <= '0';
      when preparacao =>
        temDadoRecepcao <= '0';
        zeraRegistrador <= '1';
        registraDado <= '0';
      when recepcao =>
        temDadoRecepcao <= '1';
        zeraRegistrador <= '0';
        registraDado <= '1';
      when registra =>
        temDadoRecepcao <= '0';
        zeraRegistrador <= '0';
        registraDado <= '1';
    end case;
   end process;
end unidade_controle;