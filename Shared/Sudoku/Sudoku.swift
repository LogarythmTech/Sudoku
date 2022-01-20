//
//  Sudoku.swift
//  Sudoku (iOS)
//
//  Created by Logan Richards on 1/17/22.
//

import Foundation
import SwiftUI

public class Sudoku: ObservableObject {
    /// The Number of Columns in one Group.
    let n: Int
    /// The Number of Rows in one Group.
    let m: Int
    
    /// The number of columns and rows in the board. Board should be square.
    var size: Int {
        return n*m
    }
    
    var cells: [[Cell]]
    
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
        self.cells = Array(repeating: Array(repeating: Cell(n: n, m: m), count: n*m), count: n*m)
        self.printCells()
    }
    
    init?(n: Int, m: Int, cells: [[Int?]]) {
        self.n = n
        self.m = m
        self.cells = Array(repeating: Array(repeating: Cell(n: n, m: m), count: n*m), count: n*m)
        
        if(cells.count != n*m) {
            return nil
        } else {
            for row in cells {
                if(row.count != n*m) {
                    return nil
                }
            }
        }
        
        for (rowIndex, row) in cells.enumerated() {
            for (index, cell) in row.enumerated() {
                if let value = cell {
                    self.cells[rowIndex][index].setVaule(value)
                }
            }
        }
        
        self.printCells()
    }
    
    //MARK: - Getters
    func getCells() -> [[Cell]] {
        return cells
    }
    
    func getGroupIndex(row: Int, col: Int) -> Int {
        return (row / n) * n + col / m
    }
    
    func getValuesFor(row: Int) -> [Int] {
        var values: [Int] = [Int]()
        
        for i in 0..<(n*m) {
            if let value = cells[row][i].value {
                values.append(value)
            }
        }
        
        return values
    }
    
    func getValuesFor(col: Int) -> [Int] {
        var values: [Int] = [Int]()
        
        for i in 0..<(n*m) {
            if let value = cells[i][col].value {
                values.append(value)
            }
        }
        
        return values
    }
    
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
        
        return values
    }
    
    //MARK: - Setters
    func setCell(row: Int, col: Int, to value: Int) {
        if(value > 0 && value <= n*m) {
            for i in 0..<n*m {
                cells[row][i].removePossibleValue(value)
                cells[i][col].removePossibleValue(value)
                
            }
            
            self.cells[row][col].setVaule(value)
        }
    }
    
    //MARK: Reseters
    func resetBoard() {
        for (rowIndex, row) in cells.enumerated() {
            for (index, cell) in row.enumerated() {
                self.cells[rowIndex][index].clear(n: n, m: m)
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
