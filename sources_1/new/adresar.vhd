library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
library work;
use work.RAM_definitions_PK.all;

entity adresar is
    Port ( 
        clk : in std_logic;
        reset : in std_logic;
        counter : out integer
    );
end adresar;

architecture Behavioral of adresar is
    signal broj : integer := 0;
begin
    BROJAC : process (clk) is
    begin
        if rising_edge(clk) then
            if reset = '1' then 
            broj <= 0;
            else
            broj <= broj +1;
            end if;
        end if;
    end process BROJAC;
    counter <= broj;
end Behavioral;
