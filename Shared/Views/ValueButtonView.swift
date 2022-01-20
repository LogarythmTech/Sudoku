//
//  PlayButtonsView.swift
//  Sudoku (iOS)
//
//  Created by Logan Richards on 1/20/22.
//

import SwiftUI

struct ValueButtonView: View {
    @EnvironmentObject var sudoku: Sudoku
    let value: Int
    
    var body: some View {
        Button {
            sudoku.setValueForSelectedCell(to: value)
        } label: {
            Text(String(value))
                .font(.system(size: 500, weight: .bold))
                .minimumScaleFactor(0.001)
        }.buttonStyle(BlueButton())

    }
}

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            //.padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct PlayButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ValueButtonView(value: 3)
    }
}
