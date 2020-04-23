----------------------------------------------------------------------------------
-- Create Date: 02/20/2018 10:57:14 AM
-- Design Name: Random number generator.
-- Module Name: LFSR - LFSR
-- Project Name: Project 1
-- Target Devices: Zybo
-- Tool Versions: 2017.4
-- Description: Generate 16 bit pseudo random number. 

---------------- input reload=1,en=0; load seed from input D.
---------------- input reload=0,en=1; generate a new random number every clock cycle..
---------------- Q; ouptput for random number
----------------------------------------------------------------------------------

------------------------------------library---------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
------------------------------------end-------------------------------------------

------------------------------------entity----------------------------------------
entity LFSR is
--  Port ( );
   Port ( 
        clock :    in STD_LOGIC;                       --driven clock
        reload:    in STD_LOGIC;                       --load seed from input D
            D :    in STD_LOGIC_VECTOR (15 downto 0); --input for loading seed
           en :    in STD_LOGIC;                       --enable random generation
            Q :    out STD_LOGIC_VECTOR (15 downto 0) --ouptput for random number
       );
end LFSR;
------------------------------------end-------------------------------------------

---------------------------------architecture-------------------------------------
architecture LFSR of LFSR is

  signal Qt: STD_LOGIC_VECTOR(15 downto 0);    -- random number register
begin

  process (clock)                                -- clock signal sensitive 
   variable tmp : STD_LOGIC := '0';             -- random generated new bit
  begin 
    if rising_edge(clock) then
      if (reload='1') then                        -- input reload=1,en=0; load seed from input D.
        Qt <= D; 
        
     elsif(en = '1') then                         -- input reload=0,en=1; generate a new random number every clock cycle.
      tmp := Qt(12) XOR Qt(2) XOR Qt(1) XOR Qt(0);
      Qt <= tmp & Qt(15 downto 1);
      
    end if;
   end if;
  end process;

  Q <= Qt;                                         -- give random number to output

end LFSR;
------------------------------------end-------------------------------------------

