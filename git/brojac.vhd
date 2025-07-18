library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.all;

entity brojac is
  generic (
  duzina: integer := 8
  );
  port ( 
  clk: in std_logic;
  reset: in std_logic;
  broj_hor: out integer;
  broj_ver: out integer
  );
end brojac;

architecture Behavioral of brojac is

signal cnt_hor: integer := 0; 
signal cnt_ver: integer := 0;

begin

BROJANJE: process (clk) is
begin
    if rising_edge(clk) then
        if reset = '1' then
            cnt_hor <= 0;
            cnt_ver <= 0;
        else
            cnt_hor <= cnt_hor + 1;
            if cnt_hor = duzina - 1 then
                cnt_hor <= 0;
                cnt_ver <= cnt_ver + 1;
                if cnt_ver = duzina - 1 then
                    cnt_ver <= 0;
                end if;
            end if;
        end if;
    end if;
end process;
 
ISPIS: process (clk) is
begin
if rising_edge(clk) then
    broj_hor <= cnt_hor;
    broj_ver <= cnt_ver;
 end if;
 end process;
      
end Behavioral;
