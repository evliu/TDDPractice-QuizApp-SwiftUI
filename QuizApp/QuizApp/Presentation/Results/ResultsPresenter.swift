//
//  ResultsPresenter.swift
//  QuizApp
//
//  Created by Everest Liu on 9/16/23.
//

import QuizEngine
import UIKit

final class ResultsPresenter {
	typealias Answers = [(question: Question<String>, answers: [String])]
	typealias Scorer = ([[String]], [[String]]) -> Int

	private let userAnswers: Answers
	private let correctAnswers: Answers
	private let scorer: Scorer

	private var score: Int { scorer(userAnswers.map { $0.answers }, correctAnswers.map { $0.answers }) }

	var summary: String { "You got \(score)/\(userAnswers.count) correct" }
	var title: String { "Result" }

	init(result: Result<Question<String>, [String]>, questions: [Question<String>], correctAnswers: [Question<String>: [String]]) {
		self.userAnswers = questions.map { (question: $0, answers: result.answers[$0]!) }

		self.correctAnswers = questions.filter { question in correctAnswers.keys.contains { q in q == question }}.map { (question: $0, answers: correctAnswers[$0]!) }
		self.scorer = { _, _ in result.score }
	}

	var presentableAnswers: [PresentableAnswer] {
		return zip(userAnswers, correctAnswers).map { userAnswer, correctAnswer in
			presentableAnswer(userAnswer.question, userAnswer.answers, correctAnswer.answers)
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
