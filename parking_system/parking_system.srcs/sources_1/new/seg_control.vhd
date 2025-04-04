----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2025 11:49:52 AM
-- Design Name: 
-- Module Name: seg_control - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity seg_control is
    Port ( US_IN : in STD_LOGIC_VECTOR (8 downto 0);
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           BIN_OUT : out STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           LED_OUT : out STD_LOGIC;
           EN : in std_logic);
end seg_control;

architecture Behavioral of seg_control is

begin
p_seg_control : process (clk) is
variable US_IN : integer := to_integer(unsigned(US_IN)); 
variable digit1 : integer := 0;
variable digit2 : integer := 0;
variable digit3 : integer := 0;

  begin
    if (rising_edge(clk)) and (EN = '1') then
       digit1 := US_IN / 100;
      digit2 : = (US_IN / 10 ) - 100*digit1;
      digit3 : = 
    end if;

  end process p_seg_control;


end Behavioral;
