----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2020 01:45:33 PM
-- Design Name: 
-- Module Name: shift_register - Behavioral
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

entity shift_register is
    Port ( clock : in STD_LOGIC;
           clear : in STD_LOGIC;
           control : in STD_LOGIC_VECTOR (1 downto 0);
           serial_in : in STD_LOGIC;
           parallel_in : in STD_LOGIC_VECTOR (23 downto 0);
           serial_out : out STD_LOGIC;
           parallel_out : out STD_LOGIC_VECTOR (23 downto 0));
end shift_register;

architecture Behavioral of shift_register is
    signal p_reg: std_logic_vector(23 downto 0);
    signal p_next: std_logic_vector(23 downto 0);
    signal s_reg: std_logic;
    signal s_next: std_logic;
begin

process(clock)
    begin
        if(rising_edge(clock)) then
            if(clear='1') then
                p_reg<=(others=>'0');
                s_reg<='0';
            else
                p_reg<=p_next;
                s_reg<=s_next;
            end if;
        end if;
        case control is
            when "00" =>        --STORE
                p_next<=p_reg;
                s_next<=s_reg;
            when "01" =>        --SHIFT RIGHT
                p_next (23)<=serial_in;
                p_next (22 downto 0)<=p_reg(23 downto 1);
                s_next<= p_reg(0);
            when "10" =>        --SHIFT LEFT
                p_next(23 downto 1)<=p_reg(22 downto 0);
                p_next(0)<=serial_in;
                s_next<=p_reg(23);
            when others =>      --LOAD PARALLEL IN
                p_next<=parallel_in;
                s_next<=s_reg;
        end case;
    end process;

parallel_out<=p_reg;
serial_out<=s_reg;

end Behavioral;
