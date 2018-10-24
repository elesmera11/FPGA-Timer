----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.05.2018 16:28:33
-- Design Name: 
-- Module Name: ProgrammedTimer_sim - Behavioral
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

entity ProgrammedTimer_sim is
--  Port ( );
end ProgrammedTimer_sim;

rchitecture Behavioral of ProgrammedTimer_sim is
    component ProgrammedTimer
        Port (CLK100MHZ, BTNC       : in STD_LOGIC;
              JA                    : out STD_LOGIC_VECTOR(10 downto 1);
              LED16_B, LED17_R      : out STD_LOGIC;
              SW                    : in STD_LOGIC_VECTOR(15 downto 0);
              LED                   : out STD_LOGIC_VECTOR(15 downto 0));
    end component;
    signal CLK100MHZ, BTNC       : STD_LOGIC;
    signal JA                    : STD_LOGIC_VECTOR(10 downto 1);
    signal LED16_B, LED17_R      : STD_LOGIC;
    signal SW                    : STD_LOGIC_VECTOR(15 downto 0);
    signal LED                   : STD_LOGIC_VECTOR(15 downto 0);
    constant ClockPeriod : TIME := 10 ns;
    

begin
    
    UUT: ProgrammedTimer port map (SW => SW, CLK100MHZ => CLK100MHZ, JA => JA, LED16_B => LED16_B,
                                   BTNC => BTNC, LED => LED);
                                    
    process
        begin
            CLK100MHZ <= '0';
            BTNC <= '0';
            SW <= X"0001";
            wait for 10 ns;
            CLK100MHZ <= '1';
            BTNC <= '1';
            wait for 10 ns;
            CLK100MHZ <= '0';
            wait for 10 ns;
            CLK100MHZ <= '1';
            wait for 10 ns;
            CLK100MHZ <= '0';
            wait for 10 ns;
            CLK100MHZ <= '1';
            wait for 10 ns;
            CLK100MHZ <= '0';
            wait for 10 ns;
            CLK100MHZ <= '1';
            wait for 10 ns;
            CLK100MHZ <= '0';
            wait for 10 ns;
            CLK100MHZ <= '1';
            wait;
    end process;
end Behavioral;
