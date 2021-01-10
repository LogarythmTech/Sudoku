//
//  StartView.swift
//  Sudoku
//
//  Created by Logan Richards on 8/29/20.
//  Copyright © 2020 ZER0 Tech. All rights reserved.
//

import SwiftUI

struct StartView: View {
    var body: some View {
		NavigationView {
			VStack {
				NavigationLink(destination: ScanBoardView().navigationBarTitle("Scan Board")) {
					Text("Scan")
				}
				
				NavigationLink(destination: CreatSudokuView().navigationBarTitle("Set Puzzle")) {
					Text("Solve")
				}
				
				Text("Play")
				
				HStack {
					Text("Easy")
					Text("Medium")
					Text("Hard")
					Text("Expert")
				}
				
				NavigationLink(destination: HowToView().navigationBarTitle("How To")) {
					Text("How To")
				}
			}.navigationBarTitle("Sudoku")
		}
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
