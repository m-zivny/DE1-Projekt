-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Thu, 01 May 2025 19:18:04 GMT
-- Request id : cfwk-fed377c2-6813c8ec643ac

library ieee;
use ieee.std_logic_1164.all;

entity tb_top_level is
end tb_top_level;

architecture tb of tb_top_level is

    component top_level
        port (CLK100MHZ   : in std_logic;
              US1_TRIGGER : out std_logic;
              US2_TRIGGER : out std_logic;
              US1_ECHO    : in std_logic;
              US2_ECHO    : in std_logic;
              AN          : out std_logic_vector (7 downto 0);
              CA          : out std_logic;
              CB          : out std_logic;
              CC          : out std_logic;
              CD          : out std_logic;
              CE          : out std_logic;
              CF          : out std_logic;
              CG          : out std_logic;
              DP          : out std_logic;
              LED_16G     : out std_logic;
              LED_16R     : out std_logic;
              LED_17G     : out std_logic;
              LED_17R     : out std_logic);
    end component;

    signal CLK100MHZ   : std_logic;
    signal US1_TRIGGER : std_logic;
    signal US2_TRIGGER : std_logic;
    signal US1_ECHO    : std_logic;
    signal US2_ECHO    : std_logic;
    signal AN          : std_logic_vector (7 downto 0);
    signal CA          : std_logic;
    signal CB          : std_logic;
    signal CC          : std_logic;
    signal CD          : std_logic;
    signal CE          : std_logic;
    signal CF          : std_logic;
    signal CG          : std_logic;
    signal DP          : std_logic;
    signal LED_16G     : std_logic;
    signal LED_16R     : std_logic;
    signal LED_17G     : std_logic;
    signal LED_17R     : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : top_level
    port map (CLK100MHZ   => CLK100MHZ,
              US1_TRIGGER => US1_TRIGGER,
              US2_TRIGGER => US2_TRIGGER,
              US1_ECHO    => US1_ECHO,
              US2_ECHO    => US2_ECHO,
              AN          => AN,
              CA          => CA,
              CB          => CB,
              CC          => CC,
              CD          => CD,
              CE          => CE,
              CF          => CF,
              CG          => CG,
              DP          => DP,
              LED_16G     => LED_16G,
              LED_16R     => LED_16R,
              LED_17G     => LED_17G,
              LED_17R     => LED_17R);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that CLK100MHZ is really your main clock signal
    CLK100MHZ <= TbClock;

    stimuli : process
        variable us1_echo_pulse : time := 5 us;
        variable us2_echo_pulse : time := 13 us;
        variable period : time := 100 us;
    begin
        US1_ECHO <= '0';
        US2_ECHO <= '0';
        wait for 100025 ns;
        for i in 1 to 20 loop
        US1_ECHO <= '1';
        US2_ECHO <= '1';
        wait for us1_echo_pulse;
        US1_ECHO <= '0';    
        wait for (us2_echo_pulse-us1_echo_pulse);
        US2_ECHO <= '0';
        wait for (period - us2_echo_pulse + 10 ns);  
        us1_echo_pulse := us1_echo_pulse + 1 us;
        us2_echo_pulse := us2_echo_pulse + 1 us;
        end loop;
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_top_level of tb_top_level is
    for tb
    end for;
end cfg_tb_top_level;