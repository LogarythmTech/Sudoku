//
//  Sudoku+CellPosition.swift
//  Sudoku (iOS)
//
//  Created by Logan Richards on 1/19/22.
//

import Foundation

extension Sudoku {
    struct CellPosition {
        let row: Int
        let column: Int
        let group: Int
        
        let n: Int
        let m: Int
        
        var groupIndex: Int {
            return ((row % m)*n) + (column % n)
        }
        
        init(row: Int, column: Int, n: Int, m: Int) {
            self.row = row
            self.column = column
            self.n = n
            self.m = m
            self.group = (column / n) + (row / m)*m
        }
        
        
        init(group: Int, groupIndex: Int, n: Int, m: Int) {
            self.group = group
            self.n = n
            self.m = m
            self.row = (groupIndex / n) + ((group / m) * m)
            self.column = (groupIndex % n) + ((group % m) * n)
        }
    }
}
