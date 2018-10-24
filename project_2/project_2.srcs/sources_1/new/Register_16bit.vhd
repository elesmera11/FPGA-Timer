----------------------------------------------------------------------------------
-- Company: University of Canterbury    
-- Engineers: Kate Chamberlin and Jesse Baxter
-- 
-- Due Date: 25/05/2018
-- Module Name: Register_16bit
-- Project Name: Timer FPGA
-- Target Devices: FPGA
-- Description: Standard 16 bit register module
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Register_16bit is
    Port ( switches     : in STD_LOGIC_VECTOR (15 downto 0);
           buttons      : in STD_LOGIC_VECTOR (3 downto 0);
           clk_in       : in STD_LOGIC;
           reg_out      : out STD_LOGIC_VECTOR (15 downto 0));
end Register_16bit;


architecture Behavioral of register_16bit is
begin
    
    -- process to pass switch input through the register
    process(switches, buttons, clk_in)
    begin
        if rising_edge(clk_in) and buttons(0) = '1' then
            reg_out <= switches;
        end if;
    end process reg;
        
end Behavioral;
