//
//  ContentView.swift
//  Sudoku
//
//  Created by Logan Richards on 11/29/19.
//  Copyright © 2019 ZER0 Tech. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@ObservedObject var sud: Sudoku = Sudoku()
	
    var body: some View {
		VStack {
			Text("Sudoku")
			SudokuView(sud: sud)
			Toggle(isOn: $sud.hideNotes) {
				Text("Hide Notes")
			}
			
			Button(action: {
				self.sud.solve()
			}) {
				Text("Solve")
			}
			
			Button(action: {
				_ = self.sud.stepSolve()
			}) {
				Text("Step Solve")
			}
			
			Button(action: {
				self.sud.resetBoard()
			}) {
				Text("Reset")
			}
			
			Spacer()
		}.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
