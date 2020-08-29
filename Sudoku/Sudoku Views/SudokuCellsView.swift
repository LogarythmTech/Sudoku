//
//  SudokuCellsVeiw.swift
//  SudokuSolver
//
//  Created by Logan Richards on 8/29/20.
//

import SwiftUI

struct SudokuCellsView: View {
	@ObservedObject var sud: Sudoku
	@Binding var selectedCell: (row: Int, col: Int, group: Int)?
	
	let frame: CGSize
	
	func getGroup(row: Int, col: Int) -> Int {
		let group = (row / 3) * 3 + col / 3
		return group
	}
	
	var body: some View {
		VStack(spacing: 0) {
			ForEach(0..<9) { i in
				HStack(spacing: 0) {
					ForEach(0..<9) { j in
						SudokuCellView(sud: self.sud, myCell: (row: i, col: j, group: self.getGroup(row: i, col: j)), selectedCell: self.$selectedCell, frame: self.frame)
					}
				}
			}
		}
	}
}

struct SudokuCellsVeiw_Previews: PreviewProvider {
    static var previews: some View {
		SudokuCellsView(sud: Sudoku(), selectedCell: .constant(nil), frame: CGSize(width: 400, height: 400))
    }
}
