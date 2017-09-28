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
        temDadoRecepcao : out  std_logic;
        estadoRecepcao  : out  std_logic_vector(2 downto 0));
end unidade_controle_recepcao;

architecture unidade_controle of unidade_controle_recepcao is
type tipo_estado is (inicial, recepcao, registra, preparacao, final);
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
        if prontoRecepcao = '1' then
          estado <= registra;
        end if;

      when registra =>   -- Registra os dados recebidos
        estado <= final;

      when final =>      -- Aguarda desativação do sinal de inicio
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
        estadoRecepcao <= "000";
        temDadoRecepcao <= '1';
        zeraRegistrador <= '0';
        registraDado <= '0';
      when preparacao =>
        estadoRecepcao <= "001";
        temDadoRecepcao <= '0';
        zeraRegistrador <= '1';
        registraDado <= '0';
      when recepcao =>
        estadoRecepcao <= "010";
        temDadoRecepcao <= '0';
        zeraRegistrador <= '0';
        registraDado <= '0';
      when registra =>
        estadoRecepcao <= "011";
        temDadoRecepcao <= '1';
        zeraRegistrador <= '0';
        registraDado <= '1';
      when final =>
        estadoRecepcao <= "100";
        temDadoRecepcao <= '1';
        zeraRegistrador <= '0';
        registraDado <= '0';
    end case;
   end process;
end unidade_controle;