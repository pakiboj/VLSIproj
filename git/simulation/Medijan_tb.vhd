----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.12.2024 17:47:31
-- Design Name: 
-- Module Name: Medijan_tb - Behavioral
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

entity Medijan_tb is
--  Port ( );
end Medijan_tb;

architecture Behavioral of Medijan_tb is
    
    component Medijan is
    Port ( 
        reset: in std_logic;
        a0 : in std_logic_vector(7 downto 0);
        a1 : in std_logic_vector(7 downto 0);
        a2 : in std_logic_vector(7 downto 0);
        a3 : in std_logic_vector(7 downto 0);
        a4 : in std_logic_vector(7 downto 0);
        a5 : in std_logic_vector(7 downto 0);
        a6 : in std_logic_vector(7 downto 0);
        a7 : in std_logic_vector(7 downto 0);
        a8 : in std_logic_vector(7 downto 0);
        s: out std_logic_vector(7 downto 0)
   );
   end component;
   constant C_CLK_PERIOD: time := 125 ms;
   signal clk_tb : std_logic :='1'; 
   signal reset: std_logic;
   signal a0,a1,a2,a3,a4,a5,a6,a7,a8,s: std_logic_vector(7 downto 0);
begin

    clk_tb<= not clk_tb after C_CLK_PERIOD/2;
    DUT: entity work.Medijan
        port map(
        reset => reset,
        a0 => a0,
        a1 => a1,
        a2 =>a2,
        a3 =>a3,
        a4 =>a4,
        a5 =>a5,
        a6 =>a6,
        a7 =>a7,
        a8 =>a8,
        s =>s
        );
        
    STIMULUS: process is 
    begin 
        reset<= '1';
        a0 <= "10000000";
        a1 <= "00010001";
        a2 <= "11000010";
        a3 <= "00000011";
        a4 <= "00000000";
        a5 <= "00000101";
        a6 <= "00110110";
        a7 <= "11100111";
        a8 <= "00001011";
        wait for C_CLK_PERIOD; 
        reset <= '0';
        wait;
    end process STIMULUS;

end Behavioral;
