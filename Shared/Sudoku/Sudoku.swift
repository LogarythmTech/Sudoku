//
//  Sudoku.swift
//  Sudoku (iOS)
//
//  Created by Logan Richards on 1/17/22.
//

import Foundation
import SwiftUI

/// The Class that contains a sudoku baord. Can play, solve, and generate.
public class Sudoku: ObservableObject {
    /// The Number of Columns in one Group.
    let n: Int
    /// The Number of Rows in one Group.
    let m: Int
    
    /// The number of columns and rows in the board. Board should be square.
    var size: Int {
        return n*m
    }
    
    @Published private var cells: [[Cell]]
    @Published var hideNotes: Bool = true
    @Published var selectedCell: CellPosition?
    
    //MARK: - Initializers
    convenience init() {
        self.init(n: 3, m: 3)
    }
    
    convenience init(n: Int) {
        self.init(n: n, m: n)
    }
    
    init(n: Int, m: Int) {
        self.n = n
        self.m = m
        self.cells = [[Cell]]()
        
        for row in 0..<(n*m) {
            self.cells.append([Cell]())
            
            for col in 0..<(n*m) {
                self.cells[row].append(Cell(n: n, m: m, row: row, column: col))
            }
        }
                                        
        self.printCells()
    }
    
    init?(n: Int, m: Int, cells: [[Int?]]) {
        self.n = n
        self.m = m
        self.cells = [[Cell]]()
        
        for row in 0..<(n*m) {
            self.cells.append([Cell]())
            
            for col in 0..<(n*m) {
                self.cells[row].append(Cell(n: n, m: m, row: row, column: col))
            }
        }
        
        if(cells.count != n*m) {
            return nil
        } else {
            for row in cells {
                if(row.count != n*m) {
                    return nil
                }
            }
        }
        
        for row in 0..<(n*m) {
            for col in 0..<(n*m) {
                if let value = cells[row][col] {
                    self[row, col].value = value
                }
            }
        }
        
        self.printCells()
    }
    
    //MARK: - Subscript
    subscript(pos: CellPosition) -> Cell {
        get {
            return cells[pos.row][pos.column]
        }
        set(newValue) {
            if(newValue.value != cells[pos.row][pos.column].value) {
                setCellValue(to: newValue.value, for: pos)
            } else {
                self.cells[pos.row][pos.column] = newValue
            }
        }
    }
    
    subscript(row: Int, col: Int) -> Cell {
        get {
            return self[CellPosition(row: row, column: col, n: n, m: m)]
        }
        set(newValue) {
            self[CellPosition(row: row, column: col, n: n, m: m)] = newValue
        }
    }
    
    //MARK: - Getters
    /// - Returns the `index` of the group starting from the top right at 0 going to the bottom left with size-1
    func getGroupIndex(row: Int, col: Int) -> Int {
        return (row / n) * n + col / m
    }
    
    /// - Returns all the values (sorted) in a row that has been set.
    func getValuesFor(row: Int) -> [Int] {
        var values: [Int] = [Int]()
        
        for i in 0..<(n*m) {
            if let value = cells[row][i].value {
                values.append(value)
            }
        }
        
        return values.sorted()
    }
    
    /// - Returns all the values (sorted) in a column that has been set.
    func getValuesFor(col: Int) -> [Int] {
        var values: [Int] = [Int]()
        
        for i in 0..<(n*m) {
            if let value = cells[i][col].value {
                values.append(value)
            }
        }
        
        return values.sorted()
    }
    
    /// - Returns all the values (sorted) in a group that has been set.
    func getValuesFor(group: Int) -> [Int] {
        var values: [Int] = [Int]()
        
        for i in 0..<n {
            for j in 0..<m {
                let row = i + (group / n) * m
                let col = j + (group % n) * m
                
                if let value = cells[row][col].value {
                    values.append(value)
                }
            }
        }
        
        return values.sorted()
    }
    
    //MARK: - Setters
    private func setCellValue(to value: Int?, for pos: CellPosition) {
        if let value = value {
            if(value > 0 && value <= size) {
                self.cells[pos.row][pos.column].value = value
                
                for i in 0..<size {
                    if(i != pos.row) {
                        self.cells[i][pos.column].removePossibleValue(value)
                    }
                    
                    if(i != pos.column) {
                        self.cells[pos.row][i].removePossibleValue(value)
                    }
                    
                    if(pos.groupIndex != i) {
                        let groupPos = CellPosition(group: pos.group, groupIndex: i, n: n, m: m)
                        self.cells[groupPos.row][groupPos.column].removePossibleValue(value)
                    }
                }
                
                printCells()
            }
        } else {
            self.cells[pos.row][pos.column].value = nil
        }
    }
    
    func setSelectedCell(to row: Int, col: Int) {
        var pos: CellPosition? = nil
        
        if(row >= 0 && row < size && col >= 0 && col < size) {
            pos = CellPosition(row: row, column: col, n: n, m: m)
        }
        
        setSelectedCell(to: pos)
    }
    
    func setSelectedCell(to pos: CellPosition?) {
        resetHighlights()
        
        if let pos = pos {
            for i in 0..<size {
                self[pos.row, i].highlightColor = .secondaryHighlight
                self[i, pos.column].highlightColor = .secondaryHighlight
                
                let groupPos: CellPosition = CellPosition(group: pos.group, groupIndex: i, n: n, m: m)
                self[groupPos].highlightColor = .secondaryHighlight
            }
            
            self[pos].highlightColor = .primaryHighlight
        }
        
        self.selectedCell = pos
    }
    
    func setValueForSelectedCell(to value: Int) {
        if let selectedCell = selectedCell {
            self[selectedCell].value = value
        }
    }
    
    //MARK: Reseters
    func resetHighlights() {
        for row in 0..<size {
            for col in 0..<size {
                self[row, col].highlightColor = .noHighlight
            }
        }
    }
    
    func resetBoard() {
        for (rowIndex, row) in cells.enumerated() {
            for (index, _) in row.enumerated() {
                self[rowIndex, index].clear(n: n, m: m)
            }
        }
    }
    
    //MARK: - Print
    func printCells() {
        var line = ""
        for _ in 0..<m {
            line += "+"
            for i in 0..<n {
                if(i == 0) {
                    line += "-"
                } else {
                    line += "--"
                }
            }
        }
        line += "+"
        
        for (rowIndex, row) in cells.enumerated() {
            var r = ""
            
            for (index, cell) in row.enumerated() {
                if(index % n == 0) {
                    r += "|"
                    
                    if let value = cell.value {
                        r += String(value)
                    } else {
                        r += "_"
                    }
                } else {
                    if let value = cell.value {
                        r += " " + String(value)
                    } else {
                        r += " _"
                    }
                }
            }
            
            r += "|"
            
            if(rowIndex % m == 0) {
                print(line)
            }
            print(r)
        }
        
        print(line)
    }
}
