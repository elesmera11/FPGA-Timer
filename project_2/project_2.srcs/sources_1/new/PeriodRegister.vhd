----------------------------------------------------------------------------------
-- Company: University of Canterbury    
-- Engineers: Kate Chamberlin and Jesse Baxter
-- 
-- Due Date: 25/05/2018
-- Module Name: PeriodRegister
-- Project Name: Timer FPGA
-- Target Devices: FPGA
-- Description: 16 bit register for storing the programmeable period
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity PeriodRegister is
    Port ( switches     : in STD_LOGIC_VECTOR (15 downto 0);
           button       : in STD_LOGIC;
           clk_in       : in STD_LOGIC;
           reg_out      : out STD_LOGIC_VECTOR (15 downto 0));
end PeriodRegister;


architecture Behavioral of PeriodRegister is
begin

    -- process to pass switch input through the register
    reg: process(switches, button)
    begin
        if rising_edge(clk_in) and button = '1' then
            reg_out <= switches;
        end if;
    end process reg;
        
end Behavioral;
