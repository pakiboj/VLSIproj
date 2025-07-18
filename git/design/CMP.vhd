----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.12.2024 16:29:08
-- Design Name: 
-- Module Name: CMP - Behavioral
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

entity CMP is
  Port ( 
    reset: in std_logic;
    in1: in std_logic_vector(7 downto 0);
    in2: in std_logic_vector(7 downto 0); 
    out1: out std_logic_vector(7 downto 0);
    out2: out std_logic_vector(7 downto 0)
  );
end CMP;

architecture Behavioral of CMP is
begin
    process (reset,in1,in2) is
    begin
        if reset = '1' then
            out1 <= (others => '0');
            out2 <= (others => '0');
        else
            if in1 > in2 then
                out2 <= in1;
                out1 <= in2;
            else
                out2 <= in2;
                out1 <= in1;
            end if;
        end if;
    end process;

end Behavioral;
