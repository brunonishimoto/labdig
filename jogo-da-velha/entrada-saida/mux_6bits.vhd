-- VHDL for a mux for in of 6 bits

library ieee;
use ieee.std_logic_1164.all;

entity mux_6bits is
  port(selector: in  std_logic;
       data1   : in  std_logic_vector(5 downto 0);
       data2   : in  std_logic_vector(5 downto 0);
       dataOut : out std_logic_vector(5 downto 0));
end mux_6bits;

architecture mux_6bits of mux_6bits is
  begin
    process(selector)
    begin
      if(selector = '0') then
        dataOut <= data1;
      else
        dataOut <= data2;
      end if;
    end process;
end mux_6bits;