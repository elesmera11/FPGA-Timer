----------------------------------------------------------------------------------
-- Company: University of Canterbury    
-- Engineers: Kate Chamberlin and Jesse Baxter
-- 
-- Due Date: 25/05/2018
-- Module Name: DutyRegister
-- Project Name: Timer FPGA
-- Target Devices: FPGA
-- Description: 8 bit register for storing the Duty for PWM gen
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity DutyRegister is
    Port ( switches     : in STD_LOGIC_VECTOR (15 downto 0);
           button       : in STD_LOGIC;
           clk_in       : in STD_LOGIC;
           reg_out      : out STD_LOGIC_VECTOR (7 downto 0));
end DutyRegister;


architecture Behavioral of DutyRegister is

begin

    -- process to pass switch input through the register
    reg: process(switches, button)
    begin
        if rising_edge(clk_in) and button = '1' then
            reg_out <= switches(7 downto 0);
        end if;
    end process reg;
        
end Behavioral;
