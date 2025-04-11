----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2025 12:05:50 PM
-- Design Name: 
-- Module Name: top_level - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_level is
    Port ( TRIG : out STD_LOGIC;
           ECHO : in STD_LOGIC;
           OUT_NUM : out STD_LOGIC_VECTOR (15 downto 0);
           CLK100MHZ : in STD_LOGIC;
           BTNC: in STD_LOGIC);
end top_level;

architecture Behavioral of top_level is

     -- Component declaration for clock enable
    component clock_enable is
       generic (
                N_PERIODS : integer := 10_000
            );
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               pulse : out STD_LOGIC); 
    end component;
    
    component trigger_send is
        Port(
           TRIG : out STD_LOGIC;
           en : in STD_LOGIC
         );
     end component;
     signal sig_en : std_logic;
begin

clock_en : clock_enable
     generic map(
        N_PERIODS => 10_000
    )
    port map (
        clk => CLK100MHZ,
        rst => BTNC,
        pulse => sig_en
    );
    
    


end Behavioral;
