//
//  SingleTextSelectionCell.swift
//  QuizApp
//
//  Created by Everest Liu on 9/28/23.
//

import SwiftUI

struct SingleTextSelectionCell: View {
	let text: String
	let select: () -> Void

	var body: some View {
		Button(action: select) {
			HStack {
				Circle()
					.stroke(Color.secondary, lineWidth: 2.5)
					.frame(width: 40.0, height: 40.0)

				Text(text)
					.font(.title)
					.foregroundColor(Color.secondary)

				Spacer()
			}.padding()
		}
	}
}

#Preview {
	SingleTextSelectionCell(text: "Answer text", select: {}).previewLayout(.sizeThatFits)
}
