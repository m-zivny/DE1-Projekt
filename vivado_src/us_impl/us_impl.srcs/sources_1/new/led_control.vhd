library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity led_control is
    generic(
        threshold_cm : INTEGER := 20
    );
    Port (
        clk : in std_logic;
        distance_cm    : in  STD_LOGIC_VECTOR (8 downto 0);
        RGB_LED  : out STD_LOGIC_VECTOR (1 downto 0)
        ); -- vystup na RGB LED -- RGB_LED(1) = Red, RGB_LED(0) = Green
end led_control;

architecture Behavioral of led_control is
begin
    process(clk)
        variable dist_cm_int :INTEGER;
    begin
        if(rising_edge(clk)) then
            dist_cm_int := to_integer(unsigned(distance_cm));
            if(dist_cm_int < threshold_cm) then
                RGB_LED <= "10";
            else
                RGB_LED <= "01";
            end if;
        end if;
    end process;

end Behavioral;