library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
library work;
use work.RAM_definitions_PK.all;

entity main is
    generic (
        G_RAM_WIDTH : integer := 8;            		    -- Specify RAM data width
        G_RAM_DEPTH : integer := 256*256; 				        -- Specify RAM depth (number of entries)
        G_RAM_PERFORMANCE : string := "HIGH_PERFORMANCE"   -- Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    );
    Port ( 
        clk: in std_logic;
        reset: in std_logic;
        ulaz : in std_logic_vector(G_RAM_WIDTH-1 downto 0)
    );
end main;

architecture Behavioral of main is
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

    type State_t is (pocetak, puni, racunaj, racunaj2, kraj);
    signal state_reg, next_state : State_t;
    signal brojacA, brojacB : integer := 0;
    constant red : integer := 256;
    
    signal Aaddr, Baddr :  std_logic_vector((clogb2(G_RAM_DEPTH)-1) downto 0);
    signal Dwea,Denb,rstb,regceb : std_logic;
    signal dout, din : std_logic_vector(G_RAM_WIDTH-1 downto 0);
    
    signal medijana : std_logic_vector(G_RAM_WIDTH-1 downto 0);

begin

RAM: entity work.im_ram(Behavioral)
        generic map(
            G_RAM_WIDTH => G_RAM_WIDTH,
            G_RAM_DEPTH => G_RAM_DEPTH,
            G_RAM_PERFORMANCE => "HIGH_PERFORMACE"
        )
        port map (
            addra => Aaddr,
            addrb => Baddr,
            dina  => ulaz,
            clka  => clk,
            wea   => Dwea,
            enb   => Denb,
            rstb  => reset,
            regceb=> '1',
            doutb => dout
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

NEXT_STATE_LOGIC: process (state_reg, reset, brojacA, brojacB) is
begin
        case state_reg is
        
            when pocetak =>    
                next_state <= puni;
            when puni =>
                if brojacA = 3 then --515 za jedan manje od broja podataka
                    next_state <=racunaj;
                else
                    next_state <=puni;
                end if;
            when racunaj =>
                if brojacA = 7 then -- 256*256
                    next_state <=racunaj2;
                else
                    next_state <=racunaj;
                end if;
            when racunaj2 =>    
                if brojacB = 7 then -- 256*256
                    next_state <=kraj;
                else
                    next_state <=racunaj2;
                end if;
            when kraj =>
                if reset = '1' then
                    next_state <= pocetak;
                else
                    next_state <= kraj;
                end if;         
        end case;
end process NEXT_STATE_LOGIC;

ADRESS_LOGIC: process (state_reg,brojacA, brojacB) is
begin
        case state_reg is
            when pocetak => 
                Aaddr <= (others=>'0');
                Baddr <= (others=>'0');                         
            when puni =>
                Aaddr <= std_logic_vector( to_unsigned( brojacA, 16));
            when racunaj =>
                Baddr <= std_logic_vector( to_unsigned( brojacB, 16));
                Aaddr <= std_logic_vector( to_unsigned( brojacA, 16));
            when racunaj2 =>    
                Baddr <= std_logic_vector( to_unsigned( brojacB, 16));
            when kraj =>
                Aaddr <= (others=>'0');
                Baddr <= (others=>'0');         
        end case;
end process ADRESS_LOGIC;

ENABLE_LOGIC: process (state_reg,Dwea,Denb) is
begin
        case state_reg is
            when pocetak =>
                Dwea <= '1'; 
                Denb <='0';                       
            when puni =>
                Dwea <= '1'; 
                Denb <='0';    
            when racunaj =>
                Dwea <= '1'; 
                Denb <='1'; 
            when racunaj2 =>    
                Dwea <= '0'; 
                Denb <='1'; 
            when kraj =>
                Dwea <= '0'; 
                Denb <='0';        
        end case;
end process ENABLE_LOGIC;

BROJAC : process (clk, state_reg)
begin
    if rising_edge(clk) then
        
        case state_reg is
         
            when pocetak =>
                brojacA <= 0;
                brojacB <= 0;                    
            when puni =>
                brojacA <= brojacA + 1;    
            when racunaj =>
                brojacB <= brojacB + 1;
                brojacA <= brojacA + 1;         
            when racunaj2 =>    
                brojacB <= brojacB + 1;    
            when kraj =>
                brojacA <= 0;
                brojacB <= 0;             
        end case;
    end if;
end process BROJAC;



end Behavioral;
