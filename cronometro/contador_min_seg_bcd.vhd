-- contador_min_seg_bcd.vhd
--                         contador de minutos e segundos com saida bcd
--                         com suporte a sinal de tick enable

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.alL;

entity contador_min_seg_bcd is
    port (
        CLK, zera, conta, tick: in STD_LOGIC;
        Q: out STD_LOGIC_VECTOR (15 downto 0);  -- saída em decimal -> minutos e segundos
        fim: out STD_LOGIC
    );
end contador_min_seg_bcd;

architecture contador_min_seg_bcd_arch of contador_min_seg_bcd is
  type int_array is array(0 to 3) of integer;
  signal dig: int_array;  -- digitos do contador em integer
begin
  
  process (CLK,zera,conta,tick,dig)
  begin
    if zera='1' then 
      for i in 0 to 3 loop dig(i) <= 0; end loop;    -- zera digitos
    elsif CLK'event and CLK='1' then
      if conta='1' and tick='1' then 
        if dig(3)=5 and dig(2)=9 and dig(1)=5 and dig(0)=9 then -- fim da contagem
          for i in 0 to 3 loop dig(i) <= 0; end loop;
        else 
          -- atualiza digitos (tempo+1)
          if dig(0)=9 then 
            dig(0) <= 0; dig(1) <= dig(1)+1;
            if dig(1)=5 then
              dig(1) <= 0; dig(2) <= dig(2)+1;
              if dig(2)=9 then
                dig(2) <= 0; dig(3) <= dig(3)+1;
                if dig(3)=5 then
                  dig(3) <= 0;
                else
                  dig(3) <= dig(3)+1;
                end if;
              else
                dig(2) <= dig(2)+1;
              end if;
            else
            dig(1) <= dig(1)+1;
          end if;
          else
            dig(0) <= dig(0)+1;
          end if;
        end if;

      end if;
    end if;
    
	-- saida fim=1 quando em 59min50seg
    if dig(3)=5 and dig(2)=9 and dig(1)=5 and dig(0)=9 then fim <= '1'; else fim <= '0'; end if;
    -- converte contagem interna para a saida em bcd
    Q(3 downto 0)   <= conv_std_logic_vector(dig(0), 4);
    Q(7 downto 4)   <= conv_std_logic_vector(dig(1), 4);
    Q(11 downto 8)  <= conv_std_logic_vector(dig(2), 4);
    Q(15 downto 12) <= conv_std_logic_vector(dig(3), 4);
        
  end process;
end contador_min_seg_bcd_arch;