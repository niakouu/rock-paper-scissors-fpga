----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.11.2022 21:54:10
-- Design Name: 
-- Module Name: exemple_FSM_mem - Behavioral
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

entity exemple_FSM_mem is
    Port ( CLK, RST : in STD_LOGIC;
           DATA_in : in STD_LOGIC;
           button : in STD_LOGIC;
           DATA_out : out STD_LOGIC);
end exemple_FSM_mem;



architecture Behavioral of exemple_FSM_mem is
    type State is (IGNORE,ACCEPT);

    signal CurState, NextState :  State := IGNORE;
    signal SavedData : STD_LOGIC := '0';
    signal onceRST, onceButton : STD_LOGIC;
    
begin

process(CLK, RST)
begin
    if(RST = '1') then
        CurState <= IGNORE;
    elsif(CLK'event AND CLK = '1') then
        CurState <= NextState;
    end if;
end process;

process(CurState, DATA_in)
begin
    case(CurState) is 
        when IGNORE =>
            DATA_out <= SavedData;
            if(DATA_in = '1') then
                NextState <= ACCEPT;
            else
                NextState <= IGNORE;
            end if;
        when ACCEPT =>
            DATA_out <= SavedData;
            if(DATA_in = '1') then
                NextState <= IGNORE;
            else
                NextState <= ACCEPT;
            end if;
        when others =>
            NextState <= IGNORE;
    end case;
end process;

-- Ce process sert à mettre à jour la valeur sauvegarder, c'est une forme de bascule
process(CLK)
begin
    if(CLK'event and CLK = '1') then
        if(CurState = ACCEPT) then
            SavedData <= DATA_in;
        end if;
    end if;
end process;
end Behavioral;
