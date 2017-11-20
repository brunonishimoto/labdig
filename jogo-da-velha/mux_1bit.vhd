-- VHDL for a mux for in of 7 bits

library ieee;
use ieee.std_logic_1164.all;

entity mux_1bit is
  port(selector: in  std_logic;
       data1   : in  std_logic;
       data2   : in  std_logic;
       dataOut : out std_logic);
end mux_1bit;

architecture mux_1bit of mux_1bit is
  begin
    process(selector)
    begin
      if(selector = '0') then
        dataOut <= data1;
      else
        dataOut <= data2;
      end if;
    end process;
end mux_1bit;