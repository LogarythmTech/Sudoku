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
	@State var selectedCell: (row: Int, col: Int, group: Int)? = nil
	@State var fillNotes: Bool = false
	
    var body: some View {
		VStack(spacing: 10) {
			Text("Sudoku").font(.title).fontWeight(.heavy)
			SudokuView(sud: sud, selectedCell: $selectedCell)
			
			HStack {
				numberButtonView(number: 1, sud: self.sud, selectedCell: $selectedCell, fillNotes: $fillNotes)
				numberButtonView(number: 2, sud: self.sud, selectedCell: $selectedCell, fillNotes: $fillNotes)
				numberButtonView(number: 3, sud: self.sud, selectedCell: $selectedCell, fillNotes: $fillNotes)
				numberButtonView(number: 4, sud: self.sud, selectedCell: $selectedCell, fillNotes: $fillNotes)
				numberButtonView(number: 5, sud: self.sud, selectedCell: $selectedCell, fillNotes: $fillNotes)
				numberButtonView(number: 6, sud: self.sud, selectedCell: $selectedCell, fillNotes: $fillNotes)
				numberButtonView(number: 7, sud: self.sud, selectedCell: $selectedCell, fillNotes: $fillNotes)
				numberButtonView(number: 8, sud: self.sud, selectedCell: $selectedCell, fillNotes: $fillNotes)
				numberButtonView(number: 9, sud: self.sud, selectedCell: $selectedCell, fillNotes: $fillNotes)
			}.padding(.leading).padding(.trailing)
			
			Text("Move: \(self.sud.lastMove)")
			
			HStack {
				Button(action: {
					self.fillNotes = !self.fillNotes
				}) {
					Text(self.sud.hideNotes ? "Notes Off" : "Notes On")
						.padding()
						.background(Color.blue)
						.foregroundColor(.white)
						.font(.body)
						.cornerRadius(5)
				}
				
				Button(action: {
					self.sud.hideNotes = !self.sud.hideNotes
				}) {
					Text(self.sud.hideNotes ? "Show Notes" : "Hide Notes")
						.padding()
						.background(Color.blue)
						.foregroundColor(.white)
						.font(.body)
						.cornerRadius(5)
				}
				
				Button(action: {
					//self.sud.gererate(difficulty: .Medium, given: 100)
				}) {
					Text("Check")
						.padding()
						.background(Color.blue)
						.foregroundColor(.white)
						.font(.body)
						.cornerRadius(5)
				}
				
				Button(action: {
					self.sud.solve()
				}) {
					Text("Solve")
						.padding()
						.background(Color.blue)
						.foregroundColor(.white)
						.font(.body)
						.cornerRadius(5)
				}
				
				Button(action: {
					self.sud.stepSolve()
				}) {
					Text("Step Solve")
						.padding()
						.background(Color.blue)
						.foregroundColor(.white)
						.font(.body)
						.cornerRadius(5)
				}

				Button(action: {
					self.sud.resetBoard()
				}) {
					Text("Reset")
						.padding()
						.background(Color.blue)
						.foregroundColor(.white)
						.font(.body)
						.cornerRadius(5)
				}
				
				Button(action: {
					self.sud.gererate(difficulty: .Medium, given: 100)
				}) {
					Text("Generate")
						.padding()
						.background(Color.blue)
						.foregroundColor(.white)
						.font(.body)
						.cornerRadius(5)
				}
			}
			
			Spacer()
		}.padding()
		
		//estView()
    }
}


struct numberButtonView : View {
	let number: Int
	@ObservedObject var sud: Sudoku
	@Binding var selectedCell: (row: Int, col: Int, group: Int)?
	@Binding var fillNotes: Bool
	
	var imageName: String {
		get {
			switch self.number {
			case 1:
				return "1.square.fill"
			case 2:
				return "2.square.fill"
			case 3:
				return "3.square.fill"
			case 4:
				return "4.square.fill"
			case 5:
				return "5.square.fill"
			case 6:
				return "6.square.fill"
			case 7:
				return "7.square.fill"
			case 8:
				return "8.square.fill"
			case 9:
				return "9.square.fill"
			default:
				return "1.square.fill"
			}
		}
	}
	
	var body : some View {
		Button(action: {
			if let select = self.selectedCell {
				if(self.fillNotes) {
					//TODO: self.sud.set
				} else {
					self.sud.setCell(row: select.row, col: select.col, to: self.number)
				}
			}
		}) {
			Image(systemName: self.imageName).resizable().aspectRatio(1, contentMode: .fit)
		}
	}
	
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
