----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Tage Firkin
-- 
-- Create Date: 03/03/2020 11:24:45 AM
-- Design Name: 
-- Module Name: cla_gen - Behavioral
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

entity cla_gen is
    Port ( p_in : in STD_LOGIC_VECTOR (2 downto 0);
           g_in : in STD_LOGIC_VECTOR (2 downto 0);
           c_in : in STD_LOGIC;
           c_out : out STD_LOGIC_VECTOR (3 downto 0));
end cla_gen;

architecture Behavioral of cla_gen is

begin    
--Calculate Carry in's/out's for each bit position
    c_out(0)<=c_in;
    c_out(1)<=g_in(0) OR (p_in(0) AND c_in);      
    c_out(2)<=g_in(1) OR (p_in(1) AND g_in(0)) OR (p_in(1) AND p_in(0) AND c_in);
    c_out(3)<=g_in(2) OR (p_in(2) AND g_in(1)) OR (p_in(2) AND p_in(1) AND g_in(0)) OR (p_in(2) AND p_in(1) AND p_in(0) AND c_in);
end Behavioral;
