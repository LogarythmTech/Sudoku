//
//  Sukoku.swift
//  Sudoku
//
//  Created by Logan Richards on 11/30/19.
//  Copyright © 2019 ZER0 Tech. All rights reserved.
//

import SwiftUI
import Foundation

enum Difficulty {
	case Easy, Medium, Hard, Expert
}

enum GameMode {
	case Create, Play, Bingo
}

struct SudokuCell {
	var number: Int = 0 {
		didSet {
			didChange = true
		}
	}
	var pos: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9] {
		didSet {
			didChange = true
		}
	}
	var didChange: Bool = false
	
	var backgroundColor: Color = .white
	var foregroundColor: Color = .blue
	
	var hideNotes: Bool = false
	
	func getHide() -> [Bool] {
		var hide: [Bool] = [true, true, true, true, true, true, true, true, true]
		
		if(hideNotes) {
			return hide
		}
		
		for i in pos {
			if((i-1) < hide.count && (i) > 0) {
				hide[i-1] = false
			}
		}
		
		return hide
	}
}

/**
Takes in / or generates a sudoku puzzel, then shows how to solve the puzzel
*/
class Sudoku : ObservableObject {
	@Published var board: [[SudokuCell]]
	@Published var hideNotes = true {
		didSet {
			for row in 0..<board.count {
				for col in 0..<board[row].count {
					board[row][col].hideNotes = hideNotes
				}
			}
		}
	}
	@Published var lastMove: String = "No Last Move"
	
	var currentColor: Color = .black
	
	var isSolved: Bool {
		get {
			for row in 0..<self.board.count {
				for col in 0..<self.board[row].count {
					if(self.board[row][col].number == 0) {
						return false
					}
				}
			}
			return true
		}
	}
	
	var isValid: Bool {
		get {
			for row in 0..<self.board.count {
				for col in 0..<self.board[row].count {
					if(board[row][col].number == 0 && board[row][col].pos.count == 0) {
						return false
					}
				}
			}
			
			return true
		}
	}
	
	var didChange: Bool {
		get {
			for row in 0..<self.board.count {
				for col in 0..<self.board[row].count {
					if(board[row][col].didChange) {
						 return true
					}
				}
			}
			return false
		}
	}
	
	//Rows <->
	//Cols ^
	
	//MARK: - Initializers
	init() {
		board = [[SudokuCell]]()
		
		wipeBoard()
	}
	
	init(board: [[SudokuCell]]) {
		self.board = [[SudokuCell]]()
		
		for _ in 0..<9 {
			var row = [SudokuCell]()
			for _ in 0..<9 {
				row.append(SudokuCell())
			}
			
			self.board.append(row)
		}
		
		for row in 0..<board.count {
			for col in 0..<board.count {
				setCell(row: row, col: col, to: board[row][col].number)
			}
		}
		
		
	}
		
	//MARK: - Save
	var saveState: [[[SudokuCell]]] = [[[SudokuCell]]]()
	
	func save() {
		saveState.append(self.board)
	}
	
	func wipeSave() {
		saveState = [[[SudokuCell]]]()
	}
	
	func restoreBoard() {
		if let lastSave = saveState.last  {
			board = lastSave
			
			//If you hide then reset, the hide will stay true but not in each cell, thus we reset hideNotes inorder to make sure hideNotes in each cell is updated
			if(hideNotes) {
				hideNotes = true
			} else {
				hideNotes = false
			}
			
			if(saveState.count > 1) {
				saveState.removeLast()
			}
		} else {
			board = [[SudokuCell]]()
			for _ in 0..<9 {
				var row = [SudokuCell]()
				for _ in 0..<9 {
					row.append(SudokuCell())
				}
				
				board.append(row)
			}
			
			gererate(difficulty: .Easy, given: 60)
		}
	}
	
	func resetBoard() {
		if let firstSave = saveState.first  {
			board = firstSave
			saveState = [board]
		} else {
			wipeBoard()
		}
		
		//If you hide then reset, the hide will stay true but not in each cell, thus we reset hideNotes inorder to make sure hideNotes in each cell is updated
		if(hideNotes) {
			hideNotes = true
		} else {
			hideNotes = false
		}
		
		setGameModeToPlay()
		lastMove = "No Last Move"
	}
	
	func wipeBoard() {
		board = [[SudokuCell]]()
		for _ in 0..<9 {
			var row = [SudokuCell]()
			for _ in 0..<9 {
				row.append(SudokuCell())
			}
			
			board.append(row)
		}
		setGameModeToCreate()
	}
	
	//MARK: - Generate
	
	/**
	Generate a new Sudoku Puzzel
	
	- parameters:
		- difficulty: The difficulty level of the new generated sudoku puzzel
		- given: How much to try to remove
	- Attention: given is not the actuall number that will be removed, but rather how many tries to remove
	*/
	func gererate(difficulty: Difficulty, given: Int) {
		wipeBoard()
		
		setGameModeToCreate()
		solve()
		
		for _ in 0..<given {
			save()
			let randomCell: (Int, Int)? = randomSolvedCell()
			if let cell = randomCell {
				removeCell(row: cell.0, col: cell.1)
				resetPos()
				
				save()
				let didSolve: Bool = solveWith(difficulty: difficulty)
				restoreBoard() //Goes back to right before didSolve
				if(!didSolve) {
					restoreBoard() //Goes back to before we placed the random Cell
				}
			}
		}
		
		wipeSave()
		
		for row in 0..<board.count {
			for col in 0..<board[row].count {
				board[row][col].foregroundColor = .black
			}
		}
		
		save()
		setGameModeToPlay()
	}
	
	//MARK: - Game Modes
	func setGameModeToCreate() {
		currentColor = .black
	}
	
	func setGameModeToPlay() {
		currentColor = .blue
	}
	
	func setGameModeToBingo() {
		currentColor = .red
	}
	
	
	
	//MARK: - Solve
	func solve() {
		setGameModeToPlay()
		while !isSolved {
			stepSolve()
		}
		
		if(isSolved) {
			for row in 0..<board.count {
				for col in 0..<board.count {
					if(board[row][col].foregroundColor == .red) {
						board[row][col].foregroundColor = .blue
					}
				}
			}
		}
	}
	func stepSolve() {
		if(isSolved) {
			for row in 0..<board.count {
				for col in 0..<board.count {
					if(board[row][col].foregroundColor == .red) {
						board[row][col].foregroundColor = .blue
					}
				}
			}
			
			return
		}
		
		if(!isValid) {
			lastMove = "Bowman's Bingo End";
			bowmansBingoCont()
			return
		}
		
		resetDidChange()
		filterAllSingles()
		if(didChange) {lastMove = "Single"; return}
		filterAllSinglets()
		if(didChange) {lastMove = "Singlets";return}
		filterAllBoxLineReduction()
		if(didChange) {lastMove = "Box Line Reduction"; return}
		filterAllPointingPairs()
		if(didChange) {lastMove = "Pointing Pairs"; return}
		filterAllObviousPairs()
		if(didChange) {lastMove = "Obvious Pairs"; return}
		filterAllObviousTriplets()
		if(didChange) {lastMove = "Obvious Triplets"; return}
		filterAllXWing()
		if(didChange) {lastMove = "X Wing"; return}
		
		if(!didChange) {
			lastMove = "Bowman's Bingo";
			bowmansBingo()
		}
	}
	
	//MARK: Generate Tests
	
	/**
	Solve the puzzel while only using certain algorithms determined by difficulty level
	
	- parameters:
		- difficulty: The difficulty level of the new generated sudoku puzzel as well as what algoriths can be used to solve said puzzel.
			- **Easy:**
				- Singles
				- Singlets
			- **Medium:**
				- Singles
				- Singlets
				- Box Line Reduction
				- Pointing Pairs
			- **Hard:**
				- Singles
				- Singlets
				- Box Line Reduction
				- Pointing Pairs
				- Obvious Doubles
				- Obvious Triplets
			- **Evil:**
				- Singles
				- Singlets
				- Box Line Reduction
				- Pointing Pairs
				- Obvious Doubles
				- Obvious Triplets
				- X-Wing
				- Bowman's Bingo (But only one)
	- returns:
		- **True:**  If can be solved
		- **False:** If can't be solved
	*/
	func solveWith(difficulty: Difficulty) -> Bool {
		var countBowmans: Int = 0
		
		repeat {
			if(isSolved) {
				return true
			}
			
			if(!isValid) {
				if(difficulty == .Expert) {
					bowmansBingoCont()
					continue
				} else {
					return false
				}
			}
			
			resetDidChange()
			filterAllSingles()
			if(didChange) {continue}
			
			filterAllSinglets()
			if(didChange || difficulty == .Easy) {continue}
			
			filterAllBoxLineReduction()
			if(didChange) {continue}
			
			filterAllPointingPairs()
			if(didChange || difficulty == .Medium) {continue}
			
			filterAllObviousPairs()
			if(didChange) {continue}
			
			filterAllObviousTriplets()
			if(didChange || difficulty == .Hard) {continue}
			
			filterAllXWing()
			if(didChange) {continue}
			
			if(countBowmans < 2) {
				bowmansBingo()
				countBowmans += 1
			}
			
			
			
			
		} while didChange
		
		if(isSolved) {
			return true
		}
		
		return false
	}
	
	//MARK: Singles
	//Any cell where there is only one pos
	func filterAllSingles() {
		for i in 0..<board.count {
			for j in 0..<board[i].count {
				filterSingles(row: i, col: j)
			}
		}
	}
	func filterSingles(row: Int, col: Int) {
		if(board[row][col].number == 0 && board[row][col].pos.count == 1) {
			setCell(row: row, col: col, to: board[row][col].pos[0])
		}
	}
	
	//MARK: Singlets (Last Remaining Cell)
	//When a row only has 1 in the possiblites
	func filterAllSinglets() {
		for i in 0..<board.count {
			filterSinglets(row: i)
			filterSinglets(col: i)
			filterSinglets(group: i)
		}
	}
	func filterSinglets(row: Int) {
		var countNums = [0, 0, 0, 0, 0, 0, 0, 0, 0]
		
		for col in 0..<board[row].count {
			for pos in board[row][col].pos {
				countNums[pos-1] += 1
			}
		}
		
		for i in 0..<countNums.count {
			if(countNums[i] == 1) {
				for col in 0..<board[row].count {
					if(board[row][col].pos.contains(i + 1)) {
						setCell(row: row, col: col, to: i+1)
					}
				}
			}
		}
	}
	func filterSinglets(col: Int) {
		var countNums = [0, 0, 0, 0, 0, 0, 0, 0, 0]
		
		for row in 0..<board.count {
			for pos in board[row][col].pos {
				countNums[pos-1] += 1
			}
		}
		
		for i in 0..<countNums.count {
			if(countNums[i] == 1) {
				for row in 0..<board.count {
					if(board[row][col].pos.contains(i + 1)) {
						setCell(row: row, col: col, to: i+1)
					}
				}
			}
		}
	}
	func filterSinglets(group: Int) {
		var countNums = [0, 0, 0, 0, 0, 0, 0, 0, 0]
		
		for i in 0..<(board.count/3) {
			for j in 0..<(board[i].count/3) {
				let row = i + (group / 3) * 3
				let col = j + (group % 3) * 3
				for pos in board[row][col].pos {
					countNums[pos-1] += 1
				}
			}
		}
		
		for i in 0..<countNums.count {
			if(countNums[i] == 1) {
				for j in 0..<(board.count/3) {
					for k in 0..<(board[i].count/3) {
						let row = j + (group / 3) * 3
						let col = k + (group % 3) * 3
						if(board[row][col].pos.contains(i + 1)) {
							setCell(row: row, col: col, to: i+1)
						}
					}
				}
			}
		}
	}
	
	//MARK: Obvious Pairs
	func filterAllObviousPairs() {
		for i in 0..<board.count {
			filterObviousPairs(row: i)
			filterObviousPairs(col: i)
			filterObviousPairs(group: i)
		}
	}
	func filterObviousPairs(row: Int) {
		var posCount: [[Int] : [Int]] = [[Int] : [Int]]()
		
		for col in 0..<board[row].count {
			if(board[row][col].pos.count == 2) {
				if let _ = posCount[board[row][col].pos] {
					posCount[board[row][col].pos]?.append(col)
				} else {
					posCount[board[row][col].pos] = [col]
				}
			}
		}
		
		for x in posCount {
			if(x.value.count == 2) {
				removeFrom(row: row, remove: x.key, exclude: x.value)
			}
		}
	}
	func filterObviousPairs(col: Int) {
		var posCount: [[Int] : [Int]] = [[Int] : [Int]]()
		
		for row in 0..<board.count {
			if(board[row][col].pos.count == 2) {
				if let _ = posCount[board[row][col].pos] {
					posCount[board[row][col].pos]?.append(row)
				} else {
					posCount[board[row][col].pos] = [row]
				}
			}
		}
		
		for x in posCount {
			if(x.value.count == 2) {
				removeFrom(col: col, remove: x.key, exclude: x.value)
			}
		}
	}
	func filterObviousPairs(group: Int) {
		var posCount: [[Int] : [Int]] = [[Int] : [Int]]()
		
		for i in 0..<(board.count/3) {
			for j in 0..<(board[i].count/3) {
				let row = i + (group / 3) * 3
				let col = j + (group % 3) * 3
				
				if(board[row][col].pos.count == 2) {
					if let _ = posCount[board[row][col].pos] {
						posCount[board[row][col].pos]?.append(i*3 + j)
					} else {
						posCount[board[row][col].pos] = [i*3 + j]
					}
				}
			}
		}
		
		for x in posCount {
			if(x.value.count == 2) {
				removeFrom(group: group, remove: x.key, exclude: x.value)
			}
		}
	}
	
	//MARK: Obvious Triplets
	func filterAllObviousTriplets() {
		for i in 0..<board.count {
			filterObviousTriplets(row: i)
			filterObviousTriplets(col: i)
			filterObviousTriplets(group: i)
		}
	}
	func filterObviousTriplets(row: Int) {
		var posCount: [[Int] : [Int]] = [[Int] : [Int]]()
		
		for col in 0..<board[row].count {
			if(board[row][col].pos.count == 2 || board[row][col].pos.count == 3) {
				if let _ = posCount[board[row][col].pos] {
					posCount[board[row][col].pos]?.append(col)
				} else {
					posCount[board[row][col].pos] = [col]
				}
			}
		}
		
		var arr_key: [Int] = [Int]()
		
		for x in posCount {
			for y in x.key {
				if(!arr_key.contains(y)) {
					arr_key.append(y)
				}
				
			}
		}
		
		if(arr_key.count < 3) {
			return
		}
		
		var pos_keys: [[Int]] = [[Int]]()
		
		for i in 0..<(arr_key.count - 2) {
			for j in (i+1)..<(arr_key.count - 1) {
				for k in (j+1)..<arr_key.count {
					pos_keys.append([arr_key[i], arr_key[j], arr_key[k]])
				}
			}
		}
		
		var newDic: [[Int] : [Int]] = [[Int] : [Int]]()
		
		for key in pos_keys {
			for x in posCount {
				var contains: Int = 0
				for y in x.key {
					if(key.contains(y)) {
						contains += 1
					}
				}
				
				if((x.key.count == 2 && contains > 1) || (x.key.count == 3 && contains > 2)) {
					for y in x.value {
						if let _ = newDic[key] {
							newDic[key]?.append(y)
						} else {
							newDic[key] = [y]
						}
					}
				}
			}
		}
		
		for x in newDic {
			if(x.value.count == 3) {
				removeFrom(row: row, remove: x.key, exclude: x.value)
			}
		}
	}
	func filterObviousTriplets(col: Int) {
		var posCount: [[Int] : [Int]] = [[Int] : [Int]]()
		
		for row in 0..<board.count {
			if(board[row][col].pos.count == 2 || board[row][col].pos.count == 3) {
				if let _ = posCount[board[row][col].pos] {
					posCount[board[row][col].pos]?.append(row)
				} else {
					posCount[board[row][col].pos] = [row]
				}
			}
		}
		
		var arr_key: [Int] = [Int]()
		
		for x in posCount {
			for y in x.key {
				if(!arr_key.contains(y)) {
					arr_key.append(y)
				}
				
			}
		}
		
		if(arr_key.count < 3) {
			return
		}
		
		var pos_keys: [[Int]] = [[Int]]()
		
		for i in 0..<(arr_key.count - 2) {
			for j in (i+1)..<(arr_key.count - 1) {
				for k in (j+1)..<arr_key.count {
					pos_keys.append([arr_key[i], arr_key[j], arr_key[k]])
				}
			}
		}
		
		var newDic: [[Int] : [Int]] = [[Int] : [Int]]()
		
		for key in pos_keys {
			for x in posCount {
				var contains: Int = 0
				for y in x.key {
					if(key.contains(y)) {
						contains += 1
					}
				}
				
				if((x.key.count == 2 && contains > 1) || (x.key.count == 3 && contains > 2)) {
					for y in x.value {
						if let _ = newDic[key] {
							newDic[key]?.append(y)
						} else {
							newDic[key] = [y]
						}
					}
				}
			}
		}
		
		for x in newDic {
			if(x.value.count == 3) {
				removeFrom(col: col, remove: x.key, exclude: x.value)
			}
		}
	}
	func filterObviousTriplets(group: Int) {
		var posCount: [[Int] : [Int]] = [[Int] : [Int]]()
		
		for i in 0..<(board.count/3) {
			for j in 0..<(board[i].count/3) {
				let row = i + (group / 3) * 3
				let col = j + (group % 3) * 3
				
				if(board[row][col].pos.count == 2 || board[row][col].pos.count == 3) {
					if let _ = posCount[board[row][col].pos] {
						posCount[board[row][col].pos]?.append(i*3 + j)
					} else {
						posCount[board[row][col].pos] = [i*3 + j]
					}
				}
			}
		}
		
		var arr_key: [Int] = [Int]()
		
		for x in posCount {
			for y in x.key {
				if(!arr_key.contains(y)) {
					arr_key.append(y)
				}
				
			}
		}
		
		if(arr_key.count < 3) {
			return
		}
		
		var pos_keys: [[Int]] = [[Int]]()
		
		for i in 0..<(arr_key.count - 2) {
			for j in (i+1)..<(arr_key.count - 1) {
				for k in (j+1)..<arr_key.count {
					pos_keys.append([arr_key[i], arr_key[j], arr_key[k]])
				}
			}
		}
		
		var newDic: [[Int] : [Int]] = [[Int] : [Int]]()
		
		for key in pos_keys {
			for x in posCount {
				var contains: Int = 0
				for y in x.key {
					if(key.contains(y)) {
						contains += 1
					}
				}
				
				if((x.key.count == 2 && contains > 1) || (x.key.count == 3 && contains > 2)) {
					for y in x.value {
						if let _ = newDic[key] {
							newDic[key]?.append(y)
						} else {
							newDic[key] = [y]
						}
					}
				}
			}
		}
		
		for x in newDic {
			if(x.value.count == 3) {
				removeFrom(group: group, remove: x.key, exclude: x.value)
			}
		}
	}
	
	//MARK: Pointing Pairs
	func filterAllPointingPairs() {
		for i in 0..<board.count {
			filterPointingPairsRow(group: i)
			filterPointingPairsCol(group: i)
		}
	}
	func filterPointingPairsRow(group: Int) {
		var myDic: [Int : [Int]] = [Int : [Int]]() //key: cell value (1-9) value: which row it is in
		
		for i in 0..<(board.count/3) {
			for j in 0..<(board[i].count/3) {
				let row = i + (group / 3) * 3
				let col = j + (group % 3) * 3
				
				for x in board[row][col].pos {
					if let value = myDic[x] {
						if(!value.contains(row)) {
							myDic[x]?.append(row)
						}
					} else {
						myDic[x] = [row]
					}
				}
			}
		}
		
		for x in myDic {
			if(x.value.count == 1) {
				var exclude: [Int] = [Int]()
				for i in 0..<3 {
					let ex: Int = ((group % 3) * 3) + i
					exclude.append(ex)
				}
				removeFrom(row: x.value[0], remove: x.key, exclude: exclude)
			}
		}
	}
	func filterPointingPairsCol(group: Int) {
		var myDic: [Int : [Int]] = [Int : [Int]]() //key: cell value (1-9) value: which row it is in
		
		for i in 0..<(board.count/3) {
			for j in 0..<(board[i].count/3) {
				let row = i + (group / 3) * 3
				let col = j + (group % 3) * 3
				
				for x in board[row][col].pos {
					if let value = myDic[x] {
						if(!value.contains(col)) {
							myDic[x]?.append(col)
						}
					} else {
						myDic[x] = [col]
					}
				}
			}
		}
		
		for x in myDic {
			if(x.value.count == 1) {
				var exclude: [Int] = [Int]()
				for i in 0..<3 {
					let ex: Int = ((group / 3) * 3) + i
					exclude.append(ex)
				}
				removeFrom(col: x.value[0], remove: x.key, exclude: exclude)
			}
		}
	}
	
	//MARK: Box Line Reduction
	//Reverse of Pointing Pairs
	func filterAllBoxLineReduction() {
		for i in 0..<board.count {
			filterAllBoxLineReduction(row: i)
			filterAllBoxLineReduction(col: i)
		}
	}
	func filterAllBoxLineReduction(row: Int) {
		var myDic: [Int : [Int]] = [Int : [Int]]() //key: cell value (1-9) value: which row it is in
		
		for col in 0..<board.count {
			let group = getGroup(row: row, col: col)
			
			for x in board[row][col].pos {
				if let value = myDic[x] {
					if(!value.contains(group)) {
						myDic[x]?.append(group)
					}
				} else {
					myDic[x] = [group]
				}
			}
		}
		
		for x in myDic {
			if(x.value.count == 1) {
				var exclude: [Int] = [Int]()
				for i in 0..<3 {
					let ex: Int = (row % 3)*3 + i
					exclude.append(ex)
				}
				removeFrom(group: x.value[0], remove: x.key, exclude: exclude)
			}
		}
	}
	func filterAllBoxLineReduction(col: Int) {
		var myDic: [Int : [Int]] = [Int : [Int]]() //key: cell value (1-9) value: which row it is in
		
		for row in 0..<board.count {
			let group = getGroup(row: row, col: col)
			
			for x in board[row][col].pos {
				if let value = myDic[x] {
					if(!value.contains(group)) {
						myDic[x]?.append(group)
					}
				} else {
					myDic[x] = [group]
				}
			}
		}
		
		for x in myDic {
			if(x.value.count == 1) {
				var exclude: [Int] = [Int]()
				for i in 0..<3 {
					let ex: Int = (col % 3) + (i * 3)
					exclude.append(ex)
				}
				removeFrom(group: x.value[0], remove: x.key, exclude: exclude)
			}
		}
	}
	
	//MARK: X-Wing
	//Only two possible numbers (1-9) in each row (i.e. 4 only appers once) -> List rows
	//Two Rows must be in different groups
	func filterAllXWing() {
		filterXWingCol()
		filterXWingRow()
	}
	func filterXWingRow() {
		var arr: [[Int : [Int]]] = [[Int : [Int]]]()
		
		for i in 0..<board.count {
			arr.append(filterXWing(row: i))
		}
		
		for i in 0..<arr.count {
			for j in ((i / 3)*3 + 3)..<arr.count {
				for x in arr[i] {
					if let comp = arr[j][x.key] {
						if(x.value[0] == comp[0] && x.value[1] == comp[1]) { //Arrays should be order
							removeFrom(col: comp[0], remove: x.key, exclude: [i, j])
							removeFrom(col: comp[1], remove: x.key, exclude: [i, j])
						}
					}
				}
			}
		}
	}
	func filterXWing(row: Int) -> [Int : [Int]] {
		var myDic: [Int : [Int]] = [Int: [Int]]() //key: number, value: row it appears
		
		for col in 0..<board[row].count {
			for x in board[row][col].pos {
				if let _ = myDic[x] {
					myDic[x]?.append(col)
				} else {
					myDic[x] = [col]
				}
			}
		}
		
		for x in myDic {
			if(x.value.count != 2) {
				myDic.removeValue(forKey: x.key)
			}
		}
	
		return myDic
	}
	func filterXWingCol() {
		var arr: [[Int : [Int]]] = [[Int : [Int]]]()
		
		for i in 0..<board.count {
			arr.append(filterXWing(col: i))
		}
		
		for i in 0..<arr.count {
			for j in ((i / 3)*3 + 3)..<arr.count {
				for x in arr[i] {
					if let comp = arr[j][x.key] {
						if(x.value[0] == comp[0] && x.value[1] == comp[1]) { //Arrays should be order
							removeFrom(row: comp[0], remove: x.key, exclude: [i, j])
							removeFrom(row: comp[1], remove: x.key, exclude: [i, j])
						}
					}
				}
			}
		}
	}
	func filterXWing(col: Int) -> [Int : [Int]] {
		var myDic: [Int : [Int]] = [Int: [Int]]() //key: number, value: row it appears
		
		for row in 0..<board.count {
			for x in board[row][col].pos {
				if let _ = myDic[x] {
					myDic[x]?.append(row)
				} else {
					myDic[x] = [row]
				}
			}
		}
		
		for x in myDic {
			if(x.value.count != 2) {
				myDic.removeValue(forKey: x.key)
			}
		}
	
		return myDic
	}
	
	//MARK: Bowman's Bingo (Brute Force w/ Backtracing)
	var bowmansCells: [(Int, Int, Int)] = [(Int, Int, Int)]()
	func bowmansBingo() {
		if let cell = randomCell() {
			let randomIndex: Int = Int.random(in: 0..<self.board[cell.0][cell.1].pos.count)
			let changeTo: Int = self.board[cell.0][cell.1].pos[randomIndex]
			save()
			setGameModeToBingo()
			setCell(row: cell.0, col: cell.1, to: changeTo)
			
			bowmansCells.append((cell.0, cell.1, changeTo))
		}
	}
	func bowmansBingoCont() {
		restoreBoard()
		
		if let lastSave = bowmansCells.last {
			board[lastSave.0][lastSave.1].pos.removeAll(where: {$0 == lastSave.2})
			bowmansCells.removeLast()
			if(bowmansCells.count == 0) {
				setGameModeToPlay()
			}
		}
		
	}
	
	//Random Cell
	func randomCell() -> (Int, Int)? {
		return randomCell(forRows: [0, 1, 2, 3, 4, 5, 6, 7, 8], length: 2)
	}
	func randomCell(forRows: [Int], length: Int) -> (Int, Int)? {
		if(length > 9) {
			return nil
		}
		
		if(forRows.count == 0) {
			return randomCell(forRows: [0, 1, 2, 3, 4, 5, 6, 7, 8], length: length+1)
		}
		
		let rowIndex: Int = Int.random(in: 0..<forRows.count)
		let row: Int = forRows[rowIndex]
		var posCols: [Int] = [Int]()
		
		for col in 0..<board[row].count {
			if(board[row][col].number == 0 && board[row][col].pos.count == length) {
				posCols.append(col)
			}
		}
		
		if(posCols.count < 1) {
			var newRows = forRows
			newRows.removeAll(where: {$0 == row})
			return randomCell(forRows: newRows, length: length)
		}
		
		let index: Int = Int.random(in: 0..<posCols.count)
		let col = posCols[index]
		
		return (row, col)
	}
	
	func randomSolvedCell() -> (Int, Int)? {
		return randomSolvedCell(forRows: [0, 1, 2, 3, 4, 5, 6, 7, 8])
	}
	
	func randomSolvedCell(forRows: [Int]) -> (Int, Int)? {
		let rowIndex: Int = Int.random(in: 0..<forRows.count)
		let row: Int = forRows[rowIndex]
		var posCols: [Int] = [Int]()
		
		for col in 0..<board[row].count {
			if(board[row][col].number != 0) {
				posCols.append(col)
			}
		}
		
		if(posCols.count < 1) {
			var newRows = forRows
			newRows.removeAll(where: {$0 == row})
			return randomSolvedCell(forRows: newRows)
		}
		
		let index: Int = Int.random(in: 0..<posCols.count)
		let col = posCols[index]
		
		return (row, col)
	}
	
	
	//MARK: - Setters
	func setCells(board: [[Int]]) {
		for row in 0..<board.count {
			for col in 0..<board[row].count {
				if(board[row][col] != 0) {
					setCell(row: row, col: col, to: board[row][col])
				}
			}
		}
		
	}
	func setCell(row: Int, col: Int, to: Int) {
		board[row][col].number = to
		board[row][col].pos = [Int]()
		board[row][col].foregroundColor = currentColor
		
		//Row
		for i in 0..<board[row].count {
			board[row][i].pos.removeAll(where: {$0 == to})
		}
		
		//col
		for i in 0..<board.count {
			board[i][col].pos.removeAll(where: {$0 == to})
		}
		
		//group
		let group = getGroup(row: row, col: col)
		
		for i in 0..<(board.count/3) {
			for j in 0..<(board[i].count/3) {
				let myRow = i + (group / 3) * 3
				let myCol = j + (group % 3) * 3
				
				board[myRow][myCol].pos.removeAll(where: {$0 == to})
			}
		}
	}
	
	//MARK: - Reset
	func resetDidChange() {
		for row in 0..<board.count {
			for col in 0..<board[row].count {
				board[row][col].didChange = false
			}
		}
	}
	
	func resetPos(row: Int, col: Int) {
		if(board[row][col].number == 0) {
			board[row][col].pos = [1, 2, 3, 4, 5, 6, 7, 8, 9]
			
			for i in 0..<board.count {
				let groupRow = i/3 + (getGroup(row: row, col: col) / 3) * 3
				let groupCol = i%3 + (getGroup(row: row, col: col) % 3) * 3
				
				board[row][col].pos.removeAll(where: {$0 == board[row][i].number})
				board[row][col].pos.removeAll(where: {$0 == board[i][col].number})
				board[row][col].pos.removeAll(where: {$0 == board[groupRow][groupCol].number})
				
			}
		} else {
			board[row][col].pos = [Int]()
		}
	}
	
	func resetPos() {
		for row in 0..<board.count {
			for col in 0..<board[row].count {
				if(board[row][col].number == 0) {
					board[row][col].pos = [1, 2, 3, 4, 5, 6, 7, 8, 9]
					
					for i in 0..<board.count {
						let groupRow = i/3 + (getGroup(row: row, col: col) / 3) * 3
						let groupCol = i%3 + (getGroup(row: row, col: col) % 3) * 3
						
						board[row][col].pos.removeAll(where: {$0 == board[row][i].number})
						board[row][col].pos.removeAll(where: {$0 == board[i][col].number})
						board[row][col].pos.removeAll(where: {$0 == board[groupRow][groupCol].number})
						
					}
				}
			}
		}
	}
	
	//MARK: - Getters
	func getGroup(row: Int, col: Int) -> Int {
		let group = (row / 3) * 3 + col / 3
		return group
	}
	
	func get(row: Int) -> [Int] {
		var rows: [Int] = [Int]()
		for i in 0..<board[row].count {
			if(board[row][i].number != 0) {
				rows.append(board[row][i].number)
			}
		}
		
		return rows
	}
	func get(col: Int) -> [Int] {
		var cols: [Int] = [Int]()
		for i in 0..<board.count {
			if(board[i][col].number != 0) {
				cols.append(board[i][col].number)
			}
		}
		
		return cols
	}
	func get(group: Int) -> [Int] {
		var groups: [Int] = [Int]()
		
		for i in 0..<(board.count/3) {
			for j in 0..<(board[i].count/3) {
				let row = i + (group / 3) * 3
				let col = j + (group % 3) * 3
				
				if(board[row][col].number != 0) {
					groups.append(board[row][col].number)
				}
			}
		}
		
		return groups
	}
	
	func getPos(row: Int) -> [[Int]] {
		var rows: [[Int]] = [[Int]]()
		for i in 0..<board[row].count {
			if(board[row][i].number == 0) {
				rows.append(board[row][i].pos)
			}
		}
		
		return rows
	}
	func getPos(row: Int, excludeCol: Int) -> [[Int]] {
		var rows: [[Int]] = [[Int]]()
		for i in 0..<board[row].count {
			if(board[row][i].number == 0 && i != excludeCol) {
				rows.append(board[row][i].pos)
			}
		}
		
		return rows
	}
	func getPos(col: Int) -> [[Int]] {
		var cols: [[Int]] = [[Int]]()
		for i in 0..<board.count {
			if(board[i][col].number == 0) {
				cols.append(board[i][col].pos)
			}
		}
		
		return cols
	}
	func getPos(col: Int, excludeRow: Int) -> [[Int]] {
		var cols: [[Int]] = [[Int]]()
		for i in 0..<board.count {
			if(board[i][col].number == 0 && i != excludeRow) {
				cols.append(board[i][col].pos)
			}
		}
		
		return cols
	}
	func getPos(group: Int) -> [[Int]] {
		var groups: [[Int]] = [[Int]]()
		
		for i in 0..<(board.count/3) {
			for j in 0..<(board[i].count/3) {
				let row = i + (group / 3) * 3
				let col = j + (group % 3) * 3
				
				if(board[row][col].number == 0) {
					groups.append(board[row][col].pos)
				}
			}
		}
		
		return groups
	}
	func getPos(group: Int, excludeRow: Int, excludeCol: Int) -> [[Int]] {
		var groups: [[Int]] = [[Int]]()
		
		for i in 0..<(board.count/3) {
			for j in 0..<(board[i].count/3) {
				let row = i + (group / 3) * 3
				let col = j + (group % 3) * 3
				
				if(board[row][col].number == 0 && row != excludeRow && col != excludeCol) {
					groups.append(board[row][col].pos)
				}
			}
		}
		
		return groups
	}
	
	//MARK: - Remove
	//MARK: Cell
	func removeCell(row: Int, col: Int) {
		board[row][col].number = 0
		resetPos(row: row, col: col)
	}
	
	//MARK: Pos
	func removeFrom(row: Int, col: Int, remove: Int) {
		if(board[row][col].pos.contains(remove)) {
			board[row][col].pos.removeAll(where: {remove == $0})
		}
	}
	func removeFrom(row: Int, col: Int, remove: [Int]) {
		for r in remove {
			removeFrom(row: row, col: col, remove: r)
		}
	}
	func removeFrom(row: Int, remove: [Int], exclude: [Int]) {
		for col in 0..<board[row].count {
			if(!exclude.contains(col)) {
				for r in remove {
					removeFrom(row: row, col: col, remove: r)
				}
			}
		}
	}
	func removeFrom(col: Int, remove: [Int], exclude: [Int]) {
		for row in 0..<board.count {
			if(!exclude.contains(row)) {
				for r in remove {
					removeFrom(row: row, col: col, remove: r)
				}
			}
		}
	}
	func removeFrom(group: Int, remove: [Int], exclude: [Int]) {
		for i in 0..<(board.count/3) {
			for j in 0..<(board[i].count/3) {
				let row = i + (group / 3) * 3
				let col = j + (group % 3) * 3
				
				if(!exclude.contains(i*3 + j)) {
					for r in remove {
						removeFrom(row: row, col: col, remove: r)
					}
				}
			}
		}
	}
	func removeFrom(row: Int, remove: Int, exclude: [Int]) {
		for col in 0..<board[row].count {
			if(!exclude.contains(col) && board[row][col].pos.contains(remove)) {
				board[row][col].pos.removeAll(where: {remove == $0})
			}
		}
	}
	func removeFrom(col: Int, remove: Int, exclude: [Int]) {
		for row in 0..<board.count {
			if(!exclude.contains(row) && board[row][col].pos.contains(remove)) {
				board[row][col].pos.removeAll(where: {remove == $0})
			}
		}
	}
	func removeFrom(group: Int, remove: Int, exclude: [Int]) {
		for i in 0..<(board.count/3) {
			for j in 0..<(board[i].count/3) {
				let row = i + (group / 3) * 3
				let col = j + (group % 3) * 3
				
				if(!exclude.contains(i*3 + j) && board[row][col].pos.contains(remove)) {
					board[row][col].pos.removeAll(where: {remove == $0})
				}
			}
		}
	}
}
