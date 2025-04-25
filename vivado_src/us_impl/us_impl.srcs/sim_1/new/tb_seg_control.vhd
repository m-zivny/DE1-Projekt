
library ieee;
use ieee.std_logic_1164.all;

entity tb_seg_control is
end tb_seg_control;

architecture tb of tb_seg_control is

    component seg_control
        port (US_IN   : in std_logic_vector (8 downto 0);
              AN      : out std_logic_vector (7 downto 0);
              BIN_OUT : out std_logic_vector (3 downto 0);
              clk     : in std_logic;
              LED_OUT : out std_logic;
              EN      : in std_logic);
    end component;

    signal US_IN   : std_logic_vector (8 downto 0);
    signal AN      : std_logic_vector (7 downto 0);
    signal BIN_OUT : std_logic_vector (3 downto 0);
    signal clk     : std_logic;
    signal LED_OUT : std_logic;
    signal EN      : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : seg_control
    port map (US_IN   => US_IN,
              AN      => AN,
              BIN_OUT => BIN_OUT,
              clk     => clk,
              LED_OUT => LED_OUT,
              EN      => EN);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        US_IN <= (others => '0');
        EN <= '0';
        wait for 100 ns;
        US_IN <= "011000000";
        EN <= '1';
        wait for 100 ns;
        EN <= '0';
        wait for 400 ns;        

        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_seg_control of tb_seg_control is
    for tb
    end for;
end cfg_tb_seg_control;