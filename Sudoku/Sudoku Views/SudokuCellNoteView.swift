//
//  SudokuCellNoteView.swift
//  SudokuSolver
//
//  Created by Logan Richards on 8/29/20.
//

import SwiftUI

struct SudokuCellNoteView: View {
	let pos: [Int]
	let frame: CGSize
	
	var body: some View {
		VStack(spacing: 0) {
			ForEach(0..<3) { i in
				HStack(spacing: 0) {
					HelperSudokuCellNoteView(number: i*3 + 1, show: self.pos.contains(i*3 + 1), frame: self.frame)
					HelperSudokuCellNoteView(number: i*3 + 2, show: self.pos.contains(i*3 + 2), frame: self.frame)
					HelperSudokuCellNoteView(number: i*3 + 3, show: self.pos.contains(i*3 + 3), frame: self.frame)
				}
			}
		}
	}
}

struct HelperSudokuCellNoteView: View {
	let number: Int
	let show: Bool
	
	let frame: CGSize
	
	var body: some View {
		if(self.show) {
			Text(String(self.number))
				.font(.system(size: 500))
				.minimumScaleFactor(0.01)
				.foregroundColor(.black)
				.frame(width: self.frame.width/27, height: self.frame.height/27)
		} else {
			Spacer().frame(width: self.frame.width/27, height: self.frame.height/27)
		}
	}
}

struct SudokuCellNoteView_Previews: PreviewProvider {
    static var previews: some View {
        SudokuCellNoteView(pos: [1, 4, 6, 2, 9], frame: CGSize(width: 400, height: 400))
    }
}
