//
//  TestView.swift
//  Sudoku
//
//  Created by Logan Richards on 12/10/19.
//  Copyright © 2019 ZER0 Tech. All rights reserved.
//

import SwiftUI

let myBackgroundColor: Color = .white
let myForegroundColor: Color = .black
let myHighlightColor: Color = .blue

struct TestView: View {
	@State var text: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8]
	@State var selectedIndex: Int? = nil
	
    var body: some View {
		VStack(spacing: 10) {
			HStack {
				TestCellView(index: 0, selectedIndex: $selectedIndex, text: $text)
				TestCellView(index: 1, selectedIndex: $selectedIndex, text: $text)
				TestCellView(index: 2, selectedIndex: $selectedIndex, text: $text)
				TestCellView(index: 3, selectedIndex: $selectedIndex, text: $text)
				TestCellView(index: 4, selectedIndex: $selectedIndex, text: $text)
				TestCellView(index: 5, selectedIndex: $selectedIndex, text: $text)
				TestCellView(index: 6, selectedIndex: $selectedIndex, text: $text)
				TestCellView(index: 7, selectedIndex: $selectedIndex, text: $text)
				TestCellView(index: 8, selectedIndex: $selectedIndex, text: $text)
			}
			
			HStack {
				TestButtonView(number: 1, selectedIndex: $selectedIndex, text: $text)
				TestButtonView(number: 2, selectedIndex: $selectedIndex, text: $text)
				TestButtonView(number: 3, selectedIndex: $selectedIndex, text: $text)
				TestButtonView(number: 4, selectedIndex: $selectedIndex, text: $text)
				TestButtonView(number: 5, selectedIndex: $selectedIndex, text: $text)
				TestButtonView(number: 6, selectedIndex: $selectedIndex, text: $text)
				TestButtonView(number: 7, selectedIndex: $selectedIndex, text: $text)
				TestButtonView(number: 8, selectedIndex: $selectedIndex, text: $text)
				TestButtonView(number: 9, selectedIndex: $selectedIndex, text: $text)
			}
			
			
		}
    }
}


struct TestCellView: View {
	let index: Int
	@Binding var selectedIndex: Int?
	@Binding var text: [Int]
	var hide: Bool = false
	
	var imageName: String {
		get {
			switch self.text[index] {
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
			self.selectedIndex = self.index
		}) {
			ZStack {
				Circle().foregroundColor(myForegroundColor)
				
				Image(systemName: imageName)
					.resizable()
					.foregroundColor((self.selectedIndex == self.index) ? myHighlightColor : myBackgroundColor)
			}
		}.background((self.selectedIndex == self.index) ? myHighlightColor : myBackgroundColor)
		.aspectRatio(1, contentMode: .fit)
	}
}

struct TestButtonView: View {
	let number: Int
	@Binding var selectedIndex: Int?
	@Binding var text: [Int]
	
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
			if let index = self.selectedIndex {
				if(index >= 0 && index < self.text.count) {
					self.text[index] = self.number
				}
			}
		}) {
			Image(systemName: imageName)
				.resizable()
				.aspectRatio(1, contentMode: .fit).border(Color.blue, width: 1)
		}
	}
}


struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
