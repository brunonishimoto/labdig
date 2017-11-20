-- modem_recepcao.vhd
--
-- componente que modela a recepcao de dados do modem
-- => usar para os testes de simulacao do projeto final
--
-- Labdig (3o quadrimestre de 2017)

library IEEE;
use IEEE.std_logic_1164.all;

entity modem_recepcao is 
  port ( clock, reset, DTR, RC: in STD_LOGIC;
         CD, RD: out STD_LOGIC );
end;

architecture modem_recepcao of modem_recepcao is
    type estados_rx is (inicial_rx, em_recepcao);
    signal Eatual, Eprox: estados_rx;
begin

  -- estado
  process (RESET, CLOCK)
  begin
      if RESET = '1' then
          Eatual <= inicial_rx;
      elsif CLOCK'event and CLOCK = '1' then
          Eatual <= Eprox; 
      end if;
  end process;

  -- proximo estado
  process (DTR, Eatual) 
  begin
    case Eatual is
    
      when inicial_rx =>       if DTR='0' then Eprox <= em_recepcao;
                               else            Eprox <= inicial_rx;
                               end if;
                               
      when em_recepcao =>      if DTR='1' then Eprox <= inicial_rx;
                               else            Eprox <= em_recepcao;
                               end if;      

      when others =>           Eprox <= inicial_rx;
    end case;
  end process;

  -- saidas
  with Eatual select
      CD <= '0' when em_recepcao, '1' when others;

  with Eatual select
      RD <= RC when em_recepcao, '0' when others;

end modem_recepcao;
