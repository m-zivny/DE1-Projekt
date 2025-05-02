library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity us_control is
    Port(
        TRIG         : out   std_logic := '0';
        ECHO         : in    std_logic := '0';
        DIST_OUT     : out   std_logic_vector (8 downto 0) := (others =>'0') ;
        clk          : in    std_logic;
        en_load      : out   std_logic := '0';
        switch_pulse : in std_logic := '0';
        continue     : in std_logic := '0';
        RST          : in std_logic := '0'
    );
end us_control;

architecture Behavioral of us_control is
    type state_type is (TRIGGER, READ, SEND, IDLE);
    signal state : state_type := IDLE;
    constant TRIG_PERIODS : integer := 1000;
    constant ECHO_PERIODS : integer := 4000000;

    signal trig_count : integer range 0 to TRIG_PERIODS;
    signal echo_count : integer range 0 to ECHO_PERIODS;
    signal can_send : STD_LOGIC := '0';
    signal was_sent : STD_LOGIC := '0';
begin
process(clk)
begin
    if(rising_edge(clk)) then
        if(rst = '1') then
            state <= IDLE;
            TRIG <= '0';
            DIST_OUT <= (others =>'0');
            en_load <= '0';
            trig_count <= 0;
        end if;

            case state is 
                when TRIGGER=>
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
                    elsif((ECHO = '0' or echo_count > ECHO_PERIODS) and can_send = '1') then
                        echo_count <= echo_count/5800;
                        state <= SEND;
                        can_send <='0';
                    end if;
                when SEND =>
                    en_load <= '1';
                    DIST_OUT <= STD_LOGIC_VECTOR(TO_UNSIGNED(echo_count, 9));
                    if continue = '1' then
                    state <= IDLE;
                    end if;

                when IDLE =>
                    en_load <= '0';
                    echo_count <= 0;
                     if switch_pulse = '1' then
                        state <= TRIGGER;
                     end if;
                when others =>
                    TRIG <= '0';
                    state <= IDLE;
            end case;
    end if;
end process;
end Behavioral;