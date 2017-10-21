-- contador_tick_recepcao_serial.vhd
--                      gerador de tick usando contador modulo-M
-- codigo baseado no livro de Pong Chu - "FPGA Prototyping by VHDL Examples"
-- Listing 4.11
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contador_tick_recepcao_serial is
   generic(
      M: integer := 50000000     -- modulo do contador
   );
   port(
      clk, reset: in std_logic;
      tick: out std_logic
   );
end contador_tick_recepcao_serial;

architecture arch of contador_tick_recepcao_serial is
   signal contagem, prox_contagem: integer;
begin
   -- registrador
   process(clk,reset)
   begin
      if (reset='1') then
         contagem <= 0;
      elsif (clk'event and clk='1') then
         contagem <= prox_contagem;
      end if;
   end process;
   -- logica de proximo estado
   prox_contagem <= 0 when contagem=(M-1) else contagem + 1;
   -- logica de saida
   tick <= '1' when contagem=(M-1) else '0';
end arch;