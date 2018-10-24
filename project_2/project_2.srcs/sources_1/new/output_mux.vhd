----------------------------------------------------------------------------------
-- Company: University of Canterbury    
-- Engineers: Kate Chamberlin and Jesse Baxter
-- 
-- Due Date: 25/05/2018
-- Module Name: output_mux
-- Project Name: Timer FPGA
-- Target Devices: FPGA
-- Description: Module to mux the output signals according to the overarching
--              FSM state from FSM_3
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity output_mux is
    Port ( clk_in: in STD_LOGIC;
           wave_in_dc : in STD_LOGIC;
           wave_in_pwm : in STD_LOGIC;
           wave_out : out STD_LOGIC;
           state : in STD_LOGIC;
           led_dc_r, led_dc_b, led_dc_g : in STD_LOGIC;
           led_pwm_b, led_pwm_g : in STD_LOGIC;
           led_dc_r_o, led_dc_b_o, led_dc_g_o : out STD_LOGIC;
           led_pwm_b_o, led_pwm_g_o : out STD_LOGIC );
end output_mux;

architecture Behavioral of output_mux is

begin
    process (clk_in, state)
    begin
        if rising_edge(clk_in) then
            if state = '0' then
                wave_out <= wave_in_dc;
                led_dc_r_o <= led_dc_r;
                led_dc_b_o <= led_dc_b;
                led_dc_g_o <= led_dc_g;
                led_pwm_b_o <= '0';
                led_pwm_g_o <= '0';
            else 
                wave_out <= wave_in_pwm;
                led_dc_r_o <= '0';
                led_dc_b_o <= '0';
                led_dc_g_o <= '0';
                led_pwm_b_o <= led_pwm_b;
                led_pwm_g_o <= led_pwm_g;
            end if;
        end if;
    end process;


end Behavioral;
