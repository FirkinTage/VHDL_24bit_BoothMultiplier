----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Tage Firkin
-- 
-- Create Date: 03/15/2020 03:18:56 PM
-- Design Name: 
-- Module Name: tb_booth - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_booth is
--  Port ( );
end tb_booth;

architecture Behavioral of tb_booth is

    --Booth Multiplier Component
    component booth_top
        Port(
            A : in STD_LOGIC_VECTOR (23 downto 0);
            B : in STD_LOGIC_VECTOR (23 downto 0);
            Start : in STD_LOGIC;
            Reset : in STD_LOGIC;
            Clock : in STD_LOGIC;
            Product : out STD_LOGIC_VECTOR (47 downto 0);
            Done : out STD_LOGIC);
    end component;
    
--LFSR component
    component LFSR
        Port(
            clock :    in STD_LOGIC;                       --driven clock
            reload:    in STD_LOGIC;                       --load seed from input D
            D :    in STD_LOGIC_VECTOR (15 downto 0);      --input for loading seed
            en :    in STD_LOGIC;                          --enable random generation
            Q :    out STD_LOGIC_VECTOR (15 downto 0)      --ouptput for random number
       );
    end component;
    
--Clock
    signal Clk: STD_LOGIC:='0';
    constant clk_period: time:=2ns;
    
--Random number (LFSR) signals
    signal Reload,En: STD_LOGIC;
    signal rand_a: STD_LOGIC_VECTOR (15 downto 0):=(others=>'0');
    signal rand_b: STD_LOGIC_VECTOR (15 downto 0):=(others=>'0');
    signal rand_c: STD_LOGIC_VECTOR (15 downto 0):=(others=>'0');
    signal seed_a: STD_LOGIC_VECTOR (15 downto 0):=(others=>'0');
    signal seed_b: STD_LOGIC_VECTOR (15 downto 0):=(others=>'0');
    signal seed_c: STD_LOGIC_VECTOR (15 downto 0):=(others=>'0');
        
--Inputs
    signal A_in,B_in, A, B: STD_LOGIC_VECTOR (23 downto 0);
    signal Reset: STD_LOGIC;
    signal Start: STD_LOGIC;

--Outputs
    signal Product: STD_LOGIC_VECTOR (47 downto 0);
    signal Done: STD_LOGIC;
begin
--Clock process
    clk_process: process
        begin
            Clk<='0';
            wait for clk_period/2;
            Clk<='1';
            wait for clk_period/2;
        end process;

--Reset Generation
    reset_gen: process
    begin
        reset<='1';
        wait for clk_period;
        reset<='0';
        wait;
    end process;
    
--Start Signal Generation
    start_gen: process
    begin
        start<='0';
        wait for clk_period;
        start<='1';
        wait for clk_period;
        start<='0';
        wait for clk_period*9; --Change start in the middle of computation
    end process;
    
--Setup LFSR
    LFSR_Setup: process
        begin
        --Setup
            Reload<='1';
            En<='0';
            seed_a<=x"1111";
            seed_b<=x"9732";
            seed_c<=x"B3B6";
            wait for clk_period;
            

        --Working Mode
            Reload<='0';
            En<='1';
            wait;   --Infinite wait
        end process;

--Generate Random Numbers
    num_gen: process
    begin
        wait for clk_period;
        A_in(22 downto 8)<=rand_a(14 downto 0);
        A_in(23)<='0';
        A_in(7 downto 0)<=rand_b(15 downto 8);
        B_in(22 downto 16)<=rand_b(6 downto 0);
        B_in(23)<='0';
        B_in(15 downto 0)<=rand_c;
    end process;        
--Objects for Generating random numbers    
    LFSR_a: LFSR port map(clock=>Clk, reload=>Reload, D=>seed_a, en=>En, Q=>rand_a);
    LFSR_b: LFSR port map(clock=>Clk, reload=>Reload, D=>seed_b, en=>En, Q=>rand_b);
    LFSR_c: LFSR port map(clock=>Clk, reload=>Reload, D=>seed_c, en=>En, Q=>rand_c); 
            
--Design Under Test
    DUT: booth_top port map(Clock=>Clk, Reset=>Reset, Start=>Start, A=>A_in, B=>B_in, Product=>Product, Done=>Done);
           
--Stimulus process
stim_proc: process
    variable s:line;
    begin
        --Save the "initial" input at start since the actuall input can change without messing up computation
        if(Start = '1' AND Done = '1') then
            A <= A_in;
            B <= B_in;
        end if;
        
        --Test for Correctness only when Done is high.
        if (Done = '1' AND Clk = '0') then
            if(Product /= A*B) then
                write(s, time'image(now));
                write(s, string'(" Mult Error: "));
                hwrite(s, product);
                write(s, string'(" /= "));
                write(s, integer'image(to_integer(signed(A))));
                write(s, string'(" * "));
                write(s, integer'image(to_integer(signed(B))));
                writeline(output, s);
            end if;
        end if;
        wait for clk_period/2;
    end process;
end Behavioral;
