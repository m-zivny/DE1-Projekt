library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity trigger_send is
    Port ( TRIG : out STD_LOGIC;
           en : in STD_LOGIC
          );
end trigger_send;

architecture Behavioral of trigger_send is
type   state_type is (UP, DOWN);
    signal state : state_type;

begin
p_trigger_send : process(en) is
begin
if state = DOWN then 
    state <= UP;
else
    state <= DOWN;
end if;

end process p_trigger_send;

TRIG <= '1' when(state = UP) else '0';

end Behavioral;
