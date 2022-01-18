//
//  Sudoku+HumanSolve.swift
//  Sudoku (iOS)
//
//  Created by Logan Richards on 1/17/22.
//

import Foundation

extension Sudoku {
    
    //MARK: - Solve using Human Techniques
    //MARK: Singles
    /// If there are only one possible choice for a certian cell, then the cell's value must be that last possible choice.
    private func filterSingles() {
        for (rowIndex, row) in cells.enumerated() {
            for (index, cell) in row.enumerated() {
                if(cell.possibleValues.count == 1) {
                    self.cells[rowIndex][index].setVaule(cell.possibleValues.first ?? 0)
                }
            }
        }
    }
    
    //MARK: Singlets
    //MARK: Box Line Reduction
    //MARK: Pointing Pairs
    //MARK: Obvious Doubles
    //MARK: Obvious Triplets
    //MARK: X-Wing
    //MARK: Sword Fish
    //MARK: Forcing Chain
    //MARK: Bowman's Bingo
    
}
