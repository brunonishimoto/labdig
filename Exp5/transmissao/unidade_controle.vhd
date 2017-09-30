-- VHDL da Unidade de Controle

library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle is
   port(clock  : in  std_logic;
        comeca : in  std_logic;
        fim    : in  std_logic;
        reseta : in  std_logic;
        estado : out  std_logic_vector(4 downto 0));  -- carrega|zera|desloca|conta|pronto
end unidade_controle;

architecture unidade_controle of unidade_controle is
type tipo_estado is (inicial, preparacao, transmissao, final, espera);
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

			when preparacao =>		-- Zera contador e carrega bits no registrador
				estado <= transmissao;
               
			when transmissao =>		-- Desloca os bits no registrador
				if fim = '1' then
					estado <= final;
				else
					estado <= transmissao;
				end if;
                              
			when final => 				-- Fim da transmissao serial
				estado <= espera;
					
			when espera =>				-- Detector de borda do sinal de inicio
				if comeca = '1' then 
					estado <= espera;
				else
					estado <= inicial;
				end if;
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
			when transmissao =>
				saida <= "00110";
			when final =>
				saida <= "00001";
			when espera =>
				saida <= "00000";
		end case;
   end process;
end unidade_controle;