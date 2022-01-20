//
//  Sudoku+Cell.swift
//  Sudoku (iOS)
//
//  Created by Logan Richards on 1/17/22.
//

import Foundation
import SwiftUI

extension Sudoku {
    
    struct Cell {
        /// The Value of the cell. Can go bettween `1-(n*m)`. `nil` if unknown
        var value: Int?
        
        /// If  `autoValue`, then when `possibleValues` only have one possible value the `cell` will automatically set the only possible value to the cells value
        var autoValue: Bool
        
        /// All the possible values that the cell could be.
        var possibleValues: [Int]
        
        /// The position (row, column, and group) of the cell
        let position: CellPosition
        
        /// The text color of the cell.
        /// Defualt. The initial text color should be black and the played text color should be blue. 
        var foregroundColor: CellColor = .initalForeground
        
        /// The backgournd of the cell. Should have primary highlight if selected. Secondary hightlight if it is in the same row, col, or group as the selected cell. No Hightlight if anything else
        var highlightColor: CellColor = .noHighlight
        
        /// - Parameter n: The number of columns in a group of the board.
        /// - Parameter m: The number of rows in a group of the board.
        /// - Parameter row: The row of the cell.
        /// - Parameter column: The column of the cell.
        /// - Parameter autoValue: If `true` and there is only one possible value, then set said value to last possible value.
        init(n: Int, m: Int, row: Int, column: Int, autoValue: Bool = false) {
            self.possibleValues = [Int]()
            self.autoValue = autoValue
            self.position = CellPosition(row: row, column: column, n: n, m: m)
            
            self.value = (position.groupIndex / n) + ((position.group / m) * m)
            
            for i in 1...(n*m) {
                self.possibleValues.append(i)
            }
        }
        
        /// Removes (if appliable) all values in ``Sudoku.Cell.possibleValues`` in which are equal to `value`.
        /// If   ``Sudoku.Cell.autoValue`` is `true`  and there is only one possible vaule left in ``Sudoku.Cell.possibleValues``, then sets ``Sudoku.Cell.value`` to last possible value.
        /// - Parameter value: The Value to remove from ``Sudoku.Cell.possibleValues``
        mutating func removePossibleValue(_ value: Int) {
            possibleValues.removeAll(where: {$0 == value})
            
            if(autoValue && possibleValues.count == 1) {
                self.value = possibleValues.first
                possibleValues.removeAll()
            }
        }
        
        /// Sets the cells value to `value`.
        /// - Parameter value: The value to set cell's value to.
        mutating func setVaule(_ value: Int) {
            self.value = value
        }
        
        /// Clears the value as well as resets the possible values of the cell.
        /// - Parameter n: The number of columns in a group of the board.
        /// - Parameter m: The number of rows in a group of the board.
        mutating func clear(n: Int, m: Int) {
            self.value = nil
            self.possibleValues = [Int]()
            
            for i in 1...(n*m) {
                self.possibleValues.append(i)
            }
        }
    }
    
}
