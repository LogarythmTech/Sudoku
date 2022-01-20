//
//  EdgeBorder.swift
//  Sudoku (iOS)
//
//  Created by Logan Richards on 1/17/22.
//

import SwiftUI

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
    
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

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}
