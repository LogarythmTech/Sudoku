//
//  ScanBoardView.swift
//  Sudoku
//
//  Created by Logan Richards on 1/8/21.
//  Copyright © 2021 ZER0 Tech. All rights reserved.
//

import SwiftUI
import Vision

struct ScanBoardView: View {
    var body: some View {
		ScannerViewController()
    }
}

extension ScannerViewController : UIViewControllerRepresentable {
	public typealias UIViewControllerType = ScannerViewController
	
	
	
	public func makeUIViewController(context: UIViewControllerRepresentableContext<ScannerViewController>) -> ScannerViewController {
		return ScannerViewController()
	}
	
	public func updateUIViewController(_ uiViewController: ScannerViewController, context: UIViewControllerRepresentableContext<ScannerViewController>) {
	}
}


struct ScanBoardView_Previews: PreviewProvider {
    static var previews: some View {
        ScanBoardView()
    }
}
