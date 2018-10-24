----------------------------------------------------------------------------------
-- Company: University of Canterbury    
-- Engineers: Kate Chamberlin and Jesse Baxter
-- 
-- Due Date: 25/05/2018
-- Module Name: PWM_Gen
-- Project Name: Timer FPGA
-- Target Devices: FPGA
-- Description: Module to create the PWM output
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PWM_Gen is
    Port (clk_in                 : in STD_LOGIC;
          reset_period         : in STD_LOGIC_VECTOR (15 downto 0); -- period + duty
          reset_duty          : in STD_LOGIC_VECTOR (7 downto 0); 
          led_out                : out STD_LOGIC);
end PWM_Gen;

architecture Behavioral of PWM_Gen is
        signal compare_val : integer := 0;
        signal period       : std_logic_vector(15 downto 0) := X"0000";
        signal clk_ctr        : std_logic_vector (15 downto 0) := X"0000";
        
        
begin
    
    clock: process (clk_in, reset_period, reset_duty) 
    variable out_high       : std_logic := '0';    
    
    begin
        if rising_edge(clk_in) then
            compare_val <= to_integer(unsigned(reset_duty) * unsigned(reset_period) * (1 / 255));
            if clk_ctr > X"0000" then
                if to_integer(unsigned(clk_ctr)) <= compare_val then
                    led_out <= '1';
                else 
                    led_out <= '0';
                end if;
                clk_ctr <= clk_ctr - X"0001";
            else
                led_out <= '0';
                clk_ctr <= reset_period;
            end if;
        end if;
    end process clock;

end Behavioral;
