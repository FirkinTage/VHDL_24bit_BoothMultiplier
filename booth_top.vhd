----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Tage Firkin
-- 
-- Create Date: 04/01/2020 02:05:08 PM
-- Design Name: 
-- Module Name: booth_top - Behavioral
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

entity booth_top is
    Port ( A : in STD_LOGIC_VECTOR (23 downto 0);
           B : in STD_LOGIC_VECTOR (23 downto 0);
           Start : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Clock : in STD_LOGIC;
           Product : out STD_LOGIC_VECTOR (47 downto 0);
           Done : out STD_LOGIC);
end booth_top;

architecture Behavioral of booth_top is
    
    --Booth Controller FSM
    component booth_control
    Port ( 
        clock : in STD_LOGIC;
        reset : in STD_LOGIC;
        start : in STD_LOGIC;
        count_up : in STD_LOGIC;
        init : out STD_LOGIC;
        loadA : out STD_LOGIC;
        shift : out STD_LOGIC;
        done : out STD_LOGIC);
    end component;

    --24 Bit CLA adder/subtractor
    component cla_addsub24
    Port(
        A : in STD_LOGIC_VECTOR (23 downto 0);
        B : in STD_LOGIC_VECTOR (23 downto 0);
        M : in STD_LOGIC;
        S : out STD_LOGIC_VECTOR (23 downto 0);
        Overflow : out STD_LOGIC);
    end component;
    
    --5 Bit Counter
    component counter_5bit
    Port ( 
        clock : in STD_LOGIC;
        enable: in STD_LOGIC;
        reset : in STD_LOGIC;
        count_flag : out STD_LOGIC);
    end component;
    
    --24 Bit Universal Shift Register
    component shift_register
    Port ( 
        clock : in STD_LOGIC;
        clear : in STD_LOGIC;
        control : in STD_LOGIC_VECTOR (1 downto 0);
        serial_in : in STD_LOGIC;
        parallel_in : in STD_LOGIC_VECTOR (23 downto 0);
        serial_out : out STD_LOGIC;
        parallel_out : out STD_LOGIC_VECTOR (23 downto 0));
    end component;
    
    --Signals for op0 D-Flip Flop
    signal op0, op0_in:std_logic;
    
    --signals of the addsub component
    signal addsub_B: std_logic_vector(23 downto 0);
    signal addsub_M: std_logic;
    
    --FSM Signals
    signal count_flag,init,loadA,shift,fsm_done:std_logic;
    
    --Counter Reset signal since it can be reset with init
    signal count_reset: std_logic;
    
    --Multiplicand Register Signals
    signal multiplicand: std_logic_vector(23 downto 0);     --The output of the register
    signal multiplicand_in: std_logic_vector(23 downto 0);     --The input of the register
    signal multiplicand_control: std_logic_vector (1 downto 0); --Control signal for register
    
    --Multiplier Register Signals
    signal multiplier: std_logic_vector(23 downto 0);       --The output of the register
    signal multiplier_in: std_logic_vector(23 downto 0);       --The input of the register
    signal multiplier_control: std_logic_vector (1 downto 0); --Control signal for register
    signal multiplier_serial_in: std_logic;                   --Serial in for the register
    signal multiplier_serial_out: std_logic;                   --Serial out for the register
    
    --Partial Product Register Signals
    signal partial_product: std_logic_vector(23 downto 0);  --The output of the register
    signal partial_product_in: std_logic_vector(23 downto 0);  --The input of the register
    signal partial_product_control: std_logic_vector (1 downto 0); --Control signal for register
    signal partial_product_serial_in: std_logic;                   --Serial in for the register
    signal partial_product_clear: std_logic;                        --Clear signal can be triggered by init
begin
op0_DFF: process(Reset, Clock)
begin
    if(rising_edge(Clock)) then
        if(Reset = '1') then
            op0<='0';
        else
            op0<=op0_in;
        end if;
    end if;
end process;

addsub_B <= multiplicand;
addsub_M <= multiplier(0);
count_reset <= init;

multiplicand_in <= A;
multiplicand_control(0) <= init;
multiplicand_control(1) <= init;

multiplier_in <= B;
multiplier_serial_in <= partial_product(0);
multiplier_control(0) <= init OR shift;
multiplier_control(1) <= init;
op0_in<=multiplier(0) AND (NOT init);

partial_product_serial_in <= partial_product(23);
partial_product_control(0) <= shift OR (loadA AND (multiplier(0) XOR op0));
partial_product_control(1) <= init OR (loadA AND (multiplier(0) XOR op0));
partial_product_clear <= init;
 
Done<=fsm_done;
Product(47 downto 24)<=partial_product;
Product(23 downto 0)<=multiplier;

counter: counter_5bit port map(clock=>Clock, enable=>shift, reset=>count_reset, count_flag=>count_flag);

addsub: cla_addsub24 port map(A=>partial_product, B=>addsub_B, M=>addsub_M, S=>partial_product_in, Overflow=>open);

fsm_control: booth_control port map(
    clock=> Clock,
    reset=>Reset,
    start=>Start,
    count_up=>count_flag,
    init=>init,
    loadA=>loadA,
    shift=>shift,
    done=>fsm_done
);

multiplicand_reg: shift_register port map(
    clock=>Clock,
    clear=>Reset,
    control=>multiplicand_control,
    serial_in=>'0',
    parallel_in=>multiplicand_in,
    serial_out=>open,
    parallel_out=>multiplicand
);

multiplier_reg: shift_register port map(
    clock=>Clock,
    clear=>Reset,
    control=>multiplier_control,
    serial_in=>multiplier_serial_in,
    parallel_in=>multiplier_in,
    serial_out=>multiplier_serial_out,
    parallel_out=>multiplier
);

partial_product_reg: shift_register port map(
    clock=>Clock,
    clear=>partial_product_clear,
    control=>partial_product_control,
    serial_in=>partial_product_serial_in,
    parallel_in=>partial_product_in,
    serial_out=>open,
    parallel_out=>partial_product
);


end Behavioral;
