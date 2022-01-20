//
//  Text+CellTextColor.swift
//  Sudoku (iOS)
//
//  Created by Logan Richards on 1/19/22.
//

import SwiftUI

extension Text {
    func cellTextColor(_ cellColor: Sudoku.CellColor) -> Text {
        switch cellColor {
        case .initalForeground:
            return foregroundColor(.primary)
        case .playedForeground:
            return foregroundColor(.blue)
        default:
            return foregroundColor(.red)
        }
    }
}
