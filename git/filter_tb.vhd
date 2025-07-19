library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity filter_tb is
end filter_tb;


architecture Behavioral of filter_tb is

component filter is
    generic (sirina: integer := 8);
    port (
        clk: in std_logic;
        reset: in std_logic;
        in_byte: in std_logic_vector (7 downto 0);
        dugme: in std_logic;
        medijana: out std_logic_vector (7 downto 0)
    );
end component;

constant C_CLK_PERIOD: time := 8 ns;
signal clk_tb:  std_logic := '1';
signal reset:  std_logic;
signal in_byte:  std_logic_vector (7 downto 0);
signal dugme:  std_logic;
signal medijana:  std_logic_vector (7 downto 0);

begin

DUT: entity work.filter port map (
        clk => clk_tb,
        reset => reset,
        in_byte => in_byte,
        dugme => dugme,
        medijana => medijana );

clk_tb<= not clk_tb after C_CLK_PERIOD/2;

STIMULUS: process is
begin
    reset <= '1';
    wait for C_CLK_PERIOD;
    reset <= '0';
    wait for 3*C_CLK_PERIOD;
    dugme <= '1';
    wait for C_CLK_PERIOD;
    dugme <= '0';
    in_byte <= "00000000";
    wait for C_CLK_PERIOD; 
    in_byte <= "00000001";
    wait for C_CLK_PERIOD;
    in_byte <= "00000010";
    wait for C_CLK_PERIOD;
    in_byte <= "00000011";
    wait for C_CLK_PERIOD;
    in_byte <= "00000100";
    wait for C_CLK_PERIOD;
    in_byte <= "00000101";
    wait for C_CLK_PERIOD;
    in_byte <= "00000110";
    wait for C_CLK_PERIOD;
    in_byte <= "00000111";
    wait for C_CLK_PERIOD;
    
    in_byte <= "00000000";
    wait for C_CLK_PERIOD;
    in_byte <= "00000001";
    wait for C_CLK_PERIOD;
    in_byte <= "00000010";
    wait for C_CLK_PERIOD;
    in_byte <= "00000011";
    wait for C_CLK_PERIOD;
    in_byte <= "00000100";
    wait for C_CLK_PERIOD;
    in_byte <= "00000101";
    wait for C_CLK_PERIOD;
    in_byte <= "00000110";
    wait for C_CLK_PERIOD;
    in_byte <= "00000111";
    wait for C_CLK_PERIOD;
    
    in_byte <= "00000000";
    wait for C_CLK_PERIOD;
    in_byte <= "00000001";
    wait for C_CLK_PERIOD;
    in_byte <= "00000010";
    wait for C_CLK_PERIOD;
    in_byte <= "00000011";
    wait for C_CLK_PERIOD;
    in_byte <= "00000100";
    wait for C_CLK_PERIOD;
    in_byte <= "00000101";
    wait for C_CLK_PERIOD;
    in_byte <= "00000110";
    wait for C_CLK_PERIOD;
    in_byte <= "00000111";
    wait for C_CLK_PERIOD;
    
    in_byte <= "00000000";
    wait for C_CLK_PERIOD;
    in_byte <= "00000001";
    wait for C_CLK_PERIOD;
    in_byte <= "00000010";
    wait for C_CLK_PERIOD;
    in_byte <= "00000011";
    wait for C_CLK_PERIOD;
    in_byte <= "00000100";
    wait for C_CLK_PERIOD;
    in_byte <= "00000101";
    wait for C_CLK_PERIOD;
    in_byte <= "00000110";
    wait for C_CLK_PERIOD;
    in_byte <= "00000111";
    wait for C_CLK_PERIOD;
    
    in_byte <= "00000000";
    wait for C_CLK_PERIOD;
    in_byte <= "00000001";
    wait for C_CLK_PERIOD;
    in_byte <= "00000010";
    wait for C_CLK_PERIOD;
    in_byte <= "00000011";
    wait for C_CLK_PERIOD;
    in_byte <= "00000100";
    wait for C_CLK_PERIOD;
    in_byte <= "00000101";
    wait for C_CLK_PERIOD;
    in_byte <= "00000110";
    wait for C_CLK_PERIOD;
    in_byte <= "00000111";
    wait for C_CLK_PERIOD;
    
    in_byte <= "00000000";
    wait for C_CLK_PERIOD;
    in_byte <= "00000001";
    wait for C_CLK_PERIOD;
    in_byte <= "00000010";
    wait for C_CLK_PERIOD;
    in_byte <= "00000011";
    wait for C_CLK_PERIOD;
    in_byte <= "00000100";
    wait for C_CLK_PERIOD;
    in_byte <= "00000101";
    wait for C_CLK_PERIOD;
    in_byte <= "00000110";
    wait for C_CLK_PERIOD;
    in_byte <= "00000111";
    wait for C_CLK_PERIOD;
    
    in_byte <= "00000000";
    wait for C_CLK_PERIOD;
    in_byte <= "00000001";
    wait for C_CLK_PERIOD;
    in_byte <= "00000010";
    wait for C_CLK_PERIOD;
    in_byte <= "00000011";
    wait for C_CLK_PERIOD;
    in_byte <= "00000100";
    wait for C_CLK_PERIOD;
    in_byte <= "00000101";
    wait for C_CLK_PERIOD;
    in_byte <= "00000110";
    wait for C_CLK_PERIOD;
    in_byte <= "00000111";
    wait for C_CLK_PERIOD;
    
    in_byte <= "00000000";
    wait for C_CLK_PERIOD;
    in_byte <= "00000001";
    wait for C_CLK_PERIOD;
    in_byte <= "00000010";
    wait for C_CLK_PERIOD;
    in_byte <= "00000011";
    wait for C_CLK_PERIOD;
    in_byte <= "00000100";
    wait for C_CLK_PERIOD;
    in_byte <= "00000101";
    wait for C_CLK_PERIOD;
    in_byte <= "00000110";
    wait for C_CLK_PERIOD;
    in_byte <= "00000111";
    wait for C_CLK_PERIOD;
    
    wait;
end process;
end Behavioral;
