//
//  SudokuCellNoteView.swift
//  Sudoku (iOS)
//
//  Created by Logan Richards on 1/19/22.
//

import SwiftUI

struct SudokuCellNoteView: View {
    @EnvironmentObject var sudoku: Sudoku
    let row: Int
    let col: Int
    let frame: CGSize
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<sudoku.m) { i in
                HStack(spacing: 0) {
                    ForEach(0..<sudoku.n) { j in
                        let number: Int = i*sudoku.n + j + 1
                        Group {
                            if(sudoku[row, col].possibleValues.contains(number)) {
                                Text(String(number))
                                    .font(.system(size: 500))
                                    .cellTextColor(.initalForeground)
                                    .minimumScaleFactor(0.01)
                            } else {
                                Spacer()
                            }
                        }
                        .frame(width: frame.width/CGFloat(sudoku.size*sudoku.n), height: frame.height/CGFloat(sudoku.size*sudoku.m))
                    }
                }
            }
        }
    }
}

struct SudokuCellNoteView_Previews: PreviewProvider {
    static var previews: some View {
        SudokuCellNoteView(row: 0, col: 0, frame: CGSize(width: 300, height: 300)).environmentObject(Sudoku(n: 2, m: 3))
    }
}
