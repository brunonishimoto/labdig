-- VHDL de um counter de modulo 9

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity counter is
		generic (module: unsigned);
    port(clock     : in  std_logic;
         clear     : in  std_logic;
			   count     : in  std_logic;
         counter   : out std_logic_vector(6 downto 0);
         end_count : out std_logic);
end counter;

architecture counter of counter is
signal IQ: unsigned(6 downto 0);

begin
	process (clock, count, IQ, clear)
	begin
	
	if clock'event and clock = '1' then
		if clear = '1' then 
			IQ <= (others => '0');
    elsif count = '1' then 
      if (IQ = module) then
        IQ <= (others => '0');
      else
        IQ <= IQ + 1;
      end if;
		end if;
	end if;
	
  if IQ = module then 
		end_count <= '1';
	else 
		end_count <= '0';
	end if;
    
	counter <= std_logic_vector(IQ);  
   
	end process;
end counter;