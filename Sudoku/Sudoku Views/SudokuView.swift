//
//  SudokuView.swift
//  SudokuSolver
//
//  Created by Logan Richards on 8/29/20.
//

import SwiftUI

struct SudokuView: View {
	@ObservedObject var sud: Sudoku
	@Binding var selectedCell: (row: Int, col: Int, group: Int)?
	
	let frame: CGSize = CGSize(width: 400, height: 400)
	
    var body: some View {
		ZStack {
			SudokuCellsView(sud: self.sud, selectedCell: self.$selectedCell, frame: self.frame)
			SudokuBorderView(frame: self.frame)
		}
    }
}

struct SudokuView_Previews: PreviewProvider {
    static var previews: some View {
		SudokuView(sud: Sudoku(), selectedCell: .constant(nil))
    }
}
