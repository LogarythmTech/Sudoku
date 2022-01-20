//
//  SudokuCellView.swift
//  Sudoku (iOS)
//
//  Created by Logan Richards on 1/17/22.
//

import SwiftUI

struct SudokuCellView: View {
    @EnvironmentObject var sudoku: Sudoku
    let row: Int
    let col: Int
    let frame: CGSize
    
    var body: some View {
        Group {
            if let value = sudoku.cells[row][col].value {
                Text(String(value))
                    .font(.system(size: 500, weight: .bold))
                    .minimumScaleFactor(0.01)
            } else if(sudoku.hideNotes) {
                Spacer()
            } else {
                SudokuCellNoteView(row: row, col: col, frame: frame)
            }
        }
        .frame(width: self.frame.width/CGFloat(sudoku.size), height: self.frame.height/CGFloat(sudoku.size))
        .sudokuBorder(n: sudoku.n, m: sudoku.m, row: row, col: col, width: 1, color: .black)
    }
}

struct SudokuCellView_Previews: PreviewProvider {
    static var previews: some View {
        SudokuCellView(row: 0, col: 0, frame: CGSize(width: 300, height: 300)).environmentObject(Sudoku(n: 2, m: 2, cells: [[3, nil, nil, nil],
                                                                                    [nil, nil, nil, nil],
                                                                                    [nil, nil, nil, nil],
                                                                                    [nil, nil, nil, nil]]) ?? Sudoku())
    }
}
