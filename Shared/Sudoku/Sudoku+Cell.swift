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
        
        /// The text color of the cell.
        var foregroundColor: Color = .blue
        
        /// The background color of the cell.
        var backgroundColor: Color = .clear
        
        /// The tint of the cell
        var hightlightColor: Color = .clear
        
        /// - Parameter n: The number of columns in a group of the board.
        /// - Parameter m: The number of rows in a group of the board.
        init(n: Int, m: Int, autoValue: Bool = false) {
            self.possibleValues = [Int]()
            self.autoValue = autoValue
            
            for i in 1...(n*m) {
                self.possibleValues.append(i)
            }
        }
        
        mutating func removePossibleValue(_ value: Int) {
            possibleValues.removeAll(where: {$0 == value})
            
            if(autoValue && possibleValues.count == 1) {
                self.value = possibleValues.first
                possibleValues.removeAll()
            }
        }
        
        mutating func setVaule(_ value: Int) {
            self.value = value
            self.possibleValues = [Int]()
        }
        
        mutating func clear(n: Int, m: Int) {
            self.value = nil
            self.possibleValues = [Int]()
            
            for i in 1...(n*m) {
                self.possibleValues.append(i)
            }
        }
    }
    
}
