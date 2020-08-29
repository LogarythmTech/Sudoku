//
//  SudokuCellView.swift
//  SudokuSolver
//
//  Created by Logan Richards on 8/29/20.
//

import SwiftUI

struct SudokuCellView: View {
	@ObservedObject var sud: Sudoku
	let myCell: (row: Int, col: Int, group: Int)
	@Binding var selectedCell: (row: Int, col: Int, group: Int)?
	
	let frame: CGSize
	
	func backgroundView() -> Color {
		if let cell = selectedCell {
			var count = 0
			
			if(cell.row == myCell.row) {
				count += 1
			}
			
			if(cell.col == myCell.col) {
				count += 1
			}
			
			if(cell.group == myCell.group) {
				count += 1
			}
			
			switch count {
			case 1:
				return .superLightBlue
			case 2:
				return .veryLightBlue
			case 3:
				return .lightBlue
			default:
				return Color.white
			}
		}
		
		return Color.white
	}
	
    var body: some View {
		Button(action: {
			self.selectedCell = self.myCell
		}) {
			if(self.sud.board[myCell.row][myCell.col].number > 0 && self.sud.board[myCell.row][myCell.col].number < 10) {
				Text(String(self.sud.board[myCell.row][myCell.col].number))
					.font(.system(size: 500))
					.minimumScaleFactor(0.01)
					.foregroundColor(self.sud.board[myCell.row][myCell.col].foregroundColor)
					.frame(width: self.frame.width/9, height: self.frame.height/9)
			} else if(!self.sud.hideNotes) {
				SudokuCellNoteView(pos: self.sud.board[myCell.row][myCell.col].pos, frame: self.frame)
			} else {
				Spacer().frame(width: self.frame.width/9, height: self.frame.height/9)
			}
		}.background(self.backgroundView())
    }
}

struct SudokuCellView_Previews: PreviewProvider {
    static var previews: some View {
		SudokuCellView(sud: Sudoku(), myCell: (row: 0, col: 0, group: 0), selectedCell: .constant(nil), frame: CGSize(width: 400, height: 400))
    }
}
