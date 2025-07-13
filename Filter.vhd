library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Filter is
    Port ( 
        clk : in std_logic;
        reset : in std_logic;
        wr1 : in std_logic;
        wr2 : in std_logic;
        rd1 : in std_logic;
        rd2 : in std_logic;
        dina : in std_logic_vector(7 downto 0);
        dout0 : out std_logic_vector(7 downto 0);
        dout1 : out std_logic_vector(7 downto 0);
        dout2 : out std_logic_vector(7 downto 0);
        dout3 : out std_logic_vector(7 downto 0);
        dout4 : out std_logic_vector(7 downto 0);
        dout5 : out std_logic_vector(7 downto 0);
        dout6 : out std_logic_vector(7 downto 0);
        dout7 : out std_logic_vector(7 downto 0);
        dout8 : out std_logic_vector(7 downto 0)
           
    );
end Filter;

architecture Behavioral of Filter is

    component ram_fifo is 
    generic (
            G_DATAWIDTH : natural := 8;
            G_FIFODEPTH : natural := 253
        );
        port (
            clk : in std_logic;
            reset : in std_logic;
            fifo_wr : in std_logic;
            din : in std_logic_vector(G_DATAWIDTH-1 downto 0);
            fifo_rd : in std_logic;
            dout : out std_logic_vector(G_DATAWIDTH-1 downto 0)
        );
    end component;


signal cnt : natural range 0 to 600;
signal a0,a1,a2,a3,a4,a5,a6,a7,a8 : std_logic_vector(7 downto 0);
signal din1,din2,dou1,dou2, data1,data2 : std_logic_vector(7 downto 0);

begin

    dout0 <= a0;
    dout1 <= a1;
    dout2 <= a2;
    dout3 <= a3;
    dout4 <= a4;
    dout5 <= a5;
    dout6 <= a6;
    dout7 <= a7;
    dout8 <= a8;
    
    a0 <= dina;
    
    FIFO1: entity work.ram_fifo
        generic map(
            G_DATAWIDTH => 8,
            G_FIFODEPTH => 253
        )
        port map(
            clk => clk,
            reset => reset,
            fifo_wr => wr1,
            din => a2,
            fifo_rd => rd1,
            dout => a3
        );
        
    FIFO2: entity work.ram_fifo
        generic map(
            G_DATAWIDTH => 8,
            G_FIFODEPTH => 253
        )
        port map(
            clk => clk,
            reset => reset,
            fifo_wr => wr2,
            din => a5,
            fifo_rd => rd2,
            dout => a6
        );
        
COUNTER_PROC: process(clk) is
    begin
        if rising_edge(clk) then    
            if reset = '1' then
                cnt <= 0;
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;
 
STATE_TRANSITION: process(clk) is
    begin
        if rising_edge(clk) then
            a8 <= a7;
            a7<= a6;
            a5 <= a4;
            a4<=a3;
            a2 <=a1;
            a1<=a0;
        end if;
    end process;
end Behavioral;
