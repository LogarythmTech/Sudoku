//
//  Sukoku.swift
//  Sudoku
//
//  Created by Logan Richards on 11/30/19.
//  Copyright © 2019 ZER0 Tech. All rights reserved.
//

import SwiftUI
import Foundation

struct SudokuCell {
	var number: Int = 0
	var pos: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9]
	
	func getHide() -> [Bool] {
		var hide: [Bool] = [true, true, true, true, true, true, true, true, true]
		
		for i in pos {
			if((i-1) < hide.count && (i) > 0) {
				hide[i-1] = false
			}
		}
		
		return hide
	}
}

class Sudoku {
	var board: [[SudokuCell]]
	
	//Rows <->
	//Cols ^
	
	init() {
		board = [[SudokuCell]]()
		
		for _ in 0..<9 {
			var row = [SudokuCell]()
			for _ in 0..<9 {
				row.append(SudokuCell())
			}
			
			board.append(row)
		}
		
		gererate(given: 0)
		solve()
	}
	
	func gererate(given: Int) {
		setCell(row: 0, col: 3, to: 6)
		setCell(row: 0, col: 7, to: 9)
		
		setCell(row: 1, col: 5, to: 4)
		setCell(row: 1, col: 6, to: 2)
		setCell(row: 1, col: 8, to: 3)
		
		setCell(row: 2, col: 0, to: 1)
		setCell(row: 2, col: 7, to: 5)
		setCell(row: 2, col: 8, to: 7)
		
		setCell(row: 3, col: 2, to: 3)
		setCell(row: 3, col: 4, to: 6)
		
		setCell(row: 4, col: 0, to: 7)
		setCell(row: 4, col: 3, to: 9)
		setCell(row: 4, col: 4, to: 3)
		setCell(row: 4, col: 5, to: 5)
		setCell(row: 4, col: 8, to: 6)
		
		setCell(row: 5, col: 4, to: 8)
		setCell(row: 5, col: 6, to: 1)
		
		setCell(row: 6, col: 0, to: 8)
		setCell(row: 6, col: 1, to: 9)
		setCell(row: 6, col: 8, to: 5)
		
		setCell(row: 7, col: 0, to: 3)
		setCell(row: 7, col: 2, to: 4)
		setCell(row: 7, col: 3, to: 1)
		
		setCell(row: 8, col: 1, to: 6)
		setCell(row: 8, col: 5, to: 8)
	}
	
	//MARK: - Solve
	func solve() {
		for _ in 0..<10 {
			filterAllObviousPairs()
			filterAllSinglets()
			filterAllSingles()
		}
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
	
	//MARK: Singlets
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
	
	//MARK: Pointing Pairs
	
	//MARK: - Setters
	func setCell(row: Int, col: Int, to: Int) {
		board[row][col].number = to
		board[row][col].pos = [Int]()
		
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
	func removeFrom(row: Int, remove: [Int], exclude: [Int]) {
		for col in 0..<board[row].count {
			if(!exclude.contains(col)) {
				board[row][col].pos.removeAll(where: {remove.contains($0)})
			}
		}
	}
	
	func removeFrom(col: Int, remove: [Int], exclude: [Int]) {
		for row in 0..<board.count {
			if(!exclude.contains(row)) {
				board[row][col].pos.removeAll(where: {remove.contains($0)})
			}
		}
	}
	
	func removeFrom(group: Int, remove: [Int], exclude: [Int]) {
		for i in 0..<(board.count/3) {
			for j in 0..<(board[i].count/3) {
				let row = i + (group / 3) * 3
				let col = j + (group % 3) * 3
				
				if(!exclude.contains(i*3 + j)) {
					board[row][col].pos.removeAll(where: {remove.contains($0)})
				}
			}
		}
	}
}
