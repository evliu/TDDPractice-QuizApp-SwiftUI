//
//  MultipleTextSelectionCell.swift
//  QuizApp
//
//  Created by Everest Liu on 9/28/23.
//

import SwiftUI

struct MultipleTextSelectionCell: View {
	@Binding var option: MultipleSelectionOption

	var body: some View {
		Button(action: { option.select() }) {
			HStack {
				Rectangle()
					.strokeBorder(option.isSelected ? .blue : .secondary, lineWidth: 2.5)
					.overlay(
						Rectangle()
							.fill(option.isSelected ? .blue : .clear)
							.frame(width: 26, height: 26)
					)
					.frame(width: 40.0, height: 40.0)

				Text(option.text)
					.font(.title)
					.foregroundColor(option.isSelected ? .blue : .secondary)

				Spacer()
			}.padding()
		}
	}
}

#Preview {
	VStack {
		MultipleTextSelectionCell(option: .constant(.init(text: "Answer text", isSelected: false))).previewLayout(.sizeThatFits)
		MultipleTextSelectionCell(option: .constant(.init(text: "Answer text", isSelected: true))).previewLayout(.sizeThatFits)
	}
}
