----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.07.2025 13:29:20
-- Design Name: 
-- Module Name: im_ram_tb - Behavioral
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


library IEEE;library IEEE;
use IEEE.STD_LOGIC_1164.ALL;use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;-- Uncomment the following library declaration if using
library work;-- arithmetic functions with Signed or Unsigned values
use work.RAM_definitions_PK.all;--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main_tb is
--  Port ( );
end main_tb;

architecture Behavioral of main_tb is

    component main is
        generic (
        G_RAM_WIDTH : integer := 8;            		    -- Specify RAM data width
        G_RAM_DEPTH : integer := 256*256; 				        -- Specify RAM depth (number of entries)
        G_RAM_PERFORMANCE : string := "HIGH_PERFORMANCE"   -- Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    );
    Port ( 
        clk: in std_logic;
        reset: in std_logic
    );
    end component;
   constant C_CLK_PERIOD: time := 125 ms;
   signal clk_tb : std_logic :='1'; 
   signal reset: std_logic;
   
   constant  G_RAM_WIDTH : integer := 8;
   constant  G_RAM_DEPTH : integer := 256*256;
   signal addra, addrb :  std_logic_vector((clogb2(G_RAM_DEPTH)-1) downto 0);
   signal wea,enb,rstb,regceb : std_logic;
   signal ulaz : std_logic_vector(G_RAM_WIDTH-1 downto 0);
    
begin
    clk_tb<= not clk_tb after C_CLK_PERIOD/2;
    DUT: entity work.main
        port map(
        clk => clk_tb,
        reset => reset,
        ulaz =>ulaz
        );
        
    STIMULUS: process is 
    begin 
        reset <= '1';
        wait for C_CLK_PERIOD; 
        reset <= '0';
        wait for C_CLK_PERIOD;
        ulaz <= "00000000";
        wait for C_CLK_PERIOD;
        ulaz <= "00000001";
        wait for C_CLK_PERIOD;
        ulaz <= "00000010";
        wait for C_CLK_PERIOD;
        ulaz <= "00000011";
        wait for C_CLK_PERIOD;
        ulaz <= "00000100";
        wait for C_CLK_PERIOD;
        ulaz <= "00000101";
        wait for C_CLK_PERIOD;
        ulaz <= "00000110";
        wait for C_CLK_PERIOD;
        ulaz <= "00000111";
        wait for C_CLK_PERIOD;
        ulaz <= "00001000";
        wait for C_CLK_PERIOD;
        ulaz <= "00001001";
        wait for C_CLK_PERIOD;
        ulaz <= "00001010";
        wait for C_CLK_PERIOD;
        ulaz <= "00001011";
        wait;     
    end process STIMULUS;


end Behavioral;
