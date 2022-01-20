//
//  Sudoku+HumanSolve.swift
//  Sudoku (iOS)
//
//  Created by Logan Richards on 1/17/22.
//

import Foundation

//All methods to solve a sudoku using standard human algorithms.
extension Sudoku {
    //TODO: Sorted list, to check cells that have a higher potential to solve first.
    
    //MARK: - Techniques to Solve Values
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
    //TODO: Try to see if there is a more effiecent way of solving using this method.
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
    
    /// If in a row, column, or group there is a playable number (1-9 in a standard 9x9 board) such that it can only be put in a single cell (of the row, column, or group), then that number is guaranteed to fit there.
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
    
    //MARK: - Techniques to Remove Possible Values
    //MARK: Pointing Pairs
    /// If in a group, there exists a certain number that can only fit into cells that are aligned on the same row or column, then said number cannot be placed in the remaining cells of the row/column (the cells that do not belong to the group).
    
    //MARK: Box Line Reduction
    /// If in a row or column, there exists a certain number that can only fit into cells that are in the same group, then said number cannot be placed in the remaining cells of the group (the cells that do not belong to the row/column).
    
    //MARK: Block / Block Interation
    
    //MARK: Obvious Subset (Pairs, Triplets, etc)
    /// If in a row, column, or group, there exists a subset of numbers that can only fit into a certain number of cells such that the legth of the subset is the same as the number of cells, then the subset of number cannot be placed for the remaining cells of the row, column, or group (the cells that are not part of the subset).
    /// The subset can be any size from 2 up to `n*m`. (2-9 in a standard 9x9 board).
    /// The subset of cells, does not all have to be able to place all numbers of the subset. For example, if there are three cells such that first cell could possibly be [1, 4], the second cell could possibley be [4, 7], and the last cell could possibly be [1, 7]. Then the subset of possible numbers is [1, 4, 7] and the rest of the cells in the row, column, or group would not be able to play 1, 4, or 7.
    
    //MARK: Hidden Subset
    /// 
    
    //MARK: X-Wing
    //MARK: Sword Fish
    //MARK: Forcing Chain
    
    //MARK: Bowman's Bingo
    
}
