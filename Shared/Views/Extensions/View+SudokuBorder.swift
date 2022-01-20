//
//  View+SudokuBorder.swift
//  Sudoku (iOS)
//
//  Created by Logan Richards on 1/19/22.
//

import SwiftUI

extension View {
    func sudokuBorder(n: Int, m: Int, row: Int, col: Int, width: CGFloat, color: Color) -> some View {
        var boardEdges: [Edge] = [Edge]()
        var groupEdges: [Edge] = [Edge]()
        var cellEdges: [Edge] = [Edge]()
        
        //Top
        if(row == 0) {
            boardEdges.append(.top)
        } else if(row % m == 0) {
            groupEdges.append(.top)
        } else {
            cellEdges.append(.top)
        }
        
        //Bottom
        if(row == (n*m)-1) {
            boardEdges.append(.bottom)
        } else if(row % m == m - 1) {
            groupEdges.append(.bottom)
        } else {
            cellEdges.append(.bottom)
        }
        
        //Leading
        if(col == 0) {
            boardEdges.append(.leading)
        } else if(col % n == 0) {
            groupEdges.append(.leading)
        } else {
            cellEdges.append(.leading)
        }
        
        //Trailing
        if(col == (n*m) - 1) {
            boardEdges.append(.trailing)
        } else if(col % n == n - 1) {
            groupEdges.append(.trailing)
        } else {
            cellEdges.append(.trailing)
        }
        
        //boardEdges, groupEdges, and cellEdges should have all four edges combine
        return ZStack {
            //Board Lines
            border(width: width*4, edges: boardEdges, color: color)
            //Group Line
            border(width: width*2, edges: groupEdges, color: color)
            //Cell Line
            border(width: width, edges: cellEdges, color: color)
        }
    }
}
