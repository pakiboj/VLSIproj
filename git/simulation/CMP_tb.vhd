----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.12.2024 16:37:52
-- Design Name: 
-- Module Name: CMP_tb - Behavioral
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

entity CMP_tb is
--  Port ( );
end CMP_tb; 

architecture Behavioral of CMP_tb is

    component CMP is
    Port ( 
        clk: in std_logic;
        reset: in std_logic;
        in1: in std_logic_vector(7 downto 0);
        in2: in std_logic_vector(7 downto 0); 
        out1: out std_logic_vector(7 downto 0);
        out2: out std_logic_vector(7 downto 0)
  );
  end component;
  constant C_CLK_PERIOD: time := 125 ms;
  signal clk_tb : std_logic :='1'; 
  signal reset: std_logic;
  signal in1,in2,out1,out2: std_logic_vector(7 downto 0);
begin
    clk_tb<= not clk_tb after C_CLK_PERIOD/2;
    DUT: entity work.CMP
        port map(
        clk => clk_tb,
        reset => reset,
        in1 => in1,
        in2 => in2,
        out1 => out1,
        out2 => out2
        );
        
    STIMULUS: process is 
    begin 
        reset<= '1';
        in1 <= "00000100";
        in2 <= "00000010";
        wait for C_CLK_PERIOD; 
        reset <= '0';
        wait;
    end process STIMULUS;
end Behavioral;
