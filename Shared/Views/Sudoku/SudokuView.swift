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
                .aspectRatio(1, contentMode: .fit)
                .environmentObject(sudoku)
            Button {
                sudoku[0, 0].value = 3
            } label: {
                Text("Next Move")
            }

        }
    }
}

struct SudokuView_Previews: PreviewProvider {
    static var previews: some View {
        SudokuView()
    }
}
