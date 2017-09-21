-- VHDL da Unidade de Controle da transmissão

library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle_recepcao is
   port(clock           : in   std_logic;
        RESET           : in   std_logic;
        Liga            : in   std_logic;
        CD              : in   std_logic;
        RD              : in   std_logic;
        temDadoRecebido : out  std_logic;
        DadoRecebido    : out  std_logic;
        saida           : out  std_logic_vector(3 downto 0));  -- controle de estados
end unidade_controle_recepcao;

architecture unidade_controle of unidade_controle_recepcao is
type tipo_estado is (inicial, detectando, desabilitado);
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
        if CD = '0' then   -- Ativo em baixo
          estado <= detectando;
        end if;

      when detectando =>   -- Recebe o sinal do modem
        if CD = '1' then   -- Ativo em baixo
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
        temDadoRecebido <= '0';
        DadoRecebido <= '0';
      when detectando =>
        saida <= "0001";
        temDadoRecebido <= '1';
        DadoRecebido <= RD;
      when desabilitado =>
        saida <= "1111";
        temDadoRecebido <= '0';
        DadoRecebido <= '0';
    end case;
   end process;
end unidade_controle;