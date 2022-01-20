//
//  Sudoku+Color.swift
//  Sudoku (iOS)
//
//  Created by Logan Richards on 1/19/22.
//

import Foundation

extension Sudoku {
    enum CellColor {
        /// The text color for the cells that were initally given.
        case initalForeground
        
        /// The text color for the cells that the player played.
        case playedForeground
        
        /// The backgound color when a cell is not selected or is related (same row, col, or group) to the cell that is.
        case noHighlight
        
        /// The background color when a cell is selected.
        case primaryHighlight
        
        /// The background color when a cell is not selected but is related (same row, col, or group) to the cell that is.
        case secondaryHighlight
    }
}
