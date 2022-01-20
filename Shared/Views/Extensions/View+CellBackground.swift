//
//  View+CellTextColor.swift
//  Sudoku (iOS)
//
//  Created by Logan Richards on 1/19/22.
//

import SwiftUI

extension View {
    func cellBackground(_ cellColor: Sudoku.CellColor) -> some View {
        switch cellColor {
        case .noHighlight:
            return background(Color.clear)
        case .primaryHighlight:
            return background(Color.pink)
        case .secondaryHighlight:
            return background(Color.blue)
        default:
            return background(Color.clear)
        }
    }
}
