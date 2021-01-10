//
//  SudokuBorderView.swift
//  SudokuSolver
//
//  Created by Logan Richards on 8/29/20.
//

import SwiftUI

struct SudokuBorderView: View {
	let frame: CGSize

    var body: some View {
		ZStack {
			Path { path in
				path.move(to: CGPoint(x: 0, y: 0))
				path.addRect(CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
			}.stroke(Color.black, lineWidth: 5)
			.frame(width: self.frame.width, height: self.frame.height)
			
			Path { path in
				path.move(to: CGPoint(x: self.frame.width/3, y: 0))
				path.addLine(to: CGPoint(x: self.frame.width/3, y: self.frame.height))
				
				path.move(to: CGPoint(x: 2*self.frame.width/3, y: 0))
				path.addLine(to: CGPoint(x: 2*self.frame.width/3, y: self.frame.height))
				
				path.move(to: CGPoint(x: 0, y: self.frame.height/3))
				path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height/3))
				
				path.move(to: CGPoint(x: 0, y: 2*self.frame.height/3))
				path.addLine(to: CGPoint(x: self.frame.width, y: 2*self.frame.height/3))
			}.stroke(Color.black, lineWidth: 3)
			.frame(width: self.frame.width, height: self.frame.height)
			
			Path { path in
				path.move(to: CGPoint(x: self.frame.width/9, y: 0))
				path.addLine(to: CGPoint(x: self.frame.width/9, y: self.frame.height))
				
				path.move(to: CGPoint(x: 2*self.frame.width/9, y: 0))
				path.addLine(to: CGPoint(x: 2*self.frame.width/9, y: self.frame.height))
				
				path.move(to: CGPoint(x: 4*self.frame.width/9, y: 0))
				path.addLine(to: CGPoint(x: 4*self.frame.width/9, y: self.frame.height))
				
				path.move(to: CGPoint(x: 5*self.frame.width/9, y: 0))
				path.addLine(to: CGPoint(x: 5*self.frame.width/9, y: self.frame.height))
				
				path.move(to: CGPoint(x: 7*self.frame.width/9, y: 0))
				path.addLine(to: CGPoint(x: 7*self.frame.width/9, y: self.frame.height))
				
				path.move(to: CGPoint(x: 8*self.frame.width/9, y: 0))
				path.addLine(to: CGPoint(x: 8*self.frame.width/9, y: self.frame.height))
				
				path.move(to: CGPoint(x: 0, y: self.frame.height/9))
				path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height/9))
				
				path.move(to: CGPoint(x: 0, y: 2*self.frame.height/9))
				path.addLine(to: CGPoint(x: self.frame.width, y: 2*self.frame.height/9))
				
				path.move(to: CGPoint(x: 0, y: 4*self.frame.height/9))
				path.addLine(to: CGPoint(x: self.frame.width, y: 4*self.frame.height/9))
				
				path.move(to: CGPoint(x: 0, y: 5*self.frame.height/9))
				path.addLine(to: CGPoint(x: self.frame.width, y: 5*self.frame.height/9))
				
				path.move(to: CGPoint(x: 0, y: 7*self.frame.height/9))
				path.addLine(to: CGPoint(x: self.frame.width, y: 7*self.frame.height/9))
				
				path.move(to: CGPoint(x: 0, y: 8*self.frame.height/9))
				path.addLine(to: CGPoint(x: self.frame.width, y: 8*self.frame.height/9))
			}.stroke(Color.black, lineWidth: 1)
			.frame(width: self.frame.width, height: self.frame.height)
		}
    }
}

struct SudokuBorderView_Previews: PreviewProvider {
    static var previews: some View {
        SudokuBorderView(frame: CGSize(width: 400, height: 400))
    }
}
