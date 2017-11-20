-- modem_transmissao.vhd
--
-- componente que modela a transmissao de dados do modem
-- => usar para os testes de simulacao do projeto final
--
-- ATENCAO:
-- mudar comentarios nas linhas 90 ou 91 para selecionar contagem de atraso do CTS (sintese vs simulacao)
--
-- Labdig (3o quadrimestre de 2017)

library IEEE;
use IEEE.std_logic_1164.all;

entity modem_transmissao is 
  port ( clock, reset, DTR, RTS, TD: in STD_LOGIC;
         CTS, TC: out STD_LOGIC );
end;

architecture modem_transmissao of modem_transmissao is
    type estados_tx is (inicial_tx, espera_rts, ativa_tempo_cts, espera_tempo_cts, ativa_cts, em_transmissao);
    signal Eatual, Eprox: estados_tx;
    signal clear,enable,fim: STD_LOGIC;
begin

  -- state memory
  process (RESET, CLOCK)
  begin
      if RESET = '1' then
          Eatual <= inicial_tx;
      elsif CLOCK'event and CLOCK = '1' then
          Eatual <= Eprox; 
      end if;
  end process;

  -- next-state logic
  process (DTR, RTS, fim, Eatual) 
      variable contagem : integer range 0 to 9999;
  begin
    case Eatual is
    
      when inicial_tx =>       if DTR='0' then Eprox <= espera_rts;
                               else            Eprox <= inicial_tx;
                               end if;
                               
      when espera_rts =>       if DTR='1' then    Eprox <= inicial_tx;
                               elsif RTS='0' then Eprox <= ativa_tempo_cts;
                               else               Eprox <= espera_rts;
                               end if; 
                                    
      when ativa_tempo_cts =>  Eprox <= espera_tempo_cts;
      
      when espera_tempo_cts => if fim='0' then Eprox <= espera_tempo_cts;
                               else            Eprox <= ativa_cts;
                               end if;
                               
      when ativa_cts =>        Eprox <= em_transmissao;
      
      when em_transmissao =>   if DTR='1' then    Eprox <= inicial_tx;
                               elsif RTS='0' then Eprox <= em_transmissao;
                               else               Eprox <= espera_rts;
                               end if;

      when others =>           Eprox <= inicial_tx;
    end case;
  end process;

  -- saidas
  with Eatual select
      CTS <= '0' when ativa_cts|em_transmissao, '1' when others;
  with Eatual select
      TC <= TD when em_transmissao, '0' when others;  

  -- sinais de controle da contagem para atraso do CTS
  with Eatual select
      clear <= '1' when ativa_cts, '0' when others;
  with Eatual select
      enable <= '1' when espera_tempo_cts, '0' when others;

  -- contagem (atraso do CTS)
  process (clear,enable,CLOCK)
      variable contagem: integer range 0 to 9999;
  begin
      if CLOCK'event and CLOCK = '1' then
          if clear='1' then contagem := 0; 
          elsif enable='1' then contagem := contagem+1;
          else                  contagem := contagem;
          end if;
      end if;
      
--      if contagem = 9999 then fim<='1';  -- para clock de 50MHz -> atraso de 20ns x 10.000=200us
      if contagem = 9 then fim<='1';  -- para teste de simulacao (atraso de 10 clocks)
      else                 fim<='0';
      end if;
  end process;
end modem_transmissao;
