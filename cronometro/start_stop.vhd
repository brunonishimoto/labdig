-- start_stop.vhd
--                processa botao start/stop
library IEEE;
use IEEE.std_logic_1164.all;

entity start_stop is 
  port ( clock, reset, botao: in STD_LOGIC;
         estado: out STD_LOGIC );
end;

architecture start_stop_arch of start_stop is
type   Tipo_estado is (PARADO, INICIANDO, CONTANDO, PARANDO);  -- estados
signal Eatual,              -- estado atual
       Eprox: Tipo_estado;  -- proximo estado
begin

  process (CLOCK, reset) -- memoria de estado
  begin
    if reset = '1' then
      Eatual <= PARADO;
    elsif CLOCK'event and CLOCK = '1' then
      Eatual <= Eprox; 
	end if;
  end process;

  process (botao, Eatual) -- logica de proximo estado
  begin
    case Eatual is
      when PARADO =>     if botao='0' then Eprox <= PARADO;
                         else              Eprox <= INICIANDO;
                         end if;
      when INICIANDO =>  if botao='1' then Eprox <= INICIANDO;
                         else              Eprox <= CONTANDO;
                         end if;
      when CONTANDO =>   if botao='0' then Eprox <= CONTANDO;
                         else              Eprox <= PARANDO;
                         end if;
      when PARANDO =>    if botao='1' then Eprox <= PARANDO;
                         else              Eprox <= PARADO;
                         end if;
      when others =>     Eprox <= PARADO;
    end case;
  end process;

  with Eatual select  -- logica de saida (Moore)
    estado <= '1' when INICIANDO | CONTANDO,
              '0' when others;
		 
end start_stop_arch;
