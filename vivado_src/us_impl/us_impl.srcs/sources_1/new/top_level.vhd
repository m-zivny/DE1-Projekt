----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2025 11:09:28 AM
-- Design Name: 
-- Module Name: top_level - Behavioral
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

entity top_level is
    Port ( CLK100MHZ : in STD_LOGIC;
           TRIGGER : out STD_LOGIC;
           ECHO : in STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC;
           DP : out STD_LOGIC;
           LED_16G : out STD_LOGIC;
           LED_164R : out STD_LOGIC);
end top_level;

architecture Behavioral of top_level is

component seg_control is
port (
        US_IN    : in  STD_LOGIC_VECTOR (8 downto 0); -- 0 az 400
        AN       : out STD_LOGIC_VECTOR (7 downto 0); -- anody (aktivní LOW)
        BIN_OUT  : out STD_LOGIC_VECTOR (3 downto 0); -- zvolený BCD digit
        clk      : in  STD_LOGIC;
        LED_OUT  : out STD_LOGIC;
        EN       : in  std_logic 
        );
        
end component seg_control;

component bin2seg is
port(
           clear : in STD_LOGIC;
           bin : in STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0)
           );
end component bin2seg;

component us_control is
port (
        TRIG         : out   std_logic := '0';
        ECHO         : in    std_logic := '0';
        DIST_OUT     : out   std_logic_vector (8 downto 0) := (others =>'0') ;
        clk          : in    std_logic;
        en_load      : out   std_logic := '0';
        switch_pulse : in std_logic     
);
end component us_control;

component clock_enable is
 generic (
            N_PERIODS : integer
        );
port (
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           pulse : out STD_LOGIC
);

end component clock_enable;

signal distance : std_logic_vector (8 downto 0) := (others =>'0');
signal enable_load : std_logic;
signal binary_dist : std_logic_vector (3 downto 0);
signal switch_signal : std_logic;

begin

us_ctrl : component us_control
port map (
    clk => CLK100MHZ,
    TRIG => TRIGGER,
    ECHO => ECHO,
    DIST_OUT => distance,
    en_load => enable_load,
    switch_pulse => switch_signal
);

seg_ctrl : component seg_control
port map(
    US_IN => distance,
    AN => AN,
    BIN_OUT => binary_dist,
    clk => CLK100MHZ,
    EN => enable_load
);

binseg : component bin2seg
port map(
           clear => '0',
           bin => binary_dist, 
           seg(6) => CA,
           seg(5) => CB,
           seg(4) => CC,
           seg(3) => CD,
           seg(2) => CE,
           seg(1) => CF,
           seg(0) => CG
           
);

clock_en : component clock_enable
generic map (
    N_PERIODS => 5_000_000
)
port map (
    clk => CLK100MHZ,
    rst => '0',
    pulse => switch_signal
);

end Behavioral;
