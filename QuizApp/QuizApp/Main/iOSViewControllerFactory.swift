//
//  iOSViewControllerFactory.swift
//  QuizApp
//
//  Created by Everest Liu on 9/15/23.
//

import QuizEngine
import UIKit

final class iOSViewControllerFactory: ViewControllerFactory {
	typealias Answers = [(question: Question<String>, answer: [String])]

	private let options: [Question<String>: [String]]
	private let correctAnswers: Answers
	private var questions: [Question<String>] { correctAnswers.map { $0.question }}

	init(options: [Question<String>: [String]], correctAnswers: Answers) {
		self.options = options
		self.correctAnswers = correctAnswers
	}

	func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
		guard let options = options[question] else {
			fatalError("no options for question \(question)")
		}

		return questionViewController(for: question, options: options, answerCallback: answerCallback)
	}

	private func questionViewController(for question: Question<String>, options: [String], answerCallback: @escaping ([String]) -> Void) -> UIViewController {
		switch question {
			case .singleAnswer(let value):
				return questionViewController(for: question, value: value, options: options, allowsMultipleSelection: false, answerCallback: answerCallback)

			case .multipleAnswer(let value):
				return questionViewController(for: question, value: value, options: options, allowsMultipleSelection: true, answerCallback: answerCallback)
		}
	}

	private func questionViewController(for question: Question<String>, value: String, options: [String], allowsMultipleSelection: Bool, answerCallback: @escaping ([String]) -> Void) -> QuestionViewController {
		let presenter = QuestionPresenter(currentQuestion: question, questions: questions)
		let controller = QuestionViewController(question: value, options: options, allowsMultipleSelection: allowsMultipleSelection, selection: answerCallback)
		controller.title = presenter.title

		return controller
	}

	func resultsViewController(for userAnswers: Answers) -> UIViewController {
		let presenter = ResultsPresenter(
			userAnswers: userAnswers,
			correctAnswers: correctAnswers,
			scorer: BasicScore.score
		)

		let controller = ResultsViewController(summary: presenter.summary, answers: presenter.presentableAnswers)
		controller.title = presenter.title

		return controller
	}

	func resultsViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
		let presenter = ResultsPresenter(
			userAnswers: questions.map { (question: $0, answers: result.answers[$0]!) },
			correctAnswers: correctAnswers,
			scorer: { _, _ in result.score }
		)

		let controller = ResultsViewController(summary: presenter.summary, answers: presenter.presentableAnswers)
		controller.title = presenter.title

		return controller
	}
}
