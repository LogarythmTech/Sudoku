//
//  SudokuView.swift
//  Sudoku (iOS)
//
//  Created by Logan Richards on 1/17/22.
//

import SwiftUI

struct SudokuView: View {
    @StateObject var sudoku: Sudoku = Sudoku(n: 3, m: 3)
    
    var body: some View {
        VStack {
            SudokuBoardView()
                .environmentObject(sudoku)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .aspectRatio(1, contentMode: .fit)
            
            
            HStack {
                ForEach(0..<sudoku.size) { i in
                    ValueButtonView(value: i+1)
                        .environmentObject(sudoku)
                }
            }.frame(height: 40)
            
            Button {
                sudoku[0, 4].value = 1
                sudoku[0, 8].value = 6
                sudoku[1, 0].value = 2
                sudoku[1, 3].value = 5
                sudoku[1, 5].value = 6
                sudoku[1, 6].value = 3
                sudoku[2, 1].value = 5
                sudoku[2, 4].value = 4
                sudoku[3, 1].value = 2
                sudoku[3, 3].value = 7
                sudoku[3, 5].value = 9
                sudoku[3, 8].value = 4
                sudoku[4, 0].value = 3
                sudoku[4, 7].value = 8
                sudoku[5, 4].value = 5
                sudoku[6, 5].value = 1
                sudoku[7, 1].value = 7
                sudoku[7, 3].value = 6
                sudoku[7, 5].value = 2
                sudoku[7, 8].value = 9
                sudoku[8, 2].value = 9
                sudoku[8, 6].value = 4
                sudoku.gameMode = .PlayGame
            } label: {
                Text("Create")
            }
            
            Button {
                let changedCell = sudoku.solveSoleCanidate()
                sudoku.setSelectedCell(to: changedCell)
            } label: {
                Text("Sole Canidate")
            }
            
            Button {
                let changedCell = sudoku.solveUniqueCandidate()
                sudoku.setSelectedCell(to: changedCell)
            } label: {
                Text("Unique Canidate")
            }

        }
    }
}

struct SudokuView_Previews: PreviewProvider {
    static var previews: some View {
        SudokuView()
    }
}
