----------------------------------------------------------------------------------
-- Company: University of Canterbury    
-- Engineers: Kate Chamberlin and Jesse Baxter
-- 
-- Due Date: 25/05/2018
-- Module Name: ProgrammedTimer
-- Project Name: Timer FPGA
-- Target Devices: FPGA
-- Description: Overall structural code for programmeable down-counter and
--              PWM generator.
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ProgrammedTimer is
    Port (CLK100MHZ, BTNC, BTNL, BTNR, BTNU, BTND       : in STD_LOGIC;
          JA        : out STD_LOGIC_VECTOR(10 downto 1);
          LED16_R, LED16_B, LED16_G, LED17_B, LED17_G : out std_logic;
          LED          : out STD_LOGIC_VECTOR(15 downto 0);
          SW           : in STD_LOGIC_VECTOR(15 downto 0)); 
end ProgrammedTimer;

architecture Structural of ProgrammedTimer is
    -- connecting signals
    signal debounce_to_fsm3 : std_logic_vector(4 downto 0);
    signal state_carrier : std_logic;
    signal led_dc_r, led_dc_b, led_dc_g : STD_LOGIC;
    signal led_pwm_b, led_pwm_g : STD_LOGIC;
    signal fsm3_to_dc_butts, fsm3_to_pwm_butts : std_logic_vector(3 downto 0);
    signal sw_fsm3_to_pwm : std_logic_vector(15 downto 0);
    signal dc_to_fsm3, pwm_to_fsm3 : std_logic;
    signal period_reg_in, duty_reg_in : std_logic_vector(15 downto 0);
    signal period_reg_out   : std_logic_vector(15 downto 0);
    signal duty_reg_out     : std_logic_vector(7 downto 0);
    signal clk_div_sw, clk_div_100, clk_div_1000 : std_logic;
    signal butt_fsm1_to_period, butt_fsm1_to_duty : std_logic;
    signal wave_out               : std_logic;
    
    signal reg_to_divider         : std_logic_vector(15 downto 0);
    
    -- component instantiation
    component debouncer Port ( butt_in, clk_in : in STD_LOGIC;
                               butt_out : out STD_LOGIC);
    end component;
    
    component FSM_3 Port ( clk_in : in STD_LOGIC;
               state : out STD_LOGIC;
               switches_in : in STD_LOGIC_VECTOR (15 downto 0);
               switches_out_dc, switches_out_pwm : out STD_LOGIC_VECTOR (15 downto 0);
               butts_in : in STD_LOGIC_VECTOR (4 downto 0); --centre, left, right, up, down
               butts_out_dc, butts_out_pwm : out STD_LOGIC_VECTOR (3 downto 0)); --centre, left, right, down
    end component;
    
    component FSM_1 Port ( clk_in : in STD_LOGIC;
               sw_in : in STD_LOGIC_VECTOR (15 downto 0);
               buttons_in : in STD_LOGIC_VECTOR (3 downto 0); --centre, left, right, down
               sw_period : out STD_LOGIC_VECTOR (15 downto 0);
               sw_duty : out STD_LOGIC_VECTOR (15 downto 0);
               butt_c_period : out STD_LOGIC;
               butt_c_duty : out STD_LOGIC;
               led_blue, led_green : out STD_LOGIC);
    end component;
    
    component PWM_Gen Port (clk_in                 : in STD_LOGIC;
               reset_period         : in STD_LOGIC_VECTOR (15 downto 0); -- period + duty
               reset_duty          : in STD_LOGIC_VECTOR (7 downto 0); 
               led_out                : out STD_LOGIC);
    end component;
    
    component PeriodRegister Port ( switches     : in STD_LOGIC_VECTOR (15 downto 0);
               button       : in STD_LOGIC;
               clk_in       : in STD_LOGIC;
               reg_out      : out STD_LOGIC_VECTOR (15 downto 0));
    end component;
    
    component DutyRegister Port ( switches     : in STD_LOGIC_VECTOR (15 downto 0);
               button       : in STD_LOGIC;
               clk_in       : in STD_LOGIC;
               reg_out      : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    component ClockDivider_100k PORT(clk_in           : in  STD_LOGIC;
               clk_out_SW       : out STD_LOGIC;
               clk_out_100      : out STD_LOGIC;
               clk_out_1000     : out STD_LOGIC;
               divider_reg      : in STD_LOGIC_VECTOR(15 downto 0)); 
    end component;
    
    component Register_16bit PORT(switches : in STD_LOGIC_VECTOR (15 downto 0);
               buttons : in STD_LOGIC_VECTOR (3 downto 0);
               clk_in : in STD_LOGIC;
               reg_out : out STD_LOGIC_VECTOR (15 downto 0));
    end component;
    component FSM_2 Port ( clk :     in STD_LOGIC;
               buttons: in std_logic_vector(3 downto 0);
               clk_in_100, clk_in_1000, clk_in_sw : in std_logic;  
               clk_out : out std_logic;       
               led_red, led_blue, led_green :   out STD_LOGIC);
    end component;
    component output_mux Port ( clk_in: in STD_LOGIC;
               wave_in_dc : in STD_LOGIC;
               wave_in_pwm : in STD_LOGIC;
               wave_out : out STD_LOGIC;
               state : in STD_LOGIC;
               led_dc_r, led_dc_b, led_dc_g : in STD_LOGIC;
               led_pwm_b, led_pwm_g : in STD_LOGIC;
               led_dc_r_o, led_dc_b_o, led_dc_g_o : out STD_LOGIC;
               led_pwm_b_o, led_pwm_g_o : out STD_LOGIC );
    end component;
    
begin
    -- component placement
    U1 : debouncer PORT MAP ( butt_in => BTNC,
                                clk_in => CLK100MHZ,
                                butt_out => debounce_to_fsm3(0));
    U2 : debouncer PORT MAP ( butt_in => BTNL,
                                clk_in => CLK100MHZ,
                                butt_out => debounce_to_fsm3(1));
    U3 : debouncer PORT MAP ( butt_in => BTNR,
                                clk_in => CLK100MHZ,
                                butt_out => debounce_to_fsm3(2)); 
    U4 : debouncer PORT MAP ( butt_in => BTNU,
                                clk_in => CLK100MHZ,
                                butt_out => debounce_to_fsm3(3)); 
    U5 : debouncer PORT MAP ( butt_in => BTND,
                                clk_in => CLK100MHZ,
                                butt_out => debounce_to_fsm3(4));                                                                                  
    U6 : FSM_3 PORT MAP ( clk_in => CLK100MHZ,
                                state => state_carrier,
                                switches_in => SW,
                                switches_out_pwm => sw_fsm3_to_pwm, 
                                butts_in => debounce_to_fsm3, --centre, left, right, up, down
                                butts_out_dc => fsm3_to_dc_butts,
                                butts_out_pwm => fsm3_to_pwm_butts);
    U7 : FSM_1 PORT MAP ( clk_in => clk100MHZ,
                                sw_in => sw_fsm3_to_pwm,
                                buttons_in => fsm3_to_pwm_butts, --centre, left, right, down
                                sw_period => period_reg_in,
                                sw_duty => duty_reg_in,
                                butt_c_period => butt_fsm1_to_period,
                                butt_c_duty => butt_fsm1_to_duty,
                                led_blue => led_pwm_b,
                                led_green => led_pwm_g);
    U8: PWM_Gen PORT MAP (clk_in => CLK100MHZ,
                                reset_period => period_reg_out,
                                reset_duty => duty_reg_out,
                                led_out => pwm_to_fsm3);
    U9: PeriodRegister PORT MAP ( switches => period_reg_in,
                                button => butt_fsm1_to_period,
                                clk_in => CLK100MHZ,
                                reg_out => period_reg_out);
    U10: DutyRegister PORT MAP ( switches => duty_reg_in,
                                button => butt_fsm1_to_duty,
                                clk_in => CLK100MHZ,
                                reg_out => duty_reg_out);
                                  
    U11: ClockDivider_100k PORT MAP ( clk_in => CLK100MHZ,
                                clk_out_SW => clk_div_sw,
                                clk_out_100 => clk_div_100,
                                clk_out_1000 => clk_div_1000,
                                divider_reg => reg_to_divider);
                                      
    U12: FSM_2 Port map ( clk => CLK100MHZ,
                                buttons => fsm3_to_dc_butts,
                                clk_in_100 => clk_div_sw,
                                clk_in_1000 => clk_div_100,
                                clk_in_sw => clk_div_1000,  
                                clk_out => dc_to_fsm3,     
                                led_red => led_dc_r, 
                                led_blue => led_dc_b, 
                                led_green => led_dc_g);
                          
    U13: Register_16bit PORT MAP (switches => sw_fsm3_to_pwm,
                                buttons => fsm3_to_dc_butts,
                                clk_in => CLK100MHZ,
                                reg_out => reg_to_divider);  
    U14: output_mux PORT MAP ( clk_in=> CLK100MHZ,
                                wave_in_dc => dc_to_fsm3,
                                wave_in_pwm => pwm_to_fsm3,
                                wave_out => wave_out,
                                state => state_carrier,
                                led_dc_r => led_dc_r, 
                                led_dc_b => led_dc_b, 
                                led_dc_g => led_dc_g,
                                led_pwm_b => led_pwm_b, 
                                led_pwm_g => led_pwm_g,
                                led_dc_r_o => LED16_r, 
                                led_dc_b_o => LED16_b, 
                                led_dc_g_o => LED16_g,
                                led_pwm_b_o => LED17_b, 
                                led_pwm_g_o => LED17_g );
    
    JA(1) <= wave_out;
    LED(0) <= wave_out;

end Structural;
