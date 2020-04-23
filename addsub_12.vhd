----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Tage Firkin
-- 
-- Create Date: 03/02/2020 05:42:39 PM
-- Design Name: 
-- Module Name: addsub_12 - addsub_12_behave
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

entity addsub_12 is
    Port ( A : in STD_LOGIC_VECTOR (11 downto 0);
           B : in STD_LOGIC_VECTOR (11 downto 0);
           Cin : in STD_LOGIC;
           M: in STD_LOGIC;
           Sum : out STD_LOGIC_VECTOR (11 downto 0);
           Cout : out STD_LOGIC;
           ovrflw: out STD_LOGIC);
end addsub_12;

architecture addsub_12_behave of addsub_12 is
--4bit cla generator
    component cla_gen
        Port(
            p_in : in STD_LOGIC_VECTOR (2 downto 0);
            g_in : in STD_LOGIC_VECTOR (2 downto 0);
            c_in : in STD_LOGIC;
            c_out : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    signal B_in:STD_LOGIC_VECTOR (11 downto 0);
    signal p: STD_LOGIC_VECTOR (11 downto 0);
    signal g: STD_LOGIC_VECTOR (11 downto 0);
    signal PG: STD_LOGIC_VECTOR (2 downto 0);
    signal GG: STD_LOGIC_VECTOR (2 downto 0);
    signal C: STD_LOGIC_VECTOR (2 downto 0);
    signal finalC: STD_LOGIC_VECTOR (11 downto 0);
begin
    B_in(0)<=B(0) XOR M;
    B_in(1)<=B(1) XOR M;
    B_in(2)<=B(2) XOR M;
    B_in(3)<=B(3) XOR M;
    B_in(4)<=B(4) XOR M;
    B_in(5)<=B(5) XOR M;
    B_in(6)<=B(6) XOR M;
    B_in(7)<=B(7) XOR M;
    B_in(8)<=B(8) XOR M;
    B_in(9)<=B(9) XOR M;
    B_in(10)<=B(10) XOR M;
    B_in(11)<=B(11) XOR M;
--Generate pi and gi
    p<=A XOR B_in;
    g<=A AND B_in; 

--Generate PGs and GGs
    PG(0)<=p(3) AND p(2) AND p(1) AND p(0);
    PG(1)<=p(7) AND p(6) AND p(5) AND p(4);
    PG(2)<=p(11) AND p(10) AND p(9) AND p(8);
    
    GG(0)<=g(3) OR (p(3) AND g(2)) OR (p(3) AND p(2) AND g(1)) OR (p(3) AND p(2) AND p(1) AND g(0));
    GG(1)<=g(7) OR (p(7) AND g(6)) OR (p(7) AND p(6) AND g(5)) OR (p(7) AND p(6) AND p(5) AND g(4));
    GG(2)<=g(11) OR (p(11) AND g(10)) OR (p(11) AND p(10) AND g(9)) OR (p(11) AND p(10) AND p(9) AND g(8));
    
--Generate Big Cs
    C(0)<=Cin;
    C(1)<=GG(0) OR (PG(0) AND C(0));
    C(2)<=GG(1) OR (PG(1) AND GG(0)) OR (PG(1) AND PG(0) AND C(0));

--Calculate 4bit Carry signals in parallel
    CLA1: cla_gen port map(p_in=>p(2 downto 0), g_in=>g(2 downto 0), c_in=>Cin, c_out=>finalC(3 downto 0));
    CLA2: cla_gen port map(p_in=>p(6 downto 4), g_in=>g(6 downto 4), c_in=>C(1), c_out=>finalC(7 downto 4));
    CLA3: cla_gen port map(p_in=>p(10 downto 8), g_in=>g(10 downto 8), c_in=>C(2), c_out=>finalC(11 downto 8));
    
--Return Sum, Cout, and Overflow
    Sum<=P XOR finalC(11 downto 0);
    Cout<=GG(2) OR (PG(2) AND GG(1)) OR (PG(2) AND PG(1) AND GG(0)) OR (PG(2) AND PG(1) AND PG(0) AND C(0));
    ovrflw<= finalC(11) XOR (GG(2) OR (PG(2) AND GG(1)) OR (PG(2) AND PG(1) AND GG(0)) OR (PG(2) AND PG(1) AND PG(0) AND C(0)));
end addsub_12_behave;
