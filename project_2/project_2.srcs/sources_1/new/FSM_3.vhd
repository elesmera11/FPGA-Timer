----------------------------------------------------------------------------------
-- Company: University of Canterbury    
-- Engineers: Kate Chamberlin and Jesse Baxter
-- 
-- Due Date: 25/05/2018
-- Module Name: FSM_3
-- Project Name: Timer FPGA
-- Target Devices: FPGA
-- Description: Overarching FSM to delegate signals to individual modules
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_3 is
    Port ( clk_in : in STD_LOGIC;
           state : out STD_LOGIC;
           switches_in : in STD_LOGIC_VECTOR (15 downto 0);
           switches_out_dc, switches_out_pwm : out STD_LOGIC_VECTOR (15 downto 0);
           butts_in : in STD_LOGIC_VECTOR (4 downto 0); --centre, left, right, up, down
           butts_out_dc, butts_out_pwm : out STD_LOGIC_VECTOR (3 downto 0)); --centre, left, right, down
end FSM_3;

architecture Behavioral of FSM_3 is
    signal sv : std_logic;
begin
    process (clk_in)
    begin
        if rising_edge(clk_in) then
            if butts_in(3) = '1' then
                sv <= not sv; --toggle state
            end if;
            if sv = '0' then 
                state <= '0';
                switches_out_dc <= switches_in;
                butts_out_dc(2 downto 0) <= butts_in(2 downto 0);
                butts_out_dc(3) <= butts_in(4);
                butts_out_pwm <= X"0";
            elsif sv = '1' then
                state <= '1';
                switches_out_pwm <= switches_in;
                butts_out_pwm(2 downto 0) <= butts_in(2 downto 0);
                butts_out_dc <= X"0";
            end if;
        end if;
    end process;
end Behavioral;
