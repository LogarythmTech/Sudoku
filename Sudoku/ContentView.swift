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
			Text("Sudoku").font(.title).fontWeight(.heavy)
			SudokuView(sud: sud)
			
			Text("Move: \(self.sud.lastMove)")
			
			Toggle(isOn: $sud.hideNotes) {
				Text("Hide Notes")
			}
			
			HStack {
				Button(action: {
					self.sud.solve()
				}) {
					Text("Solve")
						.padding(.leading).padding(.trailing)
						.background(Color.blue)
						.foregroundColor(.white)
						.font(.body)
						.cornerRadius(10)
				}
				
				Button(action: {
					self.sud.stepSolve()
				}) {
					Text("Step Solve")
						.padding(.leading).padding(.trailing)
						.background(Color.blue)
						.foregroundColor(.white)
						.font(.body)
						.cornerRadius(5)
				}
			}
			
			HStack {
				Button(action: {
					self.sud.resetBoard()
				}) {
					Text("Reset")
						.padding(.leading).padding(.trailing)
						.background(Color.blue)
						.foregroundColor(.white)
						.font(.body)
						.cornerRadius(5)
				}
				
				Button(action: {
					self.sud.gererate(difficulty: .Medium, given: 100)
				}) {
					Text("Generate")
						.padding(.leading).padding(.trailing)
						.background(Color.blue)
						.foregroundColor(.white)
						.font(.body)
						.cornerRadius(5)
				}
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
