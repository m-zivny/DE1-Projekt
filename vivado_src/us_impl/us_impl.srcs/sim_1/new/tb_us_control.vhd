-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Thu, 08 May 2025 13:53:52 GMT
-- Request id : cfwk-fed377c2-681cb7705d1ac

library ieee;
use ieee.std_logic_1164.all;

entity tb_us_control is
end tb_us_control;

architecture tb of tb_us_control is

    component us_control
        port (TRIG         : out std_logic;
              ECHO         : in std_logic;
              DIST_OUT     : out std_logic_vector (9 downto 0) := (others =>'0');
              clk          : in std_logic;
              en_load      : out std_logic;
              switch_pulse : in std_logic;
              delivered    : in std_logic);
    end component;

    signal TRIG         : std_logic;
    signal ECHO         : std_logic;
    signal DIST_OUT     : std_logic_vector (9 downto 0) := (others =>'0');
    signal clk          : std_logic;
    signal en_load      : std_logic;
    signal switch_pulse : std_logic;
    signal delivered    : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : us_control
    port map (TRIG         => TRIG,
              ECHO         => ECHO,
              DIST_OUT     => DIST_OUT,
              clk          => clk,
              en_load      => en_load,
              switch_pulse => switch_pulse,
              delivered    => delivered);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        ECHO <= '0';
        switch_pulse <= '0';
        wait for 10 ms;
        switch_pulse <= '1';
        wait for 20 ns;
        switch_pulse <= '0';
        wait for 40 us;
        ECHO <= '1';
        wait for 30 ms;
        ECHO <= '0';
        wait for 60 ms;
        switch_pulse <= '1';
        wait for 20 ns;
        switch_pulse <= '0';

        -- ***EDIT*** Add stimuli here
        wait for 4000000 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_us_control of tb_us_control is
    for tb
    end for;
end cfg_tb_us_control;