----------------------------------------------------------------------------------
-- Company: University of Canterbury    
-- Engineers: Kate Chamberlin and Jesse Baxter
-- 
-- Due Date: 25/05/2018
-- Module Name: debouncer
-- Project Name: Timer FPGA
-- Target Devices: FPGA
-- Description: Module to debounce button signals
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity debouncer is
    Port ( butt_in, clk_in : in STD_LOGIC;
           butt_out : out STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is
    --debounce for 50ms
    constant debouncer : STD_LOGIC_VECTOR(23 downto 0) := X"4C4B40";
    signal counter : STD_LOGIC_VECTOR(23 downto 0);
begin

process (clk_in)
begin
    if rising_edge(clk_in) then 
        if  butt_in = '1' then
            counter <= counter + X"000001";
            if counter = debouncer then
                butt_out <= '1';
                counter <= counter + X"000001"; --output one for only one clock cycle
            else
                butt_out <= '0';
            end if;
        else
            counter <= X"000000";
            butt_out <= '0';
        end if;
    end if;
end process;

end Behavioral;
