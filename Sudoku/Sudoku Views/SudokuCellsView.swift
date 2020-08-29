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
	
	var body: some View {
		VStack(spacing: 0) {
			ForEach(0..<9) { i in
				HStack(spacing: 0) {
					ForEach(0..<9) { j in
						SudokuCellView(sud: self.sud, myCell: (row: i, col: j, group: 0), selectedCell: self.$selectedCell, frame: self.frame)
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
