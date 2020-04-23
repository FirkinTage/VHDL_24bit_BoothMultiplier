----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Tage Firkin
-- 
-- Create Date: 03/15/2020 11:49:12 AM
-- Design Name: 
-- Module Name: booth_control - Behavioral
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

entity booth_control is
    Port ( clock : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           count_up : in STD_LOGIC;
           init : out STD_LOGIC;
           loadA : out STD_LOGIC;
           shift : out STD_LOGIC;
           done : out STD_LOGIC);
end booth_control;

architecture Behavioral of booth_control is

signal state,next_state: std_logic_vector(1 downto 0):="00";

begin

sync: process(clock)
    begin
        if(rising_edge(clock)) then
            if(reset='1') then
                state<="00";
            else
                state<=next_state;
            end if;
        end if;
    end process;

state_choice: process(start,count_up,state)
    begin
        case state is
            when "01" =>        --INIT
                next_state<="10";
            when "10" =>        --LOADA
                next_state<="11";
            when "11" =>        --SHIFT
                if (count_up='1') then
                    next_state<="00";
                else
                    next_state<="10";
                end if;
            when others=>       --IDLE
                if (start='1') then
                    next_state<="01";
                end if;
        end case;
    end process;

output: process (state)
    begin
        case state is
            when "01" =>        --INIT
                done<='0';
                init<='1';
                loadA<='0';
                shift<='0';
            when "10" =>        --LOADA
                done<='0';
                init<='0';
                loadA<='1';
                shift<='0';
            when "11" =>        --SHIFT
                done<='0';
                init<='0';
                loadA<='0';
                shift<='1';
            when others=>       --IDLE
                done<='1';
                init<='0';
                loadA<='0';
                shift<='0';
        end case;
    end process;
end Behavioral;
