----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.10.2022 12:42:43
-- Design Name: 
-- Module Name: gestAffichage - Behavioral
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

entity gestAffichage is
    Port ( CLK : in STD_LOGIC;
           DISP0, DISP1, DISP2, DISP3, DISP4, DISP5, DISP6, DISP7 : in std_logic_vector(4 downto 0);
           SEVEN_SEG : out STD_LOGIC_VECTOR (7 downto 0);
           AN : out STD_LOGIC_VECTOR (7 downto 0));
end gestAffichage;

architecture Behavioral of gestAffichage is
    signal count : std_logic_vector(18 downto 0) := "0000000000000000000";

    function to7Seg(val : std_logic_vector(4 downto 0)) return std_logic_vector is
    begin
        case val is
            when "00000" => return "11000000";
            when "00001" => return "11111001";
            when "00010" => return "10100100";
            when "00011" => return "10110000";
            when "00100" => return "10011001";
            when "00101" => return "10010010";
            when "00110" => return "10000010";
            when "00111" => return "11111000";
            when "01000" => return "10000000";
            when "01001" => return "10010000";
            when "01010" => return "10001000";
            when "01011" => return "10000011";
            when "01100" => return "10100111";
            when "01101" => return "10100001";
            when "01110" => return "10000110";
            when "01111" => return "10001110";
            when "10000" => return "10101111";
            when "10001" => return "10001100";
            when "10010" => return "11000110";
            when "11110" => return "10111111";
            when others => return x"FF";
        end case;
    end function;

begin
process(clk)
begin
    if (clk'event and clk = '1') then
        count <= std_logic_vector(unsigned(count)+1);
    end if;
end process;

with count(18 downto 16) select
    SEVEN_SEG <= to7Seg(DISP0) when "000",
                 to7Seg(DISP1) when "001",
                 to7Seg(DISP2) when "010",
                 to7Seg(DISP3) when "011",
                 to7Seg(DISP4) when "100",
                 to7Seg(DISP5) when "101",
                 to7Seg(DISP6) when "110",
                 to7Seg(DISP7) when "111",
                 x"FF" when others;

AN <= "11111111" xor std_logic_vector(to_unsigned(1,8) sll to_integer(unsigned(count(18 downto 16))));

end Behavioral;
