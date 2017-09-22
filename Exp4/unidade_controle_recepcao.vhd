-- VHDL da Unidade de Controle da transmissão

library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle_recepcao is
   port(clock           : in   std_logic;
        reset           : in   std_logic;
        liga            : in   std_logic;
        CD              : in   std_logic;
        RD              : in   std_logic;
        DTR             : out  std_logic;
        temDadoRecebido : out  std_logic;
        dadoRecebido    : out  std_logic;
        saida           : out  std_logic_vector(3 downto 0));  -- controle de estados
end unidade_controle_recepcao;

architecture unidade_controle of unidade_controle_recepcao is
type tipo_estado is (inicial, recepcao, final, desabilitado);
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
        if CD = '0' then   -- Ativo em baixo
          estado <= recepcao;
        end if;

      when recepcao =>   -- Recebe o sinal do modem
        if CD = '1' then   -- Ativo em baixo
          estado <= final;
        end if;

      when final =>      -- Aguarda desativação do sinal RD
        if RD = '1' then   -- Ativo em baixo
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
        DTR <= '0';
        saida <= "0000";
        temDadoRecebido <= '0';
        dadoRecebido <= '0';
      when recepcao =>
        DTR <= '0';
        saida <= "0001";
        temDadoRecebido <= '1';
        dadoRecebido <= RD;
      when final =>
        DTR <= '0';
        saida <= "0010";
        temDadoRecebido <= '0';
        dadoRecebido <= '0';
      when desabilitado =>
        DTR <= '1';
        saida <= "1111";
        temDadoRecebido <= '0';
        dadoRecebido <= '0';
    end case;
   end process;
end unidade_controle;