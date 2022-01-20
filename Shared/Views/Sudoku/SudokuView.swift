//
//  SudokuView.swift
//  Sudoku (iOS)
//
//  Created by Logan Richards on 1/17/22.
//

import SwiftUI

struct SudokuView: View {
    @StateObject var sudoku: Sudoku = Sudoku(n: 2, m: 2, cells: [[1, 2, 3, 4],
                                                                 [4, nil, 2, 1],
                                                                 [3, 4, 1, 2],
                                                                 [2, 1, 4, 3]]) ?? Sudoku()
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ForEach(0..<sudoku.m*sudoku.n) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<sudoku.m*sudoku.n) { col in
                            SudokuCellView(row: row, col: col, frame: CGSize(width: min(geometry.size.width, geometry.size.height), height: min(geometry.size.width, geometry.size.height))).environmentObject(sudoku)
                        }
                    }
                }
            }
        }
    }
}

struct SudokuView_Previews: PreviewProvider {
    static var previews: some View {
        SudokuView()
    }
}
