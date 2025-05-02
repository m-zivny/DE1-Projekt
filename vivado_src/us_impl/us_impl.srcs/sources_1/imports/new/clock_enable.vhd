library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_1164.all;

entity clock_enable is
    generic (
            N_PERIODS : integer := 25000000
        );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           pulse : out STD_LOGIC);
end clock_enable;

Architecture Behavioral of clock_enable is
signal sig_count : integer range 0 to N_PERIODS-1;
begin
    --! Count the number of clock pulses from zero to N_PERIODS-1.
    p_clk_enable : process (clk) is
    begin

        -- Synchronous proces
        if (rising_edge(clk)) then
            -- if high-active reset then
                -- Clear integer counter
               if rst = '1' then
                    sig_count <= 0; 
               
            -- elsif sig_count is less than N_PERIODS-1 then
                -- Counting
                
               elsif sig_count < (N_PERIODS-1) then
                    sig_count <= sig_count+1;
                    
            -- else reached the end of counter
                -- Clear integer counter
    
               else
                    sig_count <= 0;
                    
               end if;
        end if;

    end process p_clk_enable;

    -- Generated pulse is always one clock long
    -- when sig_count = N_PERIODS-1
    pulse <= '1' when (sig_count = N_PERIODS-1) else '0';


end architecture behavioral;
