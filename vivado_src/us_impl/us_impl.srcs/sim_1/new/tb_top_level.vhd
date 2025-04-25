-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Fri, 25 Apr 2025 09:44:04 GMT
-- Request id : cfwk-fed377c2-680b59640cf73

library ieee;
use ieee.std_logic_1164.all;

entity tb_top_level is
end tb_top_level;

architecture tb of tb_top_level is

    component top_level
        port (CLK100MHZ : in std_logic;
              TRIGGER   : out std_logic;
              ECHO      : in std_logic;
              AN        : out std_logic_vector (7 downto 0);
              CA        : out std_logic;
              CB        : out std_logic;
              CC        : out std_logic;
              CD        : out std_logic;
              CE        : out std_logic;
              CF        : out std_logic;
              CG        : out std_logic;
              DP        : out std_logic;
              LED_16G   : out std_logic;
              LED_164R  : out std_logic);
    end component;

    signal CLK100MHZ : std_logic;
    signal TRIGGER   : std_logic;
    signal ECHO      : std_logic;
    signal AN        : std_logic_vector (7 downto 0);
    signal CA        : std_logic;
    signal CB        : std_logic;
    signal CC        : std_logic;
    signal CD        : std_logic;
    signal CE        : std_logic;
    signal CF        : std_logic;
    signal CG        : std_logic;
    signal DP        : std_logic;
    signal LED_16G   : std_logic;
    signal LED_164R  : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : top_level
    port map (CLK100MHZ => CLK100MHZ,
              TRIGGER   => TRIGGER,
              ECHO      => ECHO,
              AN        => AN,
              CA        => CA,
              CB        => CB,
              CC        => CC,
              CD        => CD,
              CE        => CE,
              CF        => CF,
              CG        => CG,
              DP        => DP,
              LED_16G   => LED_16G,
              LED_164R  => LED_164R);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that CLK100MHZ is really your main clock signal
    CLK100MHZ <= TbClock;

    stimuli : process
    begin
        ECHO <= '0';
        wait for 50 ms;
        ECHO <= '1';
        wait for 27 ms;
        ECHO <= '0';
        wait for 60 ms;
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_top_level of tb_top_level is
    for tb
    end for;
end cfg_tb_top_level;