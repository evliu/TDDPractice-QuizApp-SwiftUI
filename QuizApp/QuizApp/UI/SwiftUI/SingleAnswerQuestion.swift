//
//  SingleAnswerQuestion.swift
//  QuizApp
//
//  Created by Everest Liu on 9/28/23.
//

import SwiftUI

struct SingleAnswerQuestion: View {
	let title: String
	let question: String
	let options: [String]

	let selection: (String) -> Void

	var body: some View {
		VStack(alignment: .leading, spacing: 0.0) {
			QuestionHeader(title: title, question: question)

			ForEach(options, id: \.self) { option in
				SingleTextSelectionCell(text: option, select: {
					selection(option)
				})
			}
		}

		Spacer()
	}
}

#Preview {
	SingleAnswerQuestionTestView()
}

struct SingleAnswerQuestionTestView: View {
	@State var selected: String = "none "

	var body: some View {
		VStack {
			SingleAnswerQuestion(
				title: "1 of 2",
				question: "Question 1?",
				options: ["Answer 1", "Answer 2", "Answer 3", "Answer 4"],
				selection: { selected = $0 }
			)

			Text("Selected: \(selected)")
		}
	}
}
