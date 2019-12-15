//
//  SudokuView.swift
//  Sudoku
//
//  Created by Logan Richards on 11/29/19.
//  Copyright © 2019 ZER0 Tech. All rights reserved.
//

import SwiftUI

struct SudokuView: View {
	@ObservedObject var sud: Sudoku
	@Binding var selectedCell: (row: Int, col: Int, group: Int)?
	
    var body: some View {
		VStack(spacing: 2) {
			HStack(spacing: 2) {
				SudokuGroupView(sud: self.sud, selectedCell: $selectedCell, group: 0)
				SudokuGroupView(sud: self.sud, selectedCell: $selectedCell, group: 1)
				SudokuGroupView(sud: self.sud, selectedCell: $selectedCell, group: 2)
			}
			
			HStack(spacing: 2) {
				SudokuGroupView(sud: self.sud, selectedCell: $selectedCell, group: 3)
				SudokuGroupView(sud: self.sud, selectedCell: $selectedCell, group: 4)
				SudokuGroupView(sud: self.sud, selectedCell: $selectedCell, group: 5)
			}
			
			HStack(spacing: 2) {
				SudokuGroupView(sud: self.sud, selectedCell: $selectedCell, group: 6)
				SudokuGroupView(sud: self.sud, selectedCell: $selectedCell, group: 7)
				SudokuGroupView(sud: self.sud, selectedCell: $selectedCell, group: 8)
			}
		}.background(Color.black).border(Color.black, width: 2)
		.aspectRatio(1, contentMode: .fit)
    }
}

struct SudokuGroupView: View {
	@ObservedObject var sud: Sudoku
	@Binding var selectedCell: (row: Int, col: Int, group: Int)?
	
	let group: Int
	
	func getRow(i: Int) -> Int {
		return i + (group / 3) * 3
	}
	
	func getCol(j: Int) -> Int {
		return j + (group % 3) * 3
	}
	
    var body: some View {
		VStack(spacing: 0.5) {
			HStack(spacing: 0.5) {
				SudokuCellView(sud: sud, myCell: (row: getRow(i: 0), col: getCol(j: 0), group: self.group), selectedCell: $selectedCell)
				SudokuCellView(sud: sud, myCell: (row: getRow(i: 0), col: getCol(j: 1), group: self.group), selectedCell: $selectedCell)
				SudokuCellView(sud: sud, myCell: (row: getRow(i: 0), col: getCol(j: 2), group: self.group), selectedCell: $selectedCell)
			}
			
			HStack(spacing: 0.5) {
				SudokuCellView(sud: sud, myCell: (row: getRow(i: 1), col: getCol(j: 0), group: self.group), selectedCell: $selectedCell)
				SudokuCellView(sud: sud, myCell: (row: getRow(i: 1), col: getCol(j: 1), group: self.group), selectedCell: $selectedCell)
				SudokuCellView(sud: sud, myCell: (row: getRow(i: 1), col: getCol(j: 2), group: self.group), selectedCell: $selectedCell)
			}
			
			HStack(spacing: 0.5) {
				SudokuCellView(sud: sud, myCell: (row: getRow(i: 2), col: getCol(j: 0), group: self.group), selectedCell: $selectedCell)
				SudokuCellView(sud: sud, myCell: (row: getRow(i: 2), col: getCol(j: 1), group: self.group), selectedCell: $selectedCell)
				SudokuCellView(sud: sud, myCell: (row: getRow(i: 2), col: getCol(j: 2), group: self.group), selectedCell: $selectedCell)
			}
		}
	}
}

struct SudokuNumberView: View {
	let number: Int
	var hide: Bool = false
	
	var backgroundColor: Color = .black
	var foregroundColor: Color = .white
	
	var imageName: String {
		get {
			switch number {
			case 1:
				return "1.square.fill"
			case 2:
				return "2.square.fill"
			case 3:
				return "3.square.fill"
			case 4:
				return "4.square.fill"
			case 5:
				return "5.square.fill"
			case 6:
				return "6.square.fill"
			case 7:
				return "7.square.fill"
			case 8:
				return "8.square.fill"
			case 9:
				return "9.square.fill"
			default:
				return "1.square.fill"
			}
		}
	}
	
    var body: some View {
		ZStack {
			if(!hide) {
				RoundedRectangle(cornerRadius: 100)
					.foregroundColor(backgroundColor)
			}
			
			Image(systemName: self.imageName)
				.resizable()
				.foregroundColor(foregroundColor)
		}.background(foregroundColor)
    }
	
}

struct SudokuCellNoteView: View {
	let hide: [Bool]
	
    var body: some View {
		VStack(spacing: 0.0) {
			HStack(spacing: 0.0) {
				SudokuNumberView(number: 1, hide: self.hide[0])
				SudokuNumberView(number: 2, hide: self.hide[1])
				SudokuNumberView(number: 3, hide: self.hide[2])
			}
			
			HStack(spacing: 0.0) {
				SudokuNumberView(number: 4, hide: self.hide[3])
				SudokuNumberView(number: 5, hide: self.hide[4])
				SudokuNumberView(number: 6, hide: self.hide[5])
			}
			
			HStack(spacing: 0.0) {
				SudokuNumberView(number: 7, hide: self.hide[6])
				SudokuNumberView(number: 8, hide: self.hide[7])
				SudokuNumberView(number: 9, hide: self.hide[8])
			}
		}
    }
}

struct SudokuCellView: View {
	@ObservedObject var sud: Sudoku
	let myCell: (row: Int, col: Int, group: Int)
	@Binding var selectedCell: (row: Int, col: Int, group: Int)?
	
    var body: some View {
		Button(action: {
			self.selectedCell = self.myCell
		}) {
			ZStack {
				if(self.sud.board[myCell.row][myCell.col].number > 0 && self.sud.board[myCell.row][myCell.col].number < 10) {
					SudokuNumberView(number: self.sud.board[myCell.row][myCell.col].number, backgroundColor: self.sud.board[myCell.row][myCell.col].backgroundColor, foregroundColor: self.sud.board[myCell.row][myCell.col].foregroundColor)
				} else if(!self.sud.hideNotes) {
					SudokuCellNoteView(hide: self.sud.board[myCell.row][myCell.col].getHide())
				} else {
					Rectangle().foregroundColor(.white)
				}
				
				
				if(self.selectedCell != nil && self.selectedCell!.row == self.myCell.row) {
					Rectangle().foregroundColor(.blue).opacity(0.1)
				}
					
				if(self.selectedCell != nil && self.selectedCell!.col == self.myCell.col) {
					Rectangle().foregroundColor(.blue).opacity(0.1)
				}
					
				if(self.selectedCell != nil && self.selectedCell!.group == self.myCell.group) {
					Rectangle().foregroundColor(.blue).opacity(0.1)
				}
			}
		}
    }
}
