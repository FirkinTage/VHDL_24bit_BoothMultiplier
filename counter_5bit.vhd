----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2020 02:13:37 PM
-- Design Name: 
-- Module Name: counter_5bit - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter_5bit is
    Port ( clock : in STD_LOGIC;
           enable: in STD_LOGIC;
           reset : in STD_LOGIC;
           count_flag : out STD_LOGIC);
end counter_5bit;

architecture Behavioral of counter_5bit is

    component full_adder
        Port ( 
            A : in STD_LOGIC;
            B : in STD_LOGIC;
            Cin : in STD_LOGIC;
            Cout : out STD_LOGIC;
            S : out STD_LOGIC);
    end component;
    
    signal count: std_logic_vector(4 downto 0) := "00000";
begin
clk: process(clock, reset)
begin
    if(rising_edge(clock)) then
        if(reset = '1') then
            count<="00000";
            count_flag<='0';
        elsif(count = "10111") then
            count_flag<='1';
            count<="00000";
        elsif(enable = '1') then
            count<=count + 1;
        end if;
    end if;
end process;

end Behavioral;
