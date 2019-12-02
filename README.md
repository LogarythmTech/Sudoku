# Sudoku
Solve an Sudoku Game


## How the solving algorithm works 
Each cell is sets an array of possible intergers \[1-9\] that could go there. It then filters out the posiblites using different methods. When the array of possible choice gets to the lenght of one, we can determine that that is the number for that cell.

* [Singles]()
* [Singlets]()
* [Pointing Pairs]()
* [Box Line Reduction]()
* [Obvious Pairs]()
* [Obvious Triplets]()
* [X-Wing]()
* [Bowman's Bingo]()

### Singles

### Singlets
This is when the row, col, or group only has one certain number in the whole row, col, or group

### Pointing Pairs

### Box Line Reduction

### Obvious Pairs

### Obvious Triplets

### X-Wing

### Bowman's Bingo
If you start with...

![Start](/Images/Bowmans_Bingo/image_0.png)

You get to here with above algoithms and can't go anymore. 

![Stuck](/Images/Bowmans_Bingo/image_1.png)

So you use Bowman's Bingo. You chose a random cell (perveribly one with only two possiblites) and chose one of possiblites for that cells value.

![Guess and Check](/Images/Bowmans_Bingo/image_2.png)

Then you contine solving. You then get two choices, either the puzzle gets solved (you guessed correctly) or, in this case, you get an invalid board.

![Invalid](/Images/Bowmans_Bingo/image_3.png)

When this happens you, know that the guess was wrong, thus you can delete that possiblity for that cell.

![Remove](/Images/Bowmans_Bingo/image_4.png)

The reason you want to prioities a cell that has two possiblities first, is that now that cell only has one possilbity, allowing you to know the value for that cell

![Yay!!](/Images/Bowmans_Bingo/image_5.png)
