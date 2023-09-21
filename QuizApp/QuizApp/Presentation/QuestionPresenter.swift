//
//  QuestionPresenter.swift
//  QuizApp
//
//  Created by Everest Liu on 9/17/23.
//

import QuizEngine

struct QuestionPresenter {
	let currentQuestion: Question<String>
	let questions: [Question<String>]

	var title: String {
		guard let idx = questions.firstIndex(of: currentQuestion) else { return "" }

		return "Question #\(idx + 1)"
	}
}
