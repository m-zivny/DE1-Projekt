library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity seg_control is
    generic (
            us1_stovky_pos : STD_LOGIC_VECTOR (7 downto 0) := (others => '1');
            us1_desitky_pos : STD_LOGIC_VECTOR (7 downto 0) := (others => '1');
            us1_jednotky_pos : STD_LOGIC_VECTOR (7 downto 0) := (others => '1');

            us2_stovky_pos : STD_LOGIC_VECTOR (7 downto 0) := (others => '1');
            us2_desitky_pos : STD_LOGIC_VECTOR (7 downto 0) := (others => '1');
            us2_jednotky_pos : STD_LOGIC_VECTOR (7 downto 0) := (others => '1')
        );
    Port (
        US1_IN   : in  STD_LOGIC_VECTOR (8 downto 0); -- 0 az 400
        US2_IN   : in  STD_LOGIC_VECTOR (8 downto 0); -- 0 az 400
        AN       : out STD_LOGIC_VECTOR (7 downto 0); -- anody (aktivní LOW)
        BIN_OUT  : out STD_LOGIC_VECTOR (3 downto 0); -- zvolený BCD digit
        clk      : in  STD_LOGIC;
        US1_EN  : in  STD_LOGIC;
        US2_EN   : in  STD_LOGIC;  
        RST      : in  STD_LOGIC );
end seg_control;

architecture Behavioral of seg_control is
    signal us1_jednotky_digit : integer := 0; -- stovky
    signal us1_desitky_digit : integer := 0; -- desítky
    signal us1_stovky_digit : integer := 0; -- jednotky

    signal us2_jednotky_digit : integer := 0; -- stovky
    signal us2_desitky_digit : integer := 0; -- desítky
    signal us2_stovky_digit : integer := 0; -- jednotky

    signal cnt    : integer range 0 to 2 := 0;
    signal sensor : std_logic := '0';
    signal us1_distance : integer := 0;
    signal us2_distance : integer := 0;
begin
    process(clk)
        variable us1_temp_dist : integer;
        variable us2_temp_dist : integer;
    begin
        if rising_edge(clk) then
    
            if US1_EN = '1' then
                us1_temp_dist := to_integer(unsigned(US1_IN));
                us1_stovky_digit <= us1_temp_dist / 100;
                us1_desitky_digit <= (us1_temp_dist / 10) mod 10;
                us1_jednotky_digit <= us1_temp_dist mod 10;
            end if;
            
            if US2_EN = '1' then
                us2_temp_dist := to_integer(unsigned(US2_IN));
                us2_stovky_digit <= us2_temp_dist / 100;
                us2_desitky_digit <= (us2_temp_dist / 10) mod 10;
                us2_jednotky_digit <= us2_temp_dist mod 10;
            end if;

            case sensor is 
                when '0' =>
                    case cnt is
                        when 0 =>
                            BIN_OUT <= std_logic_vector(to_unsigned(us1_jednotky_digit, 4));
                            AN <= us1_jednotky_pos;
                            cnt <= 1;
                        when 1 =>
                            BIN_OUT <= std_logic_vector(to_unsigned(us1_desitky_digit, 4));
                            AN <= us1_desitky_pos;
                            cnt <= 2;
                        when 2 =>
                            BIN_OUT <= std_logic_vector(to_unsigned(us1_stovky_digit, 4));
                            AN <= us1_stovky_pos;
                            cnt <= 0;
                            sensor <= '1';
                        when others =>
                            cnt <= 0;
                            
                    end case;
                when '1' =>
                case cnt is
                    when 0 =>
                        BIN_OUT <= std_logic_vector(to_unsigned(us2_jednotky_digit, 4));
                        AN <= us2_jednotky_pos;
                        cnt <= 1;
                    when 1 =>
                        BIN_OUT <= std_logic_vector(to_unsigned(us2_desitky_digit, 4));
                        AN <= us2_desitky_pos;
                        cnt <= 2;
                    when 2 =>
                        BIN_OUT <= std_logic_vector(to_unsigned(us2_stovky_digit, 4));
                        AN <= us2_stovky_pos;
                        cnt <= 0;
                        sensor <= '0';
                    when others =>
                        cnt <= 0;
                        
                end case;
                when others =>
                    sensor <= '0';
            end case;               
        end if;
    end process;
end Behavioral;