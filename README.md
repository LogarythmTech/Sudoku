# Sudoku
[Solve](#solve-puzzle) and/or [Generate](#generate-puzzle) a Sudoku Game.

## Generate Puzzle
Todo

## Solve Puzzle
It solve's the puzzle using the same algoithm's and tactics humans use to solve it. First, for every empty cell, give a list of possible valuse that list can be. 

![Possible Choices](/Images/Possablities/image_0.png)

If there are no value and no possible choice's, the puzzle must be invalid.

These are the algoithms used. My program goes down each item until it can't any more, this is to insure that it does the easier tactics first before doing the more complex one's (just like a normal human would).
* [Singles](#singles)
* [Singlets](#singlets)
* [Pointing Pairs](#pointing-pairs)
* [Box Line Reduction](#box-line-reduction)
* [Obvious Pairs](#obvious-pairs)
* [Obvious Triplets](#obvious-triplets)
* [X-Wing](#x-wing)
* [Bowman's Bingo](#bowmans-bingo)

### Singles
If there are only one possible choice for a certian cell, then the cell's valuse must be that last possible choice.

**Example:**

In the highlighted cell, there is only one possible choice.

![Singles Before](/Images/Singles/image_0.png)

So we give that cells value that possiblity.

![Singles After](/Images/Singles/image_1.png)

### Singlets
Each row, col, or group must have one of each number (1-9), thus if in the possiblies, a row only has one cell that have the possablity to be an certian number, then that cell *must* be that certian number. This works for cols and groups the same.

**Example:**

In the highlighted col (blue), only the highlighted (yellow) cell has a possablity of being a one. 

![Singlets Before](/Images/Singlets/image_0.png)

Thus, the highlighted (yellow) cell, must have a value of one.

![Singlets After](/Images/Singlets/image_1.png)

### Pointing Pairs
When in a group, if there is only 2-3 possible choices for a certian number *and* all of these possiblities line up in a row or col. Then the rest of the row/col (the part that does not belong to the group) does not have the possiblity to be said number.

**Example:**

The highlighted cells are the only ones in their group that has a possiblity to be a three. Thus, for said group, the three must be one of the two cells.

![Pointing Pairs Before](/Images/Pointing_Pairs/image_0.png)

Since the two cells are also in the same row, it means that the three for that row, must be in that group so the other cells along that row (excluding the two in the group) can't be three, so we remove that from the possblities. Notice the highlighed cells now don't have a possiblity of being three, when origally there had. 

![Pointing Pairs After](/Images/Pointing_Pairs/image_1.png)

### Box Line Reduction
Similir to Pointing Pairs, except reverse.

When in a row or col, if there all the possablities for a certian number, lie in the same group, then for the rest of the group (the part that is not in the row / col) can't have a possablity to be said number.

**Example:**

Notice, that in the highlighted col, the only cells that have a possiblity of being three (in yellow) are in the same group.

![Box Line Reduction Before](/Images/Box_Line_Reduction/image_0.png)

Since one of the two (blue) cells above have to be three, the others cells in the same group, can't be a three, such as the (yellow) cell.

![Box Line Reduction After](/Images/Box_Line_Reduction/image_1.png)

### Obvious Pairs
When is the same row, col, or group, if there is a pair of cells that have the same two possiblites, then those two cells must be one of those two options, making the others in the same row, col, or group (which other one that the pair is the same) can't be one of those two options thus, we can remove that as an possablity.

**Example:**

Notice the highlighed (blue) cells, have the same two possablites, five or three, *and* they lie in the same row.

![Obvious Pairs Before](/Images/Obvious_Pairs/image_0.png)

This means that the other cells in the row, pertically the (yellow) cells, can't be a five or a three.

![Obvious Pairs After](/Images/Obvious_Pairs/image_1.png)

### Obvious Triplets
Similar to Obvious Pairs, just three instead of two.

When is the same row, col, or group, if there is a triplet (3) of cells that have the same three possiblites (or have two of the three), then those three cells must be one of those three options, making the others in the same row, col, or group (which other one that the triplet is the same) can't be one of those three options thus, we can remove that as an possablity.

**Example:**

Notice the highlighed (yellow) cells lie in the same row and can be a two, three, eight and nothing else.

![Obvious Triplets Before](/Images/Obvious_Triplets/image_0.png)

This means that the other cells in the row, like the (blue) cells, can not be a two, three, eight, so we remove that as a possablity.

![Obvious Triplets After](/Images/Obvious_Triplets/image_1.png)


### X-Wing
If in two different columns (or row) there is a number that only has a possablity in two cells per col, and that each of the two cells match the same row (or group) as the other ones in the different column. There for the rest of said rows (or cols) can't have said number.

**Example:**

Notice the highlighed (blue) cells lie in the same col and only are the only ones in their col that have the possablity of being four. The same applies to the (yellow) cells. Also notice that the (yellow) cells match the row index of the (blue) cells.

![X-Wing Before](/Images/X-Wing/image_0.png)

Thus creating an "X" (blue and green lines).

![Create an X](/Images/X-Wing/image_1.png)

Since a four must lie in two of the four cells, and it must be they must be on diffent rows, for the rest of the cells on the two rows, highlighted (red), can not be a four.

![X-Wing After](/Images/X-Wing/image_2.png)

### Bowman's Bingo
Bowman's Bingo is used when you can't use any of the above tactics anymore, thus you ecentially guess and check. If the puzzel turns invalid by your guess (such as have a cell that has no value but has no possible choices either), then you know that your guess was wrong allowing you to remove that guess for the possible choices for that cell. If your guess is right, you don't need to do anything, and finish the puzzel.

**Example:**

You get to here with above algoithms and can't go anymore. So you choses a random cell (highlighted yellow) (perveribly one with only two possiblites)

![Stuck](/Images/Bowmans_Bingo/image_0.png)

Then, you set that cell's (highlighted yellow) value's to be one of the possiblites.

![Guess and Check](/Images/Bowmans_Bingo/image_1.png)

Contine solving with above tactics (red text). You then get two choices, either the puzzle gets solved (you guessed correctly) or, in this case, you get an invalid board, notice the empty cell (highlighted yellow).

![Invalid](/Images/Bowmans_Bingo/image_2.png)

You know that the guess was wrong, thus you reset back to the before your guess (remove the valuse that are in red), then you can delete that possiblity for that cell (highlighted yellow).

![Remove](/Images/Bowmans_Bingo/image_3.png)

The reason you want to prioities a cell that has two possiblities first, is that now that cell (highlighted yellow) only has one possilbity, allowing you to know the value for that cell.

![Yay!!](/Images/Bowmans_Bingo/image_4.png)
