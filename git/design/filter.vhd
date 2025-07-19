library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity filter is
    generic (sirina: integer := 8);
    port (
        clk: in std_logic;
        reset: in std_logic;
        in_byte: in std_logic_vector (7 downto 0);
        dugme: in std_logic;
        medijana: out std_logic_vector (7 downto 0)
    );
end filter;

architecture behavioral of filter is

    type stanja is (init, punjenje, racun, sift);
    signal r0, r1, r2, r3, r4, r5, r6, r7, r8, rf1, rf2: std_logic_vector (7 downto 0) := "11111111";
    signal fifo1_in, fifo2_in, fifo1_out, fifo2_out: std_logic_vector (7 downto 0);
    signal trenutno, sledece: stanja;
    signal br_hor, br_ver: integer;
    signal flag_hor, flag_ver, flag_punj: std_logic := '0';
    signal fifo1_rd, fifo2_rd: std_logic := '0';
    signal fifo1_wr, fifo2_wr: std_logic := '0';
    signal med: std_logic_vector (7 downto 0);

-- DODAVANJE KOMPONENTI

component ram_fifo is
    generic (
        G_DATAWIDTH : natural := 8;
        G_FIFODEPTH : natural := 5
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

begin

-- POVEZIVANJE KOMPONENTI

DUT_MEDIJAN: entity work.Medijan port map (
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

DUT_FIFO1: entity work.ram_fifo port map (
        clk => clk,
        reset => reset,
        fifo_wr => fifo1_wr,
        din => fifo1_in,
        fifo_rd => fifo1_rd,
        dout => fifo1_out       
        );

DUT_FIFO2: entity work.ram_fifo port map (
        clk => clk,
        reset => reset,
        fifo_wr => fifo2_wr,
        din => fifo2_in,
        fifo_rd => fifo2_rd,
        dout => fifo2_out       
        );


-- POCETAK PROCESA

TRANZICIJA: process (clk) is
begin
    if rising_edge(clk) then
        if reset = '1' then
            trenutno <= init;
        else
            trenutno <= sledece;
        end if;
    end if;
end process;

PRELAZI: process (flag_hor, trenutno, br_ver, br_hor, dugme) is
begin
    case trenutno is
        when init =>
            if dugme = '1' then
                sledece <= punjenje;
            else
                sledece <= trenutno;
            end if;
        when punjenje =>
            if flag_punj = '1' then
                sledece <= racun;
            else
                sledece <= trenutno;
            end if;
        when racun =>
            if flag_hor = '1' then
                sledece <= sift;
            else
                sledece <= trenutno;
            end if;
        when sift =>
            if flag_ver = '1' then
                sledece <= init;
            elsif flag_hor = '0' then
                sledece <= racun;
            else
                sledece <= trenutno;
            end if;
    end case;
end process;

ZASTAVICE: process(br_ver, br_hor) is
begin
    if (br_hor = 2) or (br_hor = 1) then
        flag_hor <= '1';
    else
        flag_hor <= '0';
    end if;

    if (br_hor = sirina) and (br_ver = sirina) then
        flag_ver <= '1';
    else
        flag_ver <= '0';
    end if;

    if (br_hor = 3) and (br_ver = 2) then
        flag_punj <= '1';
    else
        flag_punj <= '0';
    end if;

end process;

FIFO_ENABLE: process(trenutno, br_ver, br_hor) is
begin
    case trenutno is
        when init =>
            fifo1_wr <= '0';
            fifo2_wr <= '0';
            fifo1_rd <= '0';
            fifo2_rd <= '0';
        when punjenje =>
            if (br_hor > 0) or (br_ver > 0) then
                fifo1_wr <= '1';
            else
                fifo1_wr <= '0';
            end if;

            if ((br_hor >= 0) and (br_ver > 0)) or (br_ver > 1) then
                fifo2_wr <= '1';
            else
                fifo2_wr <= '0';
            end if;
            
            
            if (br_hor > 7) or (br_ver > 0) then
            --if br_ver > 0 then
                fifo1_rd <= '1';
            else
                fifo1_rd <= '0';
            end if;
            
            if ((br_hor > 6) and (br_ver > 0)) or (br_ver > 1) then
            --if br_ver > 1 then
                fifo2_rd <= '1';
            else
                fifo2_rd <= '0';
            end if;

        when others =>
            fifo1_rd <= '1';
            fifo2_rd <= '1';
            fifo1_wr <= '1';
            fifo2_wr <= '1';
    end case;
end process;

PROTOK: process(clk) is
begin
    if rising_edge(clk) then
        --    if fifo2_rd = '1' then
        --        r8 <= r7;
        --        r7 <= r6;
        --        r6 <= fifo2_out;
        --    end if;
        --    if fifo2_wr = '1' then
        --        fifo2_in <= r5;
        --    end if;
        --    if fifo1_rd = '1' then
        --        r5 <= r4;
        --       r4 <= r3;
        --        r3 <= fifo1_out;
        --    end if;
        --    if fifo1_wr = '1' then 
        --        fifo1_in <= r2;
        --    end if;
        --    r2 <= r1;
        --    r1 <= r0;
        --    r0 <= in_byte;
        if trenutno /= init then
            r8 <= r7;
            r7 <= r6;
            if (br_hor = 0) and (br_ver = 2) then
                r6 <= rf2;
            else
                r6 <= fifo2_out;
            end if;
            fifo2_in <= r5;
            r5 <= r4;
            r4 <= r3;
            if (br_hor = 0) and (br_ver = 1) then
                r3 <= rf1;
            else
                r3 <= fifo1_out;
            end if;
            fifo1_in <= r2;
            r2 <= r1;
            r1 <= r0;
            r0 <= in_byte;
            
            if (br_hor = 3) and (br_ver = 0) then
                rf1 <= r2;
            end if;
            
            if (br_hor = 3) and (br_ver = 1) then
                rf2 <= r5;
            end if;         
      
        end if;    
    end if;
end process;

BROJAC: process(clk) is
begin
    if rising_edge(clk) then
        if trenutno = init then
            br_ver <= 0;
            br_hor <= 0;
        else
            if br_hor = sirina - 1 then
                br_hor <= 0;
                br_ver <= br_ver + 1;
            else
                br_hor <= br_hor + 1;
            end if;
        end if;
    end if;
end process;

ISPIS: process(trenutno, r0, r1, r2, r3, r4, r5, r6, r7, r8) is
begin
    if trenutno = racun then
        medijana <= med;
    else
        medijana <= "00000000";
    end if;
end process;


end behavioral;
