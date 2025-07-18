library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity brojac_tb is
end;

architecture bench of brojac_tb is

  component brojac
    generic (
    duzina: integer := 8
    );
    port ( 
    clk: in std_logic;
    reset: in std_logic;
    broj_hor: out integer;
    broj_ver: out integer
    );
  end component;

  signal clk: std_logic;
  signal reset: std_logic;
  signal broj_hor: integer;
  signal broj_ver: integer;

  constant DUZZINA: integer:= 8;
  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: brojac
                 port map ( clk      => clk,
                            reset    => reset,
                            broj_hor => broj_hor,
                            broj_ver => broj_ver
                             );

  stimulus: process
  begin
    
    reset <= '1';
    wait for clock_period;
    reset <= '0';
    wait for 10 * clock_period;
    reset <= '1';
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;