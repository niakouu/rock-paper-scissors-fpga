----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/13/2023 10:40:12 AM
-- Design Name: 
-- Module Name: PulseGen - Behavioral
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

--Synchronisation, generation of one pulse;

entity PulseGen is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           E : in STD_LOGIC;
           S : out STD_LOGIC);
end PulseGen;

architecture Behavioral of PulseGen is
    type State is (WAITING,ACCEPT);
    signal CurState : State := ACCEPT;
begin
    process(CLK, RST)
        begin
            if(RST = '1') then
                S <= '0';
                CurState <= ACCEPT;
            elsif(CLK'event AND CLK = '1') then
                case CurState is
                    when ACCEPT =>
                        if (E = '1') then
                            S <= '1';
                            CurState <= WAITING;
                        else
                            S <= '0';
                        end if;
                    when WAITING =>
                        if (E = '1') then
                            S <= '0';
                        else 
                            CurState <= ACCEPT;
                        end if;
                end case;
            end if;
        end process;
end Behavioral;
