----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/27/2023 09:52:02 AM
-- Design Name: 
-- Module Name: TopLvlDesign - Behavioral
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

entity TopLvlDesign is
    Port ( CLK : in STD_LOGIC;
           V : in STD_LOGIC;
           R : in STD_LOGIC;
           P : in STD_LOGIC;
           C : in STD_LOGIC;
           RST : in STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           SEVEN_SEG : out STD_LOGIC_VECTOR (7 downto 0));
end TopLvlDesign;

architecture Behavioral of TopLvlDesign is

    component DEBOUNCE IS
      GENERIC(
        counter_size  :  INTEGER := 19); --counter size (19 bits gives 10.5ms with 50MHz clock)
      PORT(
        clk     : IN  STD_LOGIC;  --input clock
        button  : IN  STD_LOGIC;  --input signal to be debounced
        result  : OUT STD_LOGIC); --debounced signal
    END component;
    
    component PulseGen is
        Port ( CLK : in STD_LOGIC;
               RST : in STD_LOGIC;
               E : in STD_LOGIC;
               S : out STD_LOGIC);
    end component;
    
    component FSM_RPC is
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
    end component;
    
    component gestAffichage is
        Port ( CLK : in STD_LOGIC;
               DISP0, DISP1, DISP2, DISP3, DISP4, DISP5, DISP6, DISP7 : in std_logic_vector(4 downto 0);
               SEVEN_SEG : out STD_LOGIC_VECTOR (7 downto 0);
               AN : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    signal result_debounce, S_pulseGen : STD_LOGIC;
    signal disp0, disp1, disp2, disp3, disp4, disp5, disp6, disp7 : STD_LOGIC_VECTOR (4 downto 0);

begin
    Debounce_0 : DEBOUNCE port map (
            clk => CLK, button => V, result => result_debounce);
            
    PulseGen_0 : PulseGen port map (
            CLK => CLK, RST => RST, E => result_debounce, S => S_pulseGen);
            
    FSM_RPC_0 : FSM_RPC port map (
            V => S_pulseGen, R => R, P => P, C => C, RST => RST, CLK => CLK,
            Disp0 => disp0, Disp1 => disp1, Disp2 => disp2, Disp3 => disp3, 
            Disp4 => disp4, Disp5 => disp5, Disp6 => disp6, Disp7 => disp7);
            
    GestAffichage_0 : gestAffichage port map (
            CLK => CLK, DISP0 => disp0, DISP1 => disp1, DISP2 => disp2,
            DISP3 => disp3, DISP4 => disp4, DISP5 => disp5, DISP6 => disp6,
            DISP7 => disp7, SEVEN_SEG => SEVEN_SEG, AN => AN);

end Behavioral;
