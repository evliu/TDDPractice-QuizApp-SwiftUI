//
//  MultipleAnswerQuestionView.swift
//  QuizApp
//
//  Created by Everest Liu on 9/30/23.
//

import SwiftUI

struct MultipleAnswerQuestionView: View {
	let title: String
	let question: String
	@State var store: MultipleSelectionState

	var body: some View {
		VStack(alignment: .leading, spacing: 0.0) {
			QuestionHeader(title: title, question: question)

			ForEach(store.options.indices) { MultipleTextSelectionCell(option: $store.options[$0]) }
		}

		Spacer()

		Button(action: store.submit) {
			HStack {
				Spacer()
				Text("Submit")
					.foregroundStyle(.white)
					.font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/)
					.padding()
				Spacer()
			}
			.background(.blue)
			.cornerRadius(25)
		}
		.buttonStyle(.plain)
		.disabled(!store.canSubmit)
		.padding()
	}
}

#Preview {
	MultipleAnswerQuestionTestView()
}

struct MultipleAnswerQuestionTestView: View {
	@State var selected = ["none"]

	var body: some View {
		VStack {
			MultipleAnswerQuestionView(
				title: "1 of 2",
				question: "Question 1?",
				store: .init(
					options: ["Answer 1", "Answer 2", "Answer 3", "Answer 4"],
					handler: { selected = $0 }
				)
			)

			Text("Submitted: \(selected.joined(separator: ", "))")
		}
	}
}
