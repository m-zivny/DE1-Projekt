-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Thu, 08 May 2025 13:37:02 GMT
-- Request id : cfwk-fed377c2-681cb37ed00ca

library ieee;
use ieee.std_logic_1164.all;

entity tb_seg_control is
end tb_seg_control;

architecture tb of tb_seg_control is

    component seg_control
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
        port (US1_IN   : in std_logic_vector (9 downto 0);
              US2_IN   : in std_logic_vector (9 downto 0);
              AN       : out std_logic_vector (7 downto 0);
              BIN_OUT  : out std_logic_vector (3 downto 0);
              clk      : in std_logic;
              US1_EN   : in std_logic;
              US2_EN   : in std_logic;
              US1_DLVR : out std_logic;
              US2_DLVR : out std_logic);
    end component;

    signal US1_IN   : std_logic_vector (9 downto 0);
    signal US2_IN   : std_logic_vector (9 downto 0);
    signal AN       : std_logic_vector (7 downto 0);
    signal BIN_OUT  : std_logic_vector (3 downto 0);
    signal clk      : std_logic;
    signal US1_EN   : std_logic;
    signal US2_EN   : std_logic;
    signal US1_DLVR : std_logic;
    signal US2_DLVR : std_logic;

    constant TbPeriod : time := 50 us; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : seg_control
    generic map (
        us1_stovky_pos => "11111011",
        us1_desitky_pos => "11111101",
        us1_jednotky_pos => "11111110",
    
        us2_stovky_pos => "10111111",
        us2_desitky_pos => "11011111",
        us2_jednotky_pos => "11101111"
    )
    port map (US1_IN   => US1_IN,
              US2_IN   => US2_IN,
              AN       => AN,
              BIN_OUT  => BIN_OUT,
              clk      => clk,
              US1_EN   => US1_EN,
              US2_EN   => US2_EN,
              US1_DLVR => US1_DLVR,
              US2_DLVR => US2_DLVR);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        US1_IN <= (others => '0');
        US2_IN <= (others => '0');
        US1_EN <= '0';
        US2_EN <= '0';
        wait for 50 us;
        US1_IN <= "0100001100";
        US1_EN <= '1';
        wait for 100 us;
        US1_EN <= '0';
        wait for 250 us;
        US2_IN <= "0000001110";
        US2_EN <= '1';
        wait for 100 us;
        US2_EN <= '0';

        wait for 500 us;

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