library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity us_control is
    Port(
        TRIG         : out   std_logic := '0';
        ECHO         : in    std_logic := '0';
        DIST_OUT     : out   std_logic_vector (8 downto 0) := (others =>'0') ;
        clk          : in    std_logic;
        switch_pulse : in    std_logic := '0';
        en_load      : out   std_logic := '0'
    );
end us_control;

architecture Behavioral of us_control is
    type state_type is (TRIGGER, READ, SEND, INIT);
    signal state : state_type := INIT;
    constant TRIG_PERIODS : integer := 1000;
    constant ECHO_PERIODS : integer := 4000000;

    signal trig_count : integer range 0 to TRIG_PERIODS;
    signal echo_count : integer range 0 to ECHO_PERIODS;
    signal can_send : STD_LOGIC := '0';
begin
process(clk)
begin
    if(rising_edge(clk)) then
        if(switch_pulse = '1') then
            state <= TRIGGER;
        else
            case state is 
                when TRIGGER=>
                    en_load <= '0';
                    echo_count <= 0;
                    TRIG <= '1';
                    if(trig_count < TRIG_PERIODS) then
                        trig_count <= trig_count + 1;
                    else 
                        trig_count <= 0;
                        TRIG <= '0';
                        state <= READ;
                    end if;
                
                when READ=>
                    if(ECHO = '1') then 
                        can_send <= '1';
                        echo_count <= echo_count + 1;
                    elsif(ECHO = '0' and can_send = '1') then
                        state <= SEND;
                        can_send <='0';
                    end if;
                when SEND =>
                    echo_count <= echo_count/100000;
                    en_load <= '1';
                    DIST_OUT <= STD_LOGIC_VECTOR(TO_UNSIGNED(echo_count, 9));
                when others =>
                    TRIG <= '0';
                    state <= SEND;
            end case;
        end if;
    end if;
end process;
end Behavioral;