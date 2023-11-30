----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/13/2023 10:42:38 AM
-- Design Name: 
-- Module Name: FSM_RPC - Behavioral
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

entity FSM_RPC is
    Port ( V : in STD_LOGIC;
           R : in STD_LOGIC;
           P : in STD_LOGIC;
           C : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           Disp0 : out STD_LOGIC_VECTOR (4 downto 0);
           Disp1 : out STD_LOGIC_VECTOR (4 downto 0);
           Disp2 : out STD_LOGIC_VECTOR (4 downto 0);
           Disp3 : out STD_LOGIC_VECTOR (4 downto 0);
           Disp4 : out STD_LOGIC_VECTOR (4 downto 0);
           Disp5 : out STD_LOGIC_VECTOR (4 downto 0);
           Disp6 : out STD_LOGIC_VECTOR (4 downto 0);
           Disp7 : out STD_LOGIC_VECTOR (4 downto 0));
end FSM_RPC;

architecture Behavioral of FSM_RPC is
    type State is (MENU, PLAYER1, PLAYER2, CALCULATE, RESULT);
    type RPC is (ROCK, PAPER, SCISSORS, NEITHER);
    type Winner is (PLAYER1, PLAYER2, BOTH);
    
    signal NextState, CurState : State := MENU;
    signal choice1, choice2 : RPC;
    signal whoWins : Winner;
    signal tmpValue : STD_LOGIC_VECTOR (4 downto 0);
    signal score1 : integer := 0;
    signal score2 : integer := 0;
    
begin

process(CLK, RST, V, R, P, C, CurState)
begin
    if(RST = '1') then
        CurState <= MENU;
        score1 <= 0;
        score2 <= 0;
        choice1 <= NEITHER;
        choice2 <= NEITHER;
    elsif(CLK'event and CLK = '1') then
        if (V = '1') then
            CurState <= NextState;
        end if;
        case (CurState) is
            when PLAYER1 =>
                if (R = '1') then
                    choice1 <= ROCK;
                elsif (P = '1') then
                    choice1 <= PAPER;
                elsif (C = '1') then
                    choice1 <= SCISSORS;
                end if;
            when PLAYER2 => 
                if (R = '1') then
                    choice2 <= ROCK;
                elsif (P = '1') then
                    choice2 <= PAPER;
                elsif (C = '1') then
                    choice2 <= SCISSORS;
                end if;
            when CALCULATE =>
                if (choice1 = choice2) then
                    whoWins <= BOTH;
                elsif((choice1 = SCISSORS AND choice2 = PAPER) OR
                   (choice1 = PAPER AND choice2 = ROCK) OR
                   (choice1 = ROCK AND choice2 = SCISSORS)) then
                    whoWins <= PLAYER1;
                    score1 <= score1 + 1;
                else 
                    whoWins <= PLAYER2;
                    score2 <= score2 + 1;
                end if;
                CurState <= RESULT;
            when RESULT => 
                
            when MENU =>
                choice1 <= NEITHER;
                choice2 <= NEITHER;
        end case;
    end if;
end process;

process(CurState, choice1, choice2, score1, score2)
begin
    NextState <= CurState;
    case(CurState) is 
        when MENU =>
            NextState <= PLAYER1;
            Disp0 <= std_logic_vector(to_unsigned(score2 mod 16, Disp0'length));
            Disp1 <= std_logic_vector(to_unsigned(score2 / 16, Disp1'length));
            Disp2 <= std_logic_vector(to_unsigned(score1 mod 16, Disp2'length));
            Disp3 <= std_logic_vector(to_unsigned(score1 / 16, Disp3'length));
            Disp4 <= "11110";
            Disp5 <= "11110";
            Disp6 <= "11110";
            Disp7 <= "11110";
        when PLAYER1 =>
            NextState <= PLAYER2;
            Disp4 <= "11110";
            Disp5 <= "11110";
            Disp6 <= "00001";
            Disp7 <= "10001";
            case (choice1) is
                when ROCK =>
                    tmpValue <= "10000";
                when PAPER =>
                    tmpValue <= "10001";
                when SCISSORS =>
                    tmpValue <= "10010";
                when NEITHER =>
                    NextState <= PLAYER1;
                    tmpValue <= "11110";
            end case;
            Disp0 <= tmpValue;
            Disp1 <= tmpValue;
            Disp2 <= tmpValue;
            Disp3 <= tmpValue;
       when PLAYER2 =>
            NextState <= CALCULATE;
            Disp4 <= "11110";
            Disp5 <= "11110";
            Disp6 <= "00010";
            Disp7 <= "10001";
            case (choice2) is
                when ROCK =>
                    tmpValue <= "10000";
                when PAPER =>
                    tmpValue <= "10001";
                when SCISSORS =>
                    tmpValue <= "10010";
                when NEITHER =>
                    NextState <= PLAYER2;
                    tmpValue <= "11110";
           end case;
           Disp0 <= tmpValue;
           Disp1 <= tmpValue;
           Disp2 <= tmpValue;
           Disp3 <= tmpValue;
        when CALCULATE =>
            
        when RESULT =>
            NextState <= MENU;
            Disp0 <= std_logic_vector(to_unsigned(score2 mod 16, Disp0'length));
            Disp1 <= std_logic_vector(to_unsigned(score2 / 16, Disp1'length));
            
            Disp2 <= std_logic_vector(to_unsigned(score1 mod 16, Disp2'length));
            Disp3 <= std_logic_vector(to_unsigned(score1 / 16, Disp3'length));
            
            Disp4 <= "11110";
            
            case (choice1) is
                when ROCK =>
                    Disp7 <= "10000";
                when PAPER =>
                    Disp7 <= "10001";
                when SCISSORS =>
                    Disp7 <= "10010";
                when NEITHER =>
                    Disp7 <= "11110";
            end case;
            case (choice2) is
                when ROCK =>
                    Disp6 <= "10000";
                when PAPER =>
                    Disp6 <= "10001";
                when SCISSORS =>
                    Disp6 <= "10010";
                when NEITHER =>
                    Disp6 <= "11110";
            end case;
            case (whoWins) is
                when PLAYER1 =>
                    Disp5 <= "00001";
                when PLAYER2 =>
                    Disp5 <= "00010";
                when BOTH =>
                    Disp5 <= "01110";
            end case;
    end case;
end process;

end Behavioral;
