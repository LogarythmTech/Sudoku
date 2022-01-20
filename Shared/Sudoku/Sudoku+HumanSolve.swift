//
//  Sudoku+HumanSolve.swift
//  Sudoku (iOS)
//
//  Created by Logan Richards on 1/17/22.
//

import Foundation

//All methods to solve a sudoku using standard human algorithms.
extension Sudoku {
    
    //MARK: - Human Methods
    //MARK: Sole Candidate
    /// If the cells in the same row, column, and group of a specific cell contains (or will contain) all playable numbers (1-9 in a standard 9x9 board) but one, then said cell must be the outlier number.
    /// Due to the nature of ``Sudoku.Cell`` if the possible values of a cell contains only one value. Said possible value must be the currect value of the cell.
    func solveSoleCanidate() -> CellPosition? {
        //Iterate through cells
        for row in 0..<self.size {
            for col in 0..<self.size {
                if(self[row, col].value == nil && self[row, col].possibleValues.count == 1) {
                    self[row, col].value = self[row, col].possibleValues.first ?? 0
                    return self[row, col].position
                }
            }
        }
        
        return nil
    }
    
    //MARK: Unique Candidate
    /// If in a row, column, or group there is a playable number (1-9 in a standard 9x9 board) such that it can only be put in a single cell (of the row, column, or group), then that number is guaranteed to fit there.
    func solveUniqueCandidate() -> CellPosition? {
        for row in 0..<self.size {
            for col in 0..<self.size {
                if let position = solveUniqueCandidate(for: self[row, col]) {
                    return position
                }
            }
        }
        
        return nil
    }
    
    private func solveUniqueCandidate(for cell: Cell) -> CellPosition? {
        if(cell.value != nil) {
            return nil
        }
        
        //Check Row
        var values: [Int] = cell.possibleValues
        for col in 0..<self.size {
            if(col != cell.position.column) {
                values.removeAll { value in
                    self[cell.position.row, col].possibleValues.contains(value)
                }
            }
        }
        
        if(values.count == 1) {
            self[cell.position.row, cell.position.column].value = values.first ?? 0
            return cell.position
        }
        
        //Check Column
        values = cell.possibleValues
        for row in 0..<self.size {
            if(row != cell.position.row) {
                values.removeAll { value in
                    self[row, cell.position.column].possibleValues.contains(value)
                }
            }
        }
        
        if(values.count == 1) {
            self[cell.position.row, cell.position.column].value = values.first ?? 0
            return cell.position
        }
        
        //Check Group
        values = cell.possibleValues
        
        for index in 0..<self.size {
            let pos = CellPosition(group: cell.position.group, groupIndex: index, n: self.n, m: self.m)
            
            if(cell.position != pos) {
                values.removeAll { value in
                    self[pos.row, pos.column].possibleValues.contains(value)
                }
            }
            
        }
        
        if(values.count == 1) {
            self[cell.position.row, cell.position.column].value = values.first ?? 0
            return cell.position
        }
        
        return nil
    }
    
    //MARK: Box Line Reduction
    //MARK: Pointing Pairs
    //MARK: Obvious Doubles
    //MARK: Obvious Triplets
    //MARK: X-Wing
    //MARK: Sword Fish
    //MARK: Forcing Chain
    //MARK: Bowman's Bingo
    
}
