-- VHDL for a mux for in of 7 bits and 7 datas in

library ieee;
use ieee.std_logic_1164.all;

entity mux_8in_7bits is
  port(selector: in  std_logic_vector(6 downto 0);
       data1   : in  std_logic_vector(6 downto 0);
       data2   : in  std_logic_vector(6 downto 0);
       data3   : in  std_logic_vector(6 downto 0);
       data4   : in  std_logic_vector(6 downto 0);
       data5   : in  std_logic_vector(6 downto 0);
       data6   : in  std_logic_vector(6 downto 0);
       data7   : in  std_logic_vector(6 downto 0);
       data8   : in  std_logic_vector(6 downto 0);
       dataOut : out std_logic_vector(6 downto 0));
end mux_8in_7bits;

architecture mux_8in_7bits of mux_8in_7bits is
  begin
    process(selector)
    begin
      case selector is 
        when "0000000" => dataOut <= data1;
        when "1000000" => dataOut <= data2;
        when "0100000" => dataOut <= data3;
        when "0010000" => dataOut <= data4;
        when "0001000" => dataOut <= data5;
        when "0000100" => dataOut <= data6;
        when "0000010" => dataOut <= data7;
        when "0000001" => dataOut <= data8;
		  when others => dataOut <= "1000000";
      end case;
    end process;
end mux_8in_7bits;