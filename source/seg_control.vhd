library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity seg_control is
    Port (
        US_IN    : in  STD_LOGIC_VECTOR (8 downto 0); -- 0 az 400
        AN       : out STD_LOGIC_VECTOR (7 downto 0); -- anody (aktivní LOW)
        BIN_OUT  : out STD_LOGIC_VECTOR (3 downto 0); -- zvolený BCD digit
        clk      : in  STD_LOGIC;
        LED_OUT  : out STD_LOGIC;
        EN       : in  std_logic );
end seg_control;
architecture Behavioral of seg_control is
    signal digit1 : integer := 0; -- stovky
    signal digit2 : integer := 0; -- desítky
    signal digit3 : integer := 0; -- jednotky
    signal cnt    : integer range 0 to 2 := 0;
    signal int_us : integer;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if EN = '1' then
                -- US_IN prevest na cm
                int_us <= to_integer(unsigned(US_IN));
                
                digit1 <= int_us / 100;
                digit2 <= (int_us / 10) mod 10;
                digit3 <= int_us mod 10;
            else
                case cnt is
                    when 0 =>
                        BIN_OUT <= std_logic_vector(to_unsigned(digit3, 4));
                        AN <= "11111110"; 
                        LED_OUT <= '0';
                        cnt <= 1;
                    when 1 =>
                        BIN_OUT <= std_logic_vector(to_unsigned(digit2, 4));
                        AN <= "11111101"; 
                        LED_OUT <= '0';
                        cnt <= 2;
                    when 2 =>
                        BIN_OUT <= std_logic_vector(to_unsigned(digit1, 4));
                        AN <= "11111011"; 
                        LED_OUT <= '1'; 
                        cnt <= 0;
                    when others =>
                        cnt <= 0;
                end case;
            end if;
        end if;
    end process;
end Behavioral;