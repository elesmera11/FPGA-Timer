----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.05.2018 20:06:29
-- Design Name: 
-- Module Name: FSM_2_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSM_2_tb is
--  Port ( );
end FSM_2_tb;

architecture Behavioral of FSM_2_tb is
    component FSM_2 Port ( clk                                  : in std_logic;
                           buttons                              : in std_logic_vector(3 downto 0);
                           clk_in_100, clk_in_1000, clk_in_sw   : in std_logic;  
                           clk_out                              : out std_logic;       
                           led_red, led_blue, led_green         : out std_logic);
    end component;
    
    constant ClockPeriod                : TIME := 10 ns;
    
    signal buttons                      : std_logic_vector(3 downto 0); --centre, left, right, down
    signal clk                          : std_logic;
    signal clk_in_50                    : std_logic; --arbitrarily set to 5 clock cycles.
    signal clk_in_100                   : std_logic; --arbitrarily set to 10 clock cycles.
    signal clk_in_150                   : std_logic; --arbitrarily set to 15 clock cycles.
    signal clk_out                      : std_logic;
    signal led_red, led_blue, led_green : std_logic := '0';
    

begin
    -- instantiating component for testing
    UUT: FSM_2 port map (clk => clk,
                         buttons => buttons,
                         clk_in_100 => clk_in_50,
                         clk_in_1000 => clk_in_100,
                         clk_in_sw => clk_in_150,
                         clk_out => clk_out,
                         led_red => led_red,
                         led_blue => led_blue,
                         led_green => led_green);
    
    process
    begin
        loop 
            clk <= '1';
            wait for 10 ns;
            clk <= '0';
            wait for 10 ns;
        end loop;
    end process;
    
    process
    begin
        loop 
            clk_in_50 <= '1';
            wait for 10 ns;
            clk_in_50 <= '0';
            wait for 40 ns;
        end loop;
    end process;
    
    process
    begin
        loop 
            clk_in_100 <= '1';
            wait for 10 ns;
            clk_in_100 <= '0';
            wait for 90 ns;
        end loop;
    end process;
    
    process
    begin
        loop 
            clk_in_150 <= '1';
            wait for 10 ns;
            clk_in_150 <= '0';
            wait for 140 ns;
        end loop;
    end process;
    
    process
    begin
        buttons <= X"0"; -- initially no buttons
        wait for 200 ns;
        buttons <= X"4"; -- left button activated (state change)
        wait for 10 ns;
        buttons <= X"0"; 
        wait for 190 ns;
        buttons <= X"4"; -- left button activated (state change)
        wait for 10 ns;
        buttons <= X"0"; 
        wait for 190 ns;
        buttons <= X"4"; -- left button activated (state change)
        wait for 10 ns;
        buttons <= X"0"; 
        wait for 190 ns;
        buttons <= X"4"; -- left button activated (state change)
        wait for 10 ns;
        buttons <= X"0"; 
        wait for 190 ns;
        buttons <= X"2"; -- right button pressed (state change opposite way)
        wait for 10 ns;
        buttons <= X"0"; 
        wait for 190 ns;
        buttons <= X"8"; -- centre button pressed (no effect wanted)
        wait for 10 ns;
        buttons <= X"0"; 
        wait for 190 ns;
        buttons <= X"1"; -- down button pressed (no effect wanted)
        wait for 10 ns;
        buttons <= X"0"; 
        wait;
    end process;
end Behavioral;
