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
    Port ( 
           CLK100MHZ : in STD_LOGIC;
           US1_TRIGGER : out STD_LOGIC;
           US2_TRIGGER : out STD_LOGIC;
           US1_ECHO : in STD_LOGIC;
           US2_ECHO : in STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC;
           DP : out STD_LOGIC;
           LED16_G : out STD_LOGIC;
           LED16_R : out STD_LOGIC;
           LED17_G : out STD_LOGIC;
           LED17_R : out STD_LOGIC);
end top_level;

architecture Behavioral of top_level is

component seg_control is
    generic (
        -- genericy urcuji pozici cisel na jednotlivych sedmisegmentovych displejich
        -- senzor 1
        us1_stovky_pos : STD_LOGIC_VECTOR (7 downto 0) := (others => '1');
        us1_desitky_pos : STD_LOGIC_VECTOR (7 downto 0) := (others => '1');
        us1_jednotky_pos : STD_LOGIC_VECTOR (7 downto 0) := (others => '1');

        -- senzor 2
        us2_stovky_pos : STD_LOGIC_VECTOR (7 downto 0) := (others => '1');
        us2_desitky_pos : STD_LOGIC_VECTOR (7 downto 0) := (others => '1');
        us2_jednotky_pos : STD_LOGIC_VECTOR (7 downto 0) := (others => '1')

    );
port (
        -- vstupni vzdalenosti jednotlivych senzoru
        US1_IN   : in  STD_LOGIC_VECTOR (9 downto 0); 
        US2_IN   : in  STD_LOGIC_VECTOR (9 downto 0); 

        -- vystupni 8bitove slovo pro rizeni 7seg displeje
        AN       : out STD_LOGIC_VECTOR (7 downto 0); 

        -- vystupni BCD kod pro modul bin2seg
        BIN_OUT  : out STD_LOGIC_VECTOR (3 downto 0); 

         -- hodinovy signal
        clk      : in  STD_LOGIC;

        -- vstupni periferie pro povoleni nacteni vzdalenosti 
        US1_EN  : in  STD_LOGIC;
        US2_EN   : in  STD_LOGIC;  

        -- vystupni logika zpetne vazby pro us_control, urcujici, ze byly vzdalenosti doruceny
        US1_DLVR : out STD_LOGIC;
        US2_DLVR : out STD_LOGIC
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
        -- Porty pro komunikaci s ultrasonickym senzorem
        TRIG         : out   std_logic := '0';
        ECHO         : in    std_logic := '0';

        -- Port pro vysilani spocitane vzdalenosti
        DIST_OUT     : out   std_logic_vector (9 downto 0) := (others =>'0') ;

        -- Hodinovy signal
        clk          : in    std_logic;

        -- port umoznujici nacitani vzdalenosti do modulu seg_control
        en_load      : out   std_logic := '0';
        switch_pulse : in std_logic;

        -- zpetna vazba modulu seg_control o prijmuti vzdalenosti
        delivered : in std_logic   
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

component led_control is 
generic(
    threshold_cm : integer
);
port (
    clk : in std_logic;
    distance_cm    : in  STD_LOGIC_VECTOR (9 downto 0);
    RGB_LED  : out STD_LOGIC_VECTOR (1 downto 0)
);
end component led_control;

-- signaly pro prenos mezi moduly us_control, seg_control a led_control
signal us1_distance : std_logic_vector (9 downto 0) := (others =>'0');
signal us2_distance : std_logic_vector (9 downto 0) := (others =>'0');

-- signaly pro nacitani vzdalenosti do modulu 
signal us1_enable_load : std_logic;
signal us2_enable_load : std_logic;

-- signal pro prenos BCD cisla pro bin2seg modul
signal binary_dist : std_logic_vector (3 downto 0);

-- signal prepinajici modul us_control do stavu TRIGGER
signal switch_signal : std_logic;

-- zpomaleny clock pro seg_control
signal seg_clock : std_logic;

-- zpetna vazba modulu seg_control pro us_control, zajistujici spolehlive doruceni vzdalenosti
signal us1_dlvr_sig : std_logic;
signal us2_dlvr_sig : std_logic;

begin

us1_ctrl : component us_control
port map (
    clk => CLK100MHZ,
    TRIG => US1_TRIGGER,
    ECHO => US1_ECHO,
    DIST_OUT => us1_distance,
    en_load => us1_enable_load,
    switch_pulse => switch_signal,
    delivered => us1_dlvr_sig
);

us2_ctrl : component us_control
    port map (
        clk => CLK100MHZ,
        TRIG => US2_TRIGGER,
        ECHO => US2_ECHO,
        DIST_OUT => us2_distance,
        en_load => us2_enable_load,
        switch_pulse => switch_signal,
        delivered => us2_dlvr_sig
);


seg_ctrl : component seg_control
generic map (
    us1_stovky_pos => "11111011",
    us1_desitky_pos => "11111101",
    us1_jednotky_pos => "11111110",

    us2_stovky_pos => "10111111",
    us2_desitky_pos => "11011111",
    us2_jednotky_pos => "11101111"
)
port map(
        US1_IN => us1_distance,
        US2_IN => us2_distance,  
        AN     => AN,  
        BIN_OUT => binary_dist, 
        clk      => seg_clock,
        US1_EN  => us1_enable_load,
        US2_EN  => us2_enable_load,
        US1_DLVR => us1_dlvr_sig,
        US2_DLVR => us2_dlvr_sig
);

bintoseg : component bin2seg
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

us_enable : component clock_enable
generic map (
    N_PERIODS => 20_000_000
)
port map (
    clk => CLK100MHZ,
    rst => '0',
    pulse => switch_signal
);

seg_enable : component clock_enable 
    generic map (
        N_PERIODS => 500_000
    )
    port map(
    clk => CLK100MHZ,
    rst => '0',
    pulse => seg_clock
    );

us1_led_ctrl : component led_control
 generic map(
    threshold_cm => 20
)
 port map(
    clk => CLK100MHZ,
    distance_cm => us1_distance,
    RGB_LED(0) => LED16_G,
    RGB_LED(1) => LED16_R
);

us2_led_ctrl : component led_control
 generic map(
    threshold_cm => 20
)
 port map(
    clk => CLK100MHZ,
    distance_cm => us2_distance,
    RGB_LED(0) => LED17_G,
    RGB_LED(1) => LED17_R
);
DP <= '1';

end Behavioral;
