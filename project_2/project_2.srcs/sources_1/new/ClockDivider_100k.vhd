----------------------------------------------------------------------------------
-- Company: University of Canterbury    
-- Engineers: Kate Chamberlin and Jesse Baxter
-- 
-- Due Date: 25/05/2018
-- Module Name: ClockDivider_100k
-- Project Name: Timer FPGA
-- Target Devices: FPGA
-- Description: This module prescales/divides the 100mHz clock signal
--      by 100k and outputs a 1kHz signal.
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity ClockDivider_100k is
    Port ( clk_in           : in  STD_LOGIC;
           clk_out_SW       : out STD_LOGIC;
           clk_out_100      : out STD_LOGIC;
           clk_out_1000     : out STD_LOGIC;
           divider_reg      : in STD_LOGIC_VECTOR (15 downto 0));    
end ClockDivider_100k;


architecture Behavioral of ClockDivider_100k is
    constant clk_limit_100   : std_logic_vector(15 downto 0) := X"0100";
    constant clk_limit_1000  : std_logic_vector(15 downto 0) := X"1000";
    signal clk_ctr_1      : std_logic_vector(15 downto 0); -- SW
    signal clk_ctr_2      : std_logic_vector(15 downto 0); -- 100
    signal clk_ctr_3      : std_logic_vector(15 downto 0); -- 1000
    signal temp_clk_1     : std_logic;
    signal temp_clk_2     : std_logic;
    signal temp_clk_3     : std_logic;
begin

    -- process to divide the clock signal by a hundred thousand
    divide_SW: process (clk_in)
    begin
        if clk_in = '1' and clk_in'event then
            if clk_ctr_1 = divider_reg then       -- if counter == (1Hz count)/2
                temp_clk_1 <= not temp_clk_1;     -- toggle clock
                clk_ctr_1 <= X"0000";           -- reset counter
            else                              -- else
                clk_ctr_1 <= clk_ctr_1 + X"0001"; -- counter = counter + 1
            end if;
        end if;
    end process divide_SW;
    
    
    divide_100: process (clk_in)
    begin
        if clk_in = '1' and clk_in'event then
            if clk_ctr_2 = clk_limit_100 then       -- if counter == (1Hz count)/2
                temp_clk_2 <= not temp_clk_2;     -- toggle clock
                clk_ctr_2 <= X"0000";           -- reset counter
            else                              -- else
                clk_ctr_2 <= clk_ctr_2 + X"0001"; -- counter = counter + 1
            end if;
        end if;
    end process divide_100;

    
    divide_1000: process (clk_in)
    begin
        if clk_in = '1' and clk_in'event then
            if clk_ctr_3 = clk_limit_1000 then       -- if counter == (1Hz count)/2
                temp_clk_3 <= not temp_clk_3;     -- toggle clock
                clk_ctr_3 <= X"0000";           -- reset counter
            else                              -- else
                clk_ctr_3 <= clk_ctr_3 + X"0001"; -- counter = counter + 1
            end if;
        end if;
    end process divide_1000;
    
    clk_out_SW <= temp_clk_1; -- output the created clock signal
    clk_out_100 <= temp_clk_2;
    clk_out_1000 <= temp_clk_3;

end Behavioral;