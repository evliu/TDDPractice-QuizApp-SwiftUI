//
//  ResultsPresenter.swift
//  QuizApp
//
//  Created by Everest Liu on 9/16/23.
//

import QuizEngine
import UIKit

struct ResultsPresenter {
	let result: Result<Question<String>, [String]>
	let questions: [Question<String>]
	let correctAnswers: [Question<String>: [String]]
	var summary: String { "You got \(result.score)/\(result.answers.count) correct" }
	var title: String { "Result" }

	var presentableAnswers: [PresentableAnswer] {
		return questions.map { question in
			guard
				let userAnswer = result.answers[question],
				let correctAnswer = correctAnswers[question]
			else {
				fatalError("correctAnswer for question: \(question) not found")
			}

			return presentableAnswer(question, userAnswer, correctAnswer)
		}
	}

	private func presentableAnswer(
		_ question: Question<String>,
		_ userAnswer: [String],
		_ correctAnswer: [String]
	) -> PresentableAnswer {
		switch question {
			case .singleAnswer(let q), .multipleAnswer(let q):
				return PresentableAnswer(
					question: q,
					answer: formattedAnswer(correctAnswer),
					wrongAnswer: formattedWrongAnswer(userAnswer, correctAnswer)
				)
		}
	}

	private func formattedAnswer(_ answer: [String]) -> String {
		return answer.joined(separator: ", ")
	}

	private func formattedWrongAnswer(_ userAnswer: [String], _ correctAnswer: [String]) -> String? {
		return correctAnswer.sorted() == userAnswer.sorted() ? nil : userAnswer.joined(separator: ", ")
	}
}
