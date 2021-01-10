//
//  CreatSudokuView.swift
//  Sudoku
//
//  Created by Logan Richards on 9/19/20.
//  Copyright © 2020 ZER0 Tech. All rights reserved.
//

import SwiftUI

struct CreatSudokuView: View {
	@ObservedObject var sud: Sudoku = Sudoku()
	@State var selectedCell: (row: Int, col: Int, group: Int)? = nil
	@State var fillNotes: Bool = false
	
	let frame: CGSize = CGSize(width: 400, height: 400)
	
	var body: some View {
		VStack {
			Text("Input in the puzzle you want to create")
			
			SudokuView(sud: self.sud, selectedCell: self.$selectedCell)
			
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
			
			
			HStack {
				Button(action: {
					if let select = selectedCell {
						self.sud.setCell(row: select.row, col: select.col, to: 0)
					}
				}) {
					Text("Clear Cell")
						.padding()
						.background(Color.blue)
						.foregroundColor(.white)
						.font(.body)
						.cornerRadius(5)
				}
				
				Button(action: {
					self.sud.wipeBoard()
				}) {
					Text("Clear Board")
						.padding()
						.background(Color.blue)
						.foregroundColor(.white)
						.font(.body)
						.cornerRadius(5)
				}
				
				NavigationLink(destination: SolveView(sud: self.sud).navigationBarTitle("Solve")) {
					Text("Set as Puzzle")
						.padding()
						.background(Color.blue)
						.foregroundColor(.white)
						.font(.body)
						.cornerRadius(5)
				}
			}
			
			Spacer()
		}.onAppear(perform: {self.sud.setGameModeToCreate()})
	}
}

struct CreatSudokuView_Previews: PreviewProvider {
    static var previews: some View {
        CreatSudokuView()
    }
}
