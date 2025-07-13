----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.07.2025 17:57:00
-- Design Name: 
-- Module Name: ram_fifo_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ram_fifo_tb is
--  Port ( );
end ram_fifo_tb;

architecture Behavioral of ram_fifo_tb is

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
   constant C_CLK_PERIOD: time := 125 ms;
   constant G_DATAWIDTH : natural :=8;
   signal clk_tb : std_logic :='1'; 
   signal reset: std_logic;
   signal fifo_wr, fifo_rd : std_logic;
   signal  din, dout : std_logic_vector(G_DATAWIDTH-1 downto 0);
begin

    clk_tb<= not clk_tb after C_CLK_PERIOD/2;
    DUT: entity work.ram_fifo
        port map(
        clk => clk_tb,
        reset => reset,
        fifo_wr =>fifo_wr,
        din =>din,
        fifo_rd =>fifo_rd,
        dout => dout
        );
        
    STIMULUS: process is 
    begin 
        reset<= '1';
        wait for C_CLK_PERIOD; 
        reset <= '0';
        
        wait for C_CLK_PERIOD;
        fifo_wr <= '1';
        din <= "10000000";
        wait for C_CLK_PERIOD;
        din <= "00000001";
        wait for C_CLK_PERIOD;
        din <= "00000010";
        wait for C_CLK_PERIOD;
        
        fifo_rd <= '1';
        din <= "00000011";
        wait for C_CLK_PERIOD;
        din <= "00000100";
        wait for C_CLK_PERIOD;
        din <= "00000101";
        wait for C_CLK_PERIOD;
        din <= "00000110";
        fifo_wr <= '0';
        wait for C_CLK_PERIOD;
        din <= "00000111";
        wait for C_CLK_PERIOD; 
        
        wait for C_CLK_PERIOD; 
        wait;
    end process STIMULUS;

end Behavioral;
