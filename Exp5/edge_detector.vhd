-- VHDL for an rising edge detector

library ieee;
use ieee.std_logic_1164.all;

entity edge_detector is
  port(clock    : in  std_logic;
       signalIn : in  std_logic;
       signalOut: out std_logic);
end edge_detector;

architecture edge_detector of edge_detector is
  
  signal signal_d: std_logic;

  begin
    process(clock)
    begin
      if clock'event and clock='1' then
        signal_d <= signalIn;
      end if;
    end process;

    signalOut <= (not signal_d) and signalIn; 
end edge_detector;