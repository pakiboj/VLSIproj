library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity filter is
  generic (
  depth: integer := 8
  );
  port ( 
  clk: in std_logic;
  reset: in std_logic;
  in_byte: in std_logic_vector (depth - 1 downto 0);
  medijana: out std_logic_vector (depth - 1 downto 0)
  );
end filter;

architecture Behavioral of filter is

type stanja is (zeros, init, racun, sift);
signal r0, r1, r2, r3, r4, r5, r6, r7, r8, rf1, rf2, rf3, rf4: std_logic_vector (7 downto 0);
signal med: std_logic_vector (depth - 1 downto 0);
signal trenutno, sledece: stanja;
signal broj_hor:  integer;
signal broj_ver:  integer;
signal flag_hor, flag_ver, flag_zeros:  std_logic := '0';
signal fifo1_wr, fifo1_rd, fifo2_wr, fifo2_rd: std_logic := '0';
signal sift_cnt: integer;
signal cnt_rst: std_logic;


-- DODAVANJE KOMPONENTI

------------------------------------------------------------------------
component ram_fifo is
    generic (
        G_DATAWIDTH : natural := 8;
        G_FIFODEPTH : natural := 8
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

------------------------------------------------------------------------

component brojac is
  generic (
  duzina: integer := 8
  );
  port ( 
  clk: in std_logic;
  reset: in std_logic;
  broj_hor: out integer;
  broj_ver: out integer
  );
end component;

-------------------------------------------------------------------------

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
---------------------------------------------------------------------------
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
        din => rf1,
        fifo_rd => fifo1_rd,
        dout => rf2       
        );

DUT_FIFO2: entity work.ram_fifo port map (
        clk => clk,
        reset => reset,
        fifo_wr => fifo2_wr,
        din => rf3,
        fifo_rd => fifo2_rd,
        dout => rf4       
        );

DUT_BROJAC: entity work.brojac port map (
        clk => clk,
        reset => cnt_rst,
        broj_hor => broj_hor,
        broj_ver => broj_ver
        );


--POCETAK PROCESA


TRANZICIJA: process (clk) is
begin

    if rising_edge(clk) then
        if reset = '1' then
            trenutno <= zeros;
        else
            trenutno <= sledece;
        end if;
    end if;
end process;

PRELAZI: process (flag_hor, flag_ver, trenutno) is
begin
    case trenutno is
        when zeros =>
            if flag_zeros = '1' then
                sledece <= init;
            else
                sledece <= trenutno;
            end if;
        when init =>
            if (broj_ver = 2) and (broj_hor = 2) then
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
            if flag_hor = '0' then
                sledece <= racun;
            else
                sledece <= trenutno;
            end if;
        end case;
end process;

TOK_PODATAKA: process(clk) is
begin
    if rising_edge(clk) then
        r8 <= r7;
        r7 <= r6;
        r6 <= rf4;
        rf3 <= r5;
        r5 <= r4;
        r4 <= r3;
        r3 <= rf2;
        rf1 <= r2;
        r2 <= r1;
        r1 <= r0;
        if trenutno = zeros then 
            r0 <= "00000000";
        else
            r0 <= in_byte;
        end if;        
    end if;
end process;

ISPIS_MEDIJANE: process (trenutno) is
begin
    if trenutno = racun then
        medijana <= med;
    else
        medijana <= "00000000";
    end if;
end process;

FIFO_ENABLE: process (trenutno) is
begin
    if (trenutno = zeros) or (trenutno = init) then
        if (broj_hor > 2) or (broj_ver > 0) then
            fifo1_wr <= '1';
        else
            fifo1_wr <= '0';
        end if;
        
        if ((broj_hor > 2) and (broj_ver > 0)) or (broj_ver > 1) then
            fifo1_rd <= '1';
        else
            fifo1_rd <= '0';
        end if;
        
        if ((broj_hor > 6) and (broj_ver > 0)) or (broj_ver > 1) then
            fifo2_wr <= '1';
        else
            fifo2_wr <= '0';
        end if;
        
        if ((broj_hor > 6) and (broj_ver > 1)) or (broj_ver > 2) then
            fifo1_rd <= '1';
        else
            fifo1_rd <= '0';
        end if;
    else
        fifo1_wr <= '1';
        fifo1_rd <= '1';
        fifo2_wr <= '1';
        fifo2_rd <= '1';
    end if;
end process;

ZASTAVICE: process (trenutno) is
begin
    case trenutno is
    when zeros =>
        if (broj_hor = 2) and (broj_ver = 2) then
            flag_zeros <= '1';
        else
            flag_zeros <= '0';
        end if;
        
    when init =>
        flag_zeros <= '0';    
        flag_hor <= '0';
        flag_ver <= '0';
    
    when others =>
        if (broj_hor = 0) or (broj_hor = depth - 1) then
            flag_hor <= '1';
        else
            flag_hor <= '0';
        end if;
        
        if (broj_hor = depth - 1) and (broj_ver = depth - 1) then
            flag_ver <= '1';
        else
            flag_ver <= '0';
        end if;
    end case;
end process;

RESETOVANJE_BROJACA: process (clk) is
begin
    if rising_edge(clk) then
        cnt_rst <= (reset or flag_zeros);
    end if;
end process;

        
end Behavioral;
