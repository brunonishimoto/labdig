-- VHDL da Unidade de Controle

library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle is
   port(clock    : in   std_logic;
        comeca   : in   std_logic;
        fim      : in   std_logic;
        reseta   : in   std_logic;
        saida    : out  std_logic_vector(4 downto 0));  -- carrega|zera|desloca|conta|pronto
end unidade_controle;

architecture exemplo of unidade_controle is
type tipo_estado is (inicial, preparacao, recepcao, final);
signal estado   : tipo_estado;
   
begin
	process (clock, estado, reseta)
	begin
   
	if reseta = '1' then
		estado <= inicial;
         
	elsif (clock'event and clock = '1') then
		case estado is
			when inicial =>			-- Aguarda sinal de inicio
				if comeca = '1' then
					estado <= preparacao;
				end if;

			when preparacao =>		-- Zera contador e carrega bit no registrador
				estado <= recepcao;
               
			when recepcao =>		-- Desloca os bits no registrador
				if fim = '1' then
					estado <= final;
				else
					estado <= recepcao;
				end if;
                              
			when final => 				-- Fim da recepcao serial
				estado <= inicial;
					
		end case;
	end if;
	end process;
   
	process (estado)
	begin
		case estado is
			when inicial =>
				saida <= "00000";
			when preparacao =>
				saida <= "11000";
			when recepcao =>
				saida <= "00110";
			when final =>
				saida <= "00001";
		end case;
   end process;
end exemplo;