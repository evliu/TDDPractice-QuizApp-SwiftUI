//
//  QuestionHeader.swift
//  QuizApp
//
//  Created by Everest Liu on 9/28/23.
//

import SwiftUI

struct QuestionHeader: View {
	let title: String
	let question: String

	var body: some View {
		VStack(alignment: .leading, spacing: 16.0) {
			Text(title)
				.font(.headline)
				.fontWeight(.medium)
				.foregroundColor(Color.blue)
				.padding(.top)

			Text(question)
				.font(.largeTitle)
				.fontWeight(.medium)
		}.padding()
	}
}

#Preview {
	QuestionHeader(title: "2 of 3", question: "This is a question")
		.previewLayout(.sizeThatFits)
}
