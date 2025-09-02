library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
library work;
library xil_defaultlib;
use work.RAM_definitions_PK.all;

entity main_control is
    generic (
        G_RAM_WIDTH : integer := 8;            		    -- Specify RAM data width 8
        G_RAM_DEPTH : integer := 256*268; 				        -- Specify RAM depth (number of entries) 256*256
        G_RAM_PERFORMANCE : string := "HIGH_PERFORMANCE"   -- Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    );
    Port ( 
        clk : in std_logic;
        reset : in std_logic
    );
end main_control;

architecture Behavioral of main_control is

component im_ram is
    generic (
        G_RAM_WIDTH : integer := 8;            		    -- Specify RAM data width
        G_RAM_DEPTH : integer := 256*268; 				        -- Specify RAM depth (number of entries) 256*256
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

    component adresar is 
    Port ( 
            clk : in std_logic;
            reset : in std_logic;
            counter : out integer
        );
    end component;

    component filter is 
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
end component;

    type State_t is (pocetak, puni, racunaj, prazni, kraj);
    signal state_reg, next_state : State_t;  
    signal addr_b,addr_a :  std_logic_vector((clogb2(G_RAM_DEPTH)-1) downto 0) := (others => '0');
    signal dout, din : std_logic_vector(G_RAM_WIDTH-1 downto 0);
    signal a1, a2 : std_logic_vector(G_RAM_WIDTH-1 downto 0); 
    signal wear : std_logic;
    signal brojac : integer;
    
    constant fifosize : integer := 253;
    constant red : integer := fifosize + 3; --256
    constant greska : integer := 3;
    
begin

RAM: entity xil_defaultlib.im_ram(Behavioral)
        generic map(
            G_RAM_WIDTH => G_RAM_WIDTH,
            G_RAM_DEPTH => G_RAM_DEPTH,
            G_RAM_PERFORMANCE => "HIGH_PERFORMANCE"
        )
        port map (
            addra => addr_a,
            addrb => addr_b,
            dina  => din,
            clka  => clk,
            wea   => wear,
            enb   => '1',
            rstb  => reset,
            regceb=> '1',
            doutb => dout
        );
        
FILTAR: entity xil_defaultlib.filter(Behavioral)
    generic map (
        DATA_WIDTH => G_RAM_WIDTH,
        G_FIFODEPTH => fifosize
        )
    port map (
        clk => clk,
        reset => reset,
        counter =>brojac,
        dina =>a2,
        medijana => din                                                    
    );

PROPAGATE: process (clk) is
    begin
        if rising_edge(clk) then
            a2 <= a1;
            a1 <= dout;
        end if;
end process PROPAGATE;

ADRESS: entity xil_defaultlib.adresar(Behavioral)
    port map(
        clk=>clk,
        reset=>reset,
        counter =>brojac
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
end process STATE_TRANSITION;

NEXT_STATE_LOGIC: process (state_reg, brojac) is
begin
        case state_reg is
            when pocetak =>    
                next_state <= puni;
            when puni =>
                if brojac = red+ 1 + greska then
                    next_state <=racunaj;
                else
                    next_state <=puni;
                end if;
            when racunaj =>
                if brojac = red *(red-1)  then
                    next_state <= prazni;
                else
                    next_state <= racunaj;
                end if;
            when prazni =>    
                if brojac = red * (red +1) +1 + greska then
                    next_state <=kraj;
                else
                    next_state <=prazni;
                end if; 
            when kraj =>
                null;
        end case;
end process NEXT_STATE_LOGIC;

ADRESS_STATE: process (state_reg,brojac) is
begin
        case state_reg is
        
            when pocetak =>    
               addr_a <= (others => '0');
               addr_b <= (others => '0');
            when puni =>

                addr_b <= std_logic_vector( to_unsigned( brojac-4, 16));
            when racunaj =>
                addr_a <= std_logic_vector( to_unsigned( brojac-13, 16));
                addr_b <= std_logic_vector( to_unsigned( brojac-4, 16));
            when prazni =>    
                addr_a <= std_logic_vector( to_unsigned( brojac-13, 16));
                
            when kraj =>
                addr_a <= (others => '0');
                addr_b <= (others => '0');  
        end case;
end process ADRESS_STATE;

WEA_STATE: process (state_reg) is
begin
        case state_reg is
        
            when pocetak =>    
               wear <= '0';
            when puni =>
                if brojac = red + 1  + greska then
                    wear <='1';
                else
                    wear <='0';
                end if;
            when racunaj =>
                --if brojac >= 2* red - fifosize + 1+  greska then
                --    wear <= '1';
                --end if;
                wear <= '1';
            when prazni =>    
               wear <= '1';
            when kraj =>
                    wear <= '0';  
        end case;
end process WEA_STATE;


end Behavioral;
