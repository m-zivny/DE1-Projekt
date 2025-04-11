----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/14/2025 11:01:13 AM
-- Design Name: 
-- Module Name: simple_counter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity simple_counter is
    generic (
            N_BITS : integer := 16
        );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (N_BITS-1 downto 0));
end simple_counter;



architecture Behavioral of simple_counter is
signal sig_count : std_logic_vector(N_BITS-1 downto 0) := (others => '0');
begin
    process (clk)
    begin
       if rising_edge(clk) then
          if rst='1' then
             sig_count <= (others => '0');
          elsif en='1' then
             sig_count <= sig_count + 1;
          end if;
       end if;
       
    end process;
    count <= sig_count;
    

end Behavioral;
