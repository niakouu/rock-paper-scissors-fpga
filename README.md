# Rock Paper Scissors on an FPGA

This VHDL project aims to implement a Rock Paper Scissors game on an FPGA platform. The system includes five buttons (R, P, C, V, and RST) and eight 7-segment displays for providing visual feedback during the game. The implementation involves creating a state machine to manage the game flow and integrating various modules for button debouncing, pulse generation, and display management.

Link on its implementation demo : https://youtube.com/shorts/TjoNQv_f1WM?feature=share

## Game Flow

The game follows a structured flow:

1. The initial display shows the current scores for both players on the four rightmost 7-segment displays (e.g., "- - - - 1F 0E" indicates player 1 has a score of 31, and player 2 has a score of 14). The system awaits the press of the V button to initiate a new game.

2. Player 1 selects Rock, Paper, or Scissors using the R, P, and C buttons. The choice is displayed on the screen (e.g., "P1 rrrr"). The selection can be modified, and upon confirmation with the V button, the system proceeds to the next step.

3. Player 2 makes a similar choice using the R, P, and C buttons, with the selection displayed on the screen (e.g., "P2 rrrr"). Confirmation is done by pressing the V button.

4. The system evaluates the choices, displays the result (1 for player 1 victory, 2 for player 2 victory, E for a tie), and allows the option to restart by pressing V. Scores are updated on the rightmost 7-segment displays.

Note that at any point, pressing the RST button resets the game to its initial state.

## Installation

Install the TopLevelDesign.bit file to program an Digilent Basys3 Xilinx Artix-7 FPGA Board.

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)
