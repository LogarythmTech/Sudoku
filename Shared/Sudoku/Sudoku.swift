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
    
    var hideNotes: Bool = false
    
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
    subscript(row: Int, col: Int) -> Cell {
        get {
            return cells[row][col]
        }
        set(newValue) {
            if let setValue = newValue.value {
                //TODO: For all cells in the same row, col, or group, remove `newValue.value` from possible values
                if(setValue > 0 && setValue < self.size) {
                    self.cells[row][col] = newValue
                }
            } else {
                self.cells[row][col] = newValue
            }
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
    
    //MARK: Reseters
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
