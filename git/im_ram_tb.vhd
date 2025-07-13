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

entity im_ram_tb is
--  Port ( );
end im_ram_tb;

architecture Behavioral of im_ram_tb is

    component im_ram is
        generic (
        G_RAM_WIDTH : integer := 8;            		    -- Specify RAM data width
        G_RAM_DEPTH : integer := 256*256; 				        -- Specify RAM depth (number of entries)
        G_RAM_PERFORMANCE : string := "HIGH_PERFORMANCE"   -- Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    );
    port (
        addra : in std_logic_vector((clogb2(G_RAM_DEPTH)-1) downto 0);     -- Write address bus, width determined from RAM_DEPTH
        addrb : in std_logic_vector((clogb2(G_RAM_DEPTH)-1) downto 0);     -- Read address bus, width determined from RAM_DEPTH
        dina  : in std_logic_vector(G_RAM_WIDTH-1 downto 0);		  -- RAM input data
        clka  : in std_logic;                       			  -- Clock
        wea   : in std_logic;                       			  -- Write enable
        enb   : in std_logic;                       			  -- RAM Enable, for additional power savings, disable port when not in use
        rstb  : in std_logic;                       			  -- Output reset (does not affect memory contents)
        regceb: in std_logic;                       			  -- Output register enable
        doutb : out std_logic_vector(G_RAM_WIDTH-1 downto 0) 		  -- RAM output data
    );
    end component;
   constant C_CLK_PERIOD: time := 125 ms;
   signal clk_tb : std_logic :='1'; 
   signal reset: std_logic;
   constant  G_RAM_WIDTH : integer := 8;
   constant  G_RAM_DEPTH : integer := 256*256;
   signal addra, addrb :  std_logic_vector((clogb2(G_RAM_DEPTH)-1) downto 0);
   signal wea,enb,rstb,regceb : std_logic;
   signal doutb, dina : std_logic_vector(G_RAM_WIDTH-1 downto 0);
    
begin
    clk_tb<= not clk_tb after C_CLK_PERIOD/2;
    DUT: entity work.im_ram
        port map(
        addra => addra,
        addrb => addrb,
        dina  => dina,
        clka  => clk_tb,
        wea   => wea,
        enb  => '0',
        rstb => rstb,
        regceb=> regceb,
        doutb=> doutb
        );
        
    STIMULUS: process is 
    begin 
        rstb<= '1';
        addra <= (others=>'0');
        addrb <= (others=>'0');
        wait for C_CLK_PERIOD; 
        rstb <= '0';
        dina <= "00000001";
        wea <= '1';
        wait for C_CLK_PERIOD; 
        addra <="0000000000000001";
        dina <= "00000101";
        wait for C_CLK_PERIOD; 
        addra <="0000000000000010";
        dina <= "00100101";
        wait for C_CLK_PERIOD; 
        addra <="0000000000000011";
        dina <= "00101101";
        wea <= '0';
        wait for C_CLK_PERIOD;
        
        regceb <= '1';
        wait for C_CLK_PERIOD;
        addrb <= "0000000000000001";
        wait for C_CLK_PERIOD;
        addrb <= "0000000000000010";
        wait for C_CLK_PERIOD;
        addrb <= "0000000000000011";
        wait;     
    end process STIMULUS;

end Behavioral;
