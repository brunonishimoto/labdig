-- interface_sensor.vhd
--
library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;


entity cronometro is
    port (
        CLK, reset, botao:       in  std_logic;
        hex0, hex1, hex2, hex3:  out std_logic_vector (6 downto 0)
    );
end cronometro;

architecture cronometro of cronometro is
    signal s_estado, s_tick: std_logic;
    signal s_Q : std_logic_vector (15 downto 0);
    signal s_min_dez, s_min_un, s_seg_dez, s_seg_un: std_logic_vector(3 downto 0);
     
    component start_stop port ( 
        clock, reset, botao: in STD_LOGIC;
        estado: out STD_LOGIC );
    end component;
    
    component contador_tick is
    generic (
        M: integer);
    port (
        clk, reset: in std_logic;
        tick: out std_logic);
    end component;
    
    component contador_min_seg_bcd port (
        clk, zera, conta, tick: in STD_LOGIC;
        Q: out STD_LOGIC_VECTOR (15 downto 0);
        fim: out STD_LOGIC );
    end component;
    
    component hex_7seg_en port (
		hex : in std_logic_vector (3 downto 0);
		enable : in std_logic;
		d7seg : out std_logic_vector (6 downto 0));
    end component;

begin

    -- inverter sinais reset e botao caso mapeado em botoes da placa DE1/DE2/DE0-CV
    U1: start_stop port map (clk, reset, botao, s_estado);
    -- testar com simulacao com M=10 --> usar 50.000.000 para circuito na placa FPGA
    U2: contador_tick generic map (M => 10) port map (clk, reset, s_tick);  -- para simulacao
	 --U2: contador_tick generic map (M => 50000000) port map (clk, reset, s_tick);
    U3: contador_min_seg_bcd port map (clk, reset, s_estado, s_tick, s_Q);
    s_min_dez <= s_Q(15 downto 12);
    s_min_un <= s_Q(11 downto 8);
    s_seg_dez <= s_Q(7 downto 4);
    s_seg_un <= s_Q(3 downto 0);
    U4: hex_7seg_en port map (s_min_dez, '1', hex3);
    U5: hex_7seg_en port map (s_min_un, '1', hex2);
    U6: hex_7seg_en port map (s_seg_dez, '1', hex1);
    U7: hex_7seg_en port map (s_seg_un, '1', hex0);
        
end cronometro;

