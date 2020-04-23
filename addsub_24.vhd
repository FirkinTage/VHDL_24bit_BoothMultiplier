----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Tage Firkin
-- 
-- Create Date: 03/02/2020 05:40:59 PM
-- Design Name: 
-- Module Name: addsub_24 - addsub_behave
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

entity cla_addsub24 is
    Port ( A : in STD_LOGIC_VECTOR (23 downto 0);
           B : in STD_LOGIC_VECTOR (23 downto 0);
           M : in STD_LOGIC;
           S : out STD_LOGIC_VECTOR (23 downto 0);
           Overflow : out STD_LOGIC);
end cla_addsub24;

architecture addsub_behave of cla_addsub24 is
    component addsub_12
        Port(
            a: in STD_LOGIC_VECTOR (11 downto 0);
            b: in STD_LOGIC_VECTOR (11 downto 0);
            cin: in STD_LOGIC;
            m: in STD_LOGIC;
            sum: out STD_LOGIC_VECTOR (11 downto 0);
            cout: out STD_LOGIC;
            ovrflw: out STD_LOGIC);
    end component;
    signal C: STD_LOGIC;
begin   
    --Link two 2-level 12bit CLAs together
    addsub_12_1: addsub_12 port map(a=>A(11 downto 0), b=>B(11 downto 0), cin=>M, m=>M, sum=>S(11 downto 0), cout=>C, ovrflw=>OPEN);
    addsub_12_2: addsub_12 port map(a=>A(23 downto 12), b=>B(23 downto 12), cin=>C, m=>M, sum=>S(23 downto 12), cout=>OPEN, ovrflw=>Overflow);
end addsub_behave;
