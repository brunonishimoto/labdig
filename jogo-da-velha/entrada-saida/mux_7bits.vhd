-- VHDL for a mux for in of 7 bits

library ieee;
use ieee.std_logic_1164.all;

entity mux_7bits is
  port(selector: in  std_logic;
       data1   : in  std_logic_vector(6 downto 0);
       data2   : in  std_logic_vector(6 downto 0);
       dataOut : out std_logic_vector(6 downto 0));
end mux_7bits;

architecture mux_7bits of mux_7bits is
  begin
    process(selector)
    begin
      if(selector = '0') then
        dataOut <= data1;
      else
        dataOut <= data2;
      end if;
    end process;
end mux_7bits;