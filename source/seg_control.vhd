library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity seg_control is
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
    Port (
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
        US1_DLVR : out STD_LOGIC  := '0';
        US2_DLVR  : out STD_LOGIC := '0'
    );
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
    signal us1_done : std_logic := '0';
    signal us2_done : std_logic := '0';
begin
    -- modul ridici zobrazeni vzdalenosti na 2 casti 7segmentovych displeju
    -- rozdelen na 2 procesy - nacitani a na multiplexing

    -- nacitani hodnot
    -- pokud jsou enable piny v 1, modul si nacte vzdalenost a rozpocita na jednotlive pozice
    -- nasledne take podava zpetnou vazbu po dobu jedne periody, ze informaci uspesne prijal
    process(clk)
        variable us1_temp_dist : integer;
        variable us2_temp_dist : integer;
        
    begin
        if rising_edge(clk) then
            if US1_EN = '1' or US2_EN = '1' then
                if US1_EN = '1' then
                    us1_temp_dist := to_integer(unsigned(US1_IN));
                    us1_stovky_digit <= us1_temp_dist / 100;
                    us1_desitky_digit <= (us1_temp_dist / 10) mod 10;
                    us1_jednotky_digit <= us1_temp_dist mod 10;
                    US1_DLVR <= '1';
                    us1_done <= '1';
                
                elsif US2_EN = '1' then
                    us2_temp_dist := to_integer(unsigned(US2_IN));
                    us2_stovky_digit <= us2_temp_dist / 100;
                    us2_desitky_digit <= (us2_temp_dist / 10) mod 10;
                    us2_jednotky_digit <= us2_temp_dist mod 10;
                    US2_DLVR <= '1';
                    us2_done <= '1';
                end if;      
            end if;
            if us1_done = '1' then
                US1_DLVR <= '0';
                us1_done <= '0';
            end if;       
            if us2_done = '1' then
                US2_DLVR <= '0';
                us2_done <= '0';
            end if;       
        end if;

    end process;

    -- multiplexing na 7seg displeje
    -- postupne synchronne prepina mezi daty jednotlivych senzoru a mezi jednotlivymi pozicemi na 7seg displeji a zobrazuje hodnoty
    -- take prepocitava jednotlive cisla do BCD kodu, ktery nasledne zpristupnuje modulu bin2seg
    process(clk)
    begin
        if rising_edge(clk)then
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