----------------------------------------------------------------------------------
-- Company: University of Canterbury    
-- Engineers: Kate Chamberlin and Jesse Baxter
-- 
-- Due Date: 25/05/2018
-- Module Name: FSM_2
-- Project Name: Timer FPGA
-- Target Devices: FPGA
-- Description: FSM to delegate signals for down-counting
-- Additional Comments: Testbench also available for this module.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_2 is
    Port ( clk :     in STD_LOGIC;
           buttons: in std_logic_vector(3 downto 0);
           clk_in_100, clk_in_1000, clk_in_sw : in std_logic;  
           clk_out : out std_logic;       
           led_red, led_blue, led_green :   out STD_LOGIC);
end FSM_2;

architecture Behavioral of FSM_2 is

type state_type is (rate_low, rate_high, rate_custom);
signal previous_s: state_type := rate_low;
signal current_s: state_type := rate_high;
signal next_s: state_type := rate_custom;

begin

process(clk, buttons)
begin
    if rising_edge(clk) then
        case current_s is 
            when rate_low =>
            if buttons(1) = '1' then
                clk_out <= clk_in_sw;
                previous_s <= rate_high;
                current_s <= rate_custom;
                next_s <= rate_low;
                led_red <= '0';
                led_blue <= '0';
                led_green <= '1';
            elsif buttons(2) = '1' then
                clk_out <= clk_in_1000;
                previous_s <= rate_low;
                current_s <= rate_high;
                next_s <= rate_custom;
                led_red <= '0';
                led_blue <= '1';
                led_green <= '0';
            else 
                clk_out <= clk_in_100;
                led_red <= '1';
                led_blue <= '0';
                led_green <= '0';
            end if;
            
            when rate_high =>
            if buttons(1) = '1' then
                clk_out <= clk_in_100;
                previous_s <= rate_custom;
                current_s <= rate_low;
                next_s <= rate_high;
                led_red <= '1';
                led_blue <= '0';
                led_green <= '0';
            elsif buttons(2) = '1' then
                clk_out <= clk_in_sw;
                previous_s <= rate_high;
                current_s <= rate_custom;
                next_s <= rate_low;
                led_red <= '0';
                led_blue <= '0';
                led_green <= '1';
            else 
                clk_out <= clk_in_1000;
                led_red <= '0';
                led_blue <= '1';
                led_green <= '0';
            end if;
            
            -- set 
            when rate_custom =>
            if buttons(1) = '1' then
                clk_out <= clk_in_1000;
                previous_s <= rate_low;
                current_s <= rate_high;
                next_s <= rate_custom;
                led_red <= '0';
                led_blue <= '1';
                led_green <= '0';
            elsif buttons(2) = '1' then
                clk_out <= clk_in_100;
                previous_s <= rate_custom;
                current_s <= rate_low;
                next_s <= rate_high;
                led_red <= '1';
                led_blue <= '0';
                led_green <= '0';
            else
                clk_out <= clk_in_sw;
                led_red <= '0';
                led_blue <= '0';
                led_green <= '1';
            end if;
        end case;
    end if;
end process;

end Behavioral;
