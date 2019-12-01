//
//  ContentView.swift
//  Sudoku
//
//  Created by Logan Richards on 11/29/19.
//  Copyright © 2019 ZER0 Tech. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		SudokuView().padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
