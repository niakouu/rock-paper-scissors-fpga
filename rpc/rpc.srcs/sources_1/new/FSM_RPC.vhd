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
    
    signal CurState : State := MENU;
    signal NextState : State := PLAYER1;
    signal choice1, choice2 : RPC;
    signal score1 : integer := 0;
    signal score2 : integer := 0;
    
    function player1Wins (choice1 : RPC; choice2 : RPC) return boolean is
        begin
            return (choice1 = SCISSORS AND choice2 = PAPER) OR
                   (choice1 = PAPER AND choice2 = ROCK) OR
                   (choice1 = ROCK AND choice2 = SCISSORS);
        end function;
        
    function playerChoice (choice : RPC; R : STD_LOGIC; P : STD_LOGIC; C : STD_LOGIC) return RPC is
        begin
            if (R = '1') then
                return ROCK;
            elsif (P = '1') then
                return PAPER;
            elsif (C = '1') then
                return SCISSORS;
            else 
                return choice;
            end if;
        end function;
    
    function disChoice (choice : RPC) return STD_LOGIC_VECTOR is
        begin
            case (choice) is
                when ROCK =>
                    return "10000";
                when PAPER =>
                    return "10001";
                when SCISSORS =>
                    return "10010";
                when NEITHER =>
                    return "11110";
            end case;
        end function;
    
    function disWinner (choice1 : RPC; choice2 : RPC) return STD_LOGIC_VECTOR is
        variable whoWins : Winner;
        begin
            if (choice1 = choice2) then
                whoWins := BOTH;
            elsif(player1Wins(choice1, choice2)) then
                whoWins := PLAYER1;
            else 
                whoWins := PLAYER2;
            end if;
            case (whoWins) is
                when PLAYER1 =>
                    return "00001";
                when PLAYER2 =>
                    return "00010";
                when BOTH =>
                    return "01110";
            end case;
        end function;
    
    function disScoreDigit1 (score : integer; length : integer) return STD_LOGIC_VECTOR is
        begin
            return STD_LOGIC_VECTOR(to_unsigned(score mod 16, length));
        end function;
        
    function disScoreDigit2 (score : integer; length : integer) return STD_LOGIC_VECTOR is
        begin
            return STD_LOGIC_VECTOR(to_unsigned(score / 16, length));
        end function;
   
    begin
        process(CLK, RST, V, R, P, C, CurState)
        variable playChoice : RPC := NEITHER;
            begin
                if(RST = '1') then
                    CurState <= MENU;
                    NextState <= PLAYER1;
                    score1 <= 0;
                    score2 <= 0;
                elsif(CLK'event and CLK = '1') then
                    if (V = '1') then
                        CurState <= NextState;
                    end if;
                    case (CurState) is
                        when PLAYER1 =>
                            NextState <= PLAYER2;
                            playChoice := playerChoice(choice1, R, P, C);
                            choice1 <= playChoice;
                            if (playChoice = NEITHER) then
                                NextState <= PLAYER1;
                            end if;
                        when PLAYER2 => 
                            NextState <= CALCULATE;
                            playChoice := playerChoice(choice2, R, P, C);
                            choice2 <= playChoice;
                            if (playChoice = NEITHER) then
                                NextState <= PLAYER2;
                            end if;
                        when CALCULATE =>
                            if( player1Wins(choice1, choice2)) then
                                score1 <= score1 + 1;
                            elsif ( choice1 /= choice2 ) then
                                score2 <= score2 + 1;
                            end if;
                            CurState <= RESULT;
                            NextState <= MENU;
                        when RESULT => 
                            
                        when MENU =>
                            NextState <= PLAYER1;
                            choice1 <= NEITHER;
                            choice2 <= NEITHER;
                    end case;
                end if;
            end process;
    
        process(CurState, choice1, choice2, score1, score2)
        variable tmpValue : STD_LOGIC_VECTOR (4 downto 0);
            begin
                case(CurState) is 
                    when MENU =>
                        Disp0 <= disScoreDigit1(score2, Disp0'length);
                        Disp1 <= disScoreDigit2(score2, Disp1'length);
                        Disp2 <= disScoreDigit1(score1, Disp2'length);
                        Disp3 <= disScoreDigit2(score1, Disp3'length);
                        Disp4 <= "11110";
                        Disp5 <= "11110";
                        Disp6 <= "11110";
                        Disp7 <= "11110";
                    when PLAYER1 =>
                        tmpValue := disChoice(choice1);
                        Disp0 <= tmpValue;
                        Disp1 <= tmpValue;
                        Disp2 <= tmpValue;
                        Disp3 <= tmpValue;
                        Disp4 <= "11110";
                        Disp5 <= "11110";
                        Disp6 <= "00001";
                        Disp7 <= "10001";
                   when PLAYER2 =>
                        tmpValue := disChoice(choice2);
                        Disp0 <= tmpValue;
                        Disp1 <= tmpValue;
                        Disp2 <= tmpValue;
                        Disp3 <= tmpValue;
                        Disp4 <= "11110";
                        Disp5 <= "11110";
                        Disp6 <= "00010";
                        Disp7 <= "10001";
                    when CALCULATE =>
                        
                    when RESULT =>
                        Disp0 <= disScoreDigit1(score2, Disp0'length);
                        Disp1 <= disScoreDigit2(score2, Disp1'length);
                        Disp2 <= disScoreDigit1(score1, Disp2'length);
                        Disp3 <= disScoreDigit2(score1, Disp3'length);
                        Disp4 <= "11110";
                        Disp5 <= disWinner(choice1, choice2);
                        Disp6 <= disChoice(choice2);
                        Disp7 <= disChoice(choice1);
                end case;
            end process;
    end Behavioral;
