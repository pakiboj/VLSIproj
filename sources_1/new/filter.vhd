library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
library work;
library xil_defaultlib;
use work.RAM_definitions_PK.all;

entity filter is
    generic (
        DATA_WIDTH: integer := 8;
        G_FIFODEPTH : natural := 253
        );
    port (
        clk: in std_logic;
        reset: in std_logic;
        counter : in integer;
        dina: in std_logic_vector (7 downto 0);                                          --ulazna informacija                                                               --signal za pocetak rada filtera
        medijana: out std_logic_vector (7 downto 0)                                                              --izlaz brojaca
    );
end filter;

architecture Behavioral of filter is

    type State_t is (pocetak, puni, racunaj, prazni, kraj, shift);
    signal state_reg, next_state : State_t; 
    
    
    signal r0, r1, r2, r3, r4, r5, r6, r7, r8: std_logic_vector (DATA_WIDTH-1 downto 0) := (others => '0'); 
    signal med: std_logic_vector (DATA_WIDTH-1 downto 0):=(others => '0'); 
    
    signal fifo1_in, fifo2_in, fifo1_out, fifo2_out : std_logic_vector(DATA_WIDTH-1 downto 0);
                                            
                                            
    signal fifo1_rd, fifo2_rd: std_logic := '0';                                            --write enable za fifo
     
    
    constant red : integer := G_FIFODEPTH + 3; --256
    constant greska : integer := 3;
    
       
    component Medijan is
    Port ( 
        reset: in std_logic;
        a0 : in std_logic_vector(DATA_WIDTH downto 0);
        a1 : in std_logic_vector(DATA_WIDTH downto 0);
        a2 : in std_logic_vector(DATA_WIDTH downto 0);
        a3 : in std_logic_vector(DATA_WIDTH downto 0);
        a4 : in std_logic_vector(DATA_WIDTH downto 0);
        a5 : in std_logic_vector(DATA_WIDTH downto 0);
        a6 : in std_logic_vector(DATA_WIDTH downto 0);
        a7 : in std_logic_vector(DATA_WIDTH downto 0);
        a8 : in std_logic_vector(DATA_WIDTH downto 0);
        s: out std_logic_vector(DATA_WIDTH downto 0)
   );
end component;

    component ram_fifo is
    generic (
        G_DATAWIDTH : natural := 8;
        G_FIFODEPTH : natural := 253
    );
    port (
        clk : in std_logic;
        reset : in std_logic;
        fifo_wr : in std_logic;
        din : in std_logic_vector(G_DATAWIDTH downto 0);
        fifo_rd : in std_logic;
        dout : out std_logic_vector(G_DATAWIDTH downto 0)
    );
    end component;
 
begin

DUT_MEDIJAN: entity xil_defaultlib.Medijan port map (
        reset => reset,
        a0 => r0,
        a1 => r1,
        a2 => r2,
        a3 => r3,
        a4 => r4,
        a5 => r5,
        a6 => r6,
        a7 => r7,
        a8 => r8,
        s => med
        ); 

DUT_FIFO1: entity xil_defaultlib.ram_fifo port map (
        clk => clk,
        reset => reset,
        fifo_wr => '1',
        din => r2,
        fifo_rd => fifo1_rd,
        dout => r3       
        );

DUT_FIFO2: entity xil_defaultlib.ram_fifo port map (
        clk => clk,
        reset => reset,
        fifo_wr => '1',
        din => r5,
        fifo_rd => fifo2_rd,
        dout => r6       
        );

STATE_TRANSITION: process (clk) is
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state_reg <= pocetak;
            else
                state_reg <= next_state;            
            end if;
        end if;
end process;

STATE_PROCESS: process (clk) is
    begin
        if rising_edge(clk) then
        
            r0 <= dina;
            r1 <= r0;
            r2 <= r1;
            
            r4 <= r3;
            r5 <= r4;
            
            r7 <= r6;
            r8 <= r7;
            
        end if;
end process STATE_PROCESS;

NEXT_STATE_LOGIC: process (state_reg, counter) is
begin
        case state_reg is
            when pocetak =>    
                next_state <= puni;
            when puni =>
                if counter = red+ 1 + greska then
                    next_state <=racunaj;
                else
                    next_state <=puni;
                end if;
            when racunaj =>
                if counter mod red = 1 then
                    next_state <= shift;
                else
                    next_state <=racunaj;
                end if; 
                
                if counter = red *(red-1)  then
                    next_state <= prazni;
                else
                    next_state <= racunaj;
                end if;
            when prazni =>    
                if counter = red * (red +1) +1 + greska then
                    next_state <=kraj;
                else
                    next_state <=prazni;
                end if; 
            when kraj =>
                null;
            when shift =>
                if counter = red + greska + 1 then
                    next_state <=shift;
                else 
                    next_state <= racunaj;
                end if;
        end case;
end process NEXT_STATE_LOGIC;

FIFO_STATE: process (state_reg,counter) is
begin
        case state_reg is
            when pocetak =>    
                fifo1_rd <= '0';
                fifo2_rd <= '0';
            when puni =>
                if counter >= red + greska then
                    fifo1_rd <= '1';
                end if;
            when racunaj =>
                if counter >= 2* red - G_FIFODEPTH + 1+  greska then
                    fifo2_rd <= '1';
                    fifo1_rd <= '1';
                end if;
            when prazni =>    
                fifo1_rd <= '1';
                fifo2_rd <= '1';
            when kraj =>
                fifo1_rd <= '0';
                fifo2_rd <= '0';
            when shift =>
                fifo1_rd <= '1';
                fifo2_rd <= '1';
        end case;
end process FIFO_STATE;

MEDI_STATE: process (state_reg) is
begin
        case state_reg is
        
            when pocetak =>    
                
            when puni =>
                
            when racunaj =>
                
            when prazni =>    
                
            when kraj =>
                
            when shift =>
                
        end case;
end process MEDI_STATE;

OUPUT_STATE: process(state_reg, counter) is
begin
    case state_reg is
        when racunaj =>
            if counter >= 2* red - G_FIFODEPTH + 8 +  greska then
                    medijana <= med;
                    else
                    medijana <= "00000000";
                end if;
            if counter mod red = 1 or counter mod red = 2 then
                medijana <= "00000000";
            end if;
        when prazni => 
            if counter >= red * red + greska then
            medijana <= "00000000";
            else
            medijana <= med;
            end if;
        when others =>
            medijana <= (others => '0');
    end case;
    
end process OUPUT_STATE;

end Behavioral;
