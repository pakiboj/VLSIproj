Library IEEE;  
USE IEEE.std_logic_1164.all;    
USE IEEE.numeric_std.all;  
Use STD.TEXTIO.all;  

entity tb_fir_filter is  
end tb_fir_filter; 

architecture behavioral of tb_fir_filter is  
    component FIR_filter is  
        generic (  
            INPUT_WIDTH     : integer   :=8;   
            OUTPUT_WIDTH    : integer   :=16; 
            COEF_WIDTH      : integer   :=8;  
            NUM_TAPS        : integer :=11); 
        port(  
            clk     : in    std_logic;              
            reset   : in    std_logic;               
            Din     : in    std_logic_vector(INPUT_WIDTH-1 downto 0); 
            Dout    : out   std_logic_vector(OUTPUT_WIDTH-1 downto 0));
    end component;  
    signal Din  : std_logic_vector(7 downto 0);  
    signal clk  : std_logic:='0';  
    signal reset : std_logic:='1';       
    signal output_ready : std_logic:='0';                                
    signal Dout : std_logic_vector(15 downto 0);  
    signal input: std_logic_vector(7 downto 0);  
    file my_input : TEXT open READ_MODE is "input_signal.txt";  
    file my_output : TEXT open WRITE_MODE is "output_signal.txt";  
begin  
    FIR_inst : FIR_filter
	   generic map (  
            INPUT_WIDTH => 8,  
            OUTPUT_WIDTH => 16,  
            COEF_WIDTH  => 8,  
            NUM_TAPS    => 17)  
	   port map (  
            Din => Din,  
            clk => clk,  
            reset => reset,  
            Dout => Dout);  
	     
    clk <= not clk after 10 ns;   
    reset <= '1', '1' after 100 ns, '0' after 503 ns; 
    
    process(clk)  
        variable my_input_line : LINE;  
        variable input1: integer;  
    begin  
        if reset ='1' then  
             Din <= (others=> '0');  
             input <= (others=> '0');  
             output_ready <= '0';  
        elsif rising_edge(clk) then                      
             readline(my_input, my_input_line);  
             read(my_input_line,input1);  
             Din <= std_logic_vector(to_signed(input1, 8)); 
             output_ready <= '1';  
        end if;  
    end process;                      
    
    process(clk)  
        variable my_output_line : LINE;  
        variable input1: integer;  
    begin  
        if falling_edge(clk) then  
             if output_ready ='1' then  
                  write(my_output_line, to_integer(signed(Dout)));  
                  writeline(my_output,my_output_line);  
             end if;  
        end if;  
    end process;   
							
end behavioral; 

















