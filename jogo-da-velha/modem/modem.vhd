-- modem.vhd
--
-- componente que modela o comportamento do modem e possui a mesma interface do circuito Am7910
-- => usar para os testes de simulacao do projeto final
--
--
-- ATENCAO: editar arquivo modem_transmissao.vhd para selecionar contagem de atraso do CTS (sintese vs simulacao)
--
-- Labdig (3o quadrimestre de 2017)

library IEEE;
use IEEE.std_logic_1164.all;

entity modem is
	port ( clock, reset, DTR: in STD_LOGIC;
           -- transmissao
           RTS:               in STD_LOGIC;
           CTS:               out STD_LOGIC;
           TD:                in STD_LOGIC;
           TC:                out STD_LOGIC;
           -- recepcao
           RC:                in STD_LOGIC;
           CD, RD:            out STD_LOGIC);
end modem;

architecture modem_arch of modem is

    component modem_recepcao port 
        ( clock, reset, DTR, RC: in STD_LOGIC;
          CD, RD: out STD_LOGIC );
    end component;


    component modem_transmissao port 
         ( clock, reset, DTR, RTS, TD: in STD_LOGIC;
           CTS, TC: out STD_LOGIC );
    end component;

begin

	TX: modem_transmissao port map (clock, reset, DTR, RTS, TD, CTS, TC);
	RX: modem_recepcao    port map (clock, reset, DTR, RC, CD, RD);

	
end modem_arch;