//
//  SudokuBoardView.swift
//  Sudoku (iOS)
//
//  Created by Logan Richards on 1/19/22.
//

import SwiftUI

struct SudokuBoardView: View {
    @EnvironmentObject var sudoku: Sudoku
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ForEach(0..<sudoku.size) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<sudoku.size) { col in
                            Button {
                                sudoku.setSelectedCell(to: row, col: col)
                            } label: {
                                SudokuCellView(row: row, col: col, frame: CGSize(width: min(geometry.size.width, geometry.size.height), height: min(geometry.size.width, geometry.size.height)))
                                
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
        }
    }
}

struct SudokuBoardView_Previews: PreviewProvider {
    static var previews: some View {
        SudokuBoardView().environmentObject(Sudoku())
    }
}
