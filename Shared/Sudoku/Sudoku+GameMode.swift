//
//  Sudoku+GameMode.swift
//  Sudoku (iOS)
//
//  Created by Logan Richards on 1/20/22.
//

import Foundation

extension Sudoku {
    /// The Stage of the game
    enum GameMode {
        /// When the board is beening created.
        /// All values placed in this mode should have ``Sudoku.Cell.foregroundColor`` to ``Sudoku.CellColor.initalForeground``
        case CreateGame
        
        /// When the board is beening played.
        /// All values placed in this mode should have ``Sudoku.Cell.foregroundColor`` to ``Sudoku.CellColor.playedForeground``
        case PlayGame
    }
}
