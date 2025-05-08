-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Thu, 08 May 2025 14:52:10 GMT
-- Request id : cfwk-fed377c2-681cc51aa864c

library ieee;
use ieee.std_logic_1164.all;

entity tb_led_control is
end tb_led_control;

architecture tb of tb_led_control is

    component led_control
        generic(
            threshold_cm : INTEGER := 20
        );
        port (clk         : in std_logic;
              distance_cm : in std_logic_vector (9 downto 0);
              RGB_LED     : out std_logic_vector (1 downto 0));
    end component;

    signal clk         : std_logic;
    signal distance_cm : std_logic_vector (9 downto 0);
    signal RGB_LED     : std_logic_vector (1 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : led_control
    generic map(
        threshold_cm => 20
    )
    port map (clk         => clk,
              distance_cm => distance_cm,
              RGB_LED     => RGB_LED);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        distance_cm <= "0000100011";
        wait for 50 ns;
        distance_cm <= "0000010001";
        wait for 20 ns;
        distance_cm <= "0110010000";
        wait for 30 ns;
        distance_cm <= "0000000011";
        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_led_control of tb_led_control is
    for tb
    end for;
end cfg_tb_led_control;