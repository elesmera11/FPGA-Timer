----------------------------------------------------------------------------------
-- Company: University of Canterbury    
-- Engineers: Kate Chamberlin and Jesse Baxter
-- 
-- Due Date: 25/05/2018
-- Module Name: FSM_1
-- Project Name: Timer FPGA
-- Target Devices: FPGA
-- Description: Module to delegate signals for the PWM generation
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_1 is
    Port ( clk_in : in STD_LOGIC;
           sw_in : in STD_LOGIC_VECTOR (15 downto 0);
           buttons_in : in STD_LOGIC_VECTOR (3 downto 0); --centre, left, right, down
           sw_period : out STD_LOGIC_VECTOR (15 downto 0);
           sw_duty : out STD_LOGIC_VECTOR (15 downto 0);
           butt_c_period : out STD_LOGIC;
           butt_c_duty : out STD_LOGIC;
           led_blue, led_green : out STD_LOGIC);
end FSM_1;

architecture Behavioral of FSM_1 is
    signal state : STD_LOGIC := '0';
begin

    process (clk_in, buttons_in) 
    begin
        if rising_edge(clk_in) and (buttons_in(1) = '1' or buttons_in(2) = '1') then
            state <= not state;
        end if;
    end process;
    
    process (state, sw_in)
    begin
        if state = '0' then --period selection
            led_blue <= '1';
            led_green <= '0';
            sw_period <= sw_in;
            butt_c_period <= buttons_in(0);
            butt_c_duty <= '0';
        else                --duty cycle selection
            led_blue <= '0';
            led_green <= '1';
            sw_duty <= sw_in;
            butt_c_duty <= buttons_in(0);
            butt_c_period <= '0';  
        end if;
    end process;

end Behavioral;
