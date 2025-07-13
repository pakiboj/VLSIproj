----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.12.2024 15:46:40
-- Design Name: 
-- Module Name: Medijan - Behavioral
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

entity Medijan is
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
end Medijan;

architecture Behavioral of Medijan is
    component CMP is
    Port ( 
        reset: in std_logic;
        in1: in std_logic_vector(7 downto 0);
        in2: in std_logic_vector(7 downto 0); 
        out1: out std_logic_vector(7 downto 0);
        out2: out std_logic_vector(7 downto 0)
    );
    end component;
    signal a10,a11,a12,a13,a14,a15,a16,a17: std_logic_vector(7 downto 0);
    signal a20,a21,a22,a23,a24,a25,a26,a27: std_logic_vector(7 downto 0);
    signal a40,a41,a42,a43,a44,a45,a46,a47: std_logic_vector(7 downto 0);
    signal a31,a32,a35,a36: std_logic_vector(7 downto 0);
    signal a52,a53,a54,a55: std_logic_vector(7 downto 0);
    signal a61,a62,a63,a64,a65,a66: std_logic_vector(7 downto 0);
    signal a70,a78: std_logic_vector(7 downto 0);
    signal a84,a88: std_logic_vector(7 downto 0);
    signal a92,a93,a94,a95: std_logic_vector(7 downto 0);
begin

    CMP1: entity work.CMP
        port map(
        reset => reset,
        in1 => a0,
        in2 => a1,
        out1 => a10,
        out2 => a11
        );
    CMP2: entity work.CMP
        port map(
        reset => reset,
        in1 => a2,
        in2 => a3,
        out1 => a12,
        out2 => a13
        );
    CMP3: entity work.CMP
        port map(
        reset => reset,
        in1 => a4,
        in2 => a5,
        out1 => a14,
        out2 => a15
        );
    CMP4: entity work.CMP
        port map(
        reset => reset,
        in1 => a6,
        in2 => a7,
        out1 => a16,
        out2 => a17
        );
        
        
    CMP11: entity work.CMP
        port map(
        reset => reset,
        in1 => a10,
        in2 => a12,
        out1 => a20,
        out2 => a22
        );
    CMP12: entity work.CMP
        port map(
        reset => reset,
        in1 => a11,
        in2 => a13,
        out1 => a21,
        out2 => a23
        );
    CMP13: entity work.CMP
        port map(
        reset => reset,
        in1 => a14,
        in2 => a16,
        out1 => a24,
        out2 => a26
        );
    CMP14: entity work.CMP
        port map(
        reset => reset,
        in1 => a15,
        in2 => a17,
        out1 => a25,
        out2 => a27
        );
        
    
    
    CMP21: entity work.CMP
        port map(
        reset => reset,
        in1 => a21,
        in2 => a22,
        out1 => a31,
        out2 => a32
        );
    CMP22: entity work.CMP
        port map(
        reset => reset,
        in1 => a25,
        in2 => a26,
        out1 => a35,
        out2 => a36
        );
        
        
        
    CMP31: entity work.CMP
        port map(
        reset => reset,
        in1 => a20,
        in2 => a24,
        out1 => a40,
        out2 => a44
        );
    CMP32: entity work.CMP
        port map(
        reset => reset,
        in1 => a31,
        in2 => a35,
        out1 => a41,
        out2 => a45
        );
    CMP33: entity work.CMP
        port map(
        reset => reset,
        in1 => a32,
        in2 => a36,
        out1 => a42,
        out2 => a46
        );
    CMP34: entity work.CMP
        port map(
        reset => reset,
        in1 => a23,
        in2 => a27,
        out1 => a43,
        out2 => a47
        );
        
        
        
    CMP41: entity work.CMP
        port map(
        reset => reset,
        in1 => a42,
        in2 => a44,
        out1 => a52,
        out2 => a54
        );
    CMP42: entity work.CMP
        port map(
        reset => reset,
        in1 => a43,
        in2 => a45,
        out1 => a53,
        out2 => a55
        );
        
        
    CMP51: entity work.CMP
        port map(
        reset => reset,
        in1 => a41,
        in2 => a52,
        out1 => a61,
        out2 => a62
        );
    CMP52: entity work.CMP
        port map(
        reset => reset,
        in1 => a53,
        in2 => a54,
        out1 => a63,
        out2 => a64
        );
    CMP53: entity work.CMP
        port map(
        reset => reset,
        in1 => a55,
        in2 => a46,
        out1 => a65,
        out2 => a66
        );
    CMP54: entity work.CMP
        port map(
        reset => reset,
        in1 => a40,
        in2 => a8,
        out1 => a70,
        out2 => a78
        );


    CMP61: entity work.CMP
        port map(
        reset => reset,
        in1 => a64,
        in2 => a78,
        out1 => a84,
        out2 => a88
        );
        
        
   CMP71: entity work.CMP
        port map(
        reset => reset,
        in1 => a62,
        in2 => a84,
        out1 => a92,
        out2 => a94
        );
   CMP72: entity work.CMP
        port map(
        reset => reset,
        in1 => a63,
        in2 => a65,
        out1 => a93,
        out2 => a95
        );
        
   CMPkraj: entity work.CMP
        port map(
        reset => reset,
        in1 => a93,
        in2 => a94,
        out1 => open,
        out2 => s
        );

end Behavioral;
