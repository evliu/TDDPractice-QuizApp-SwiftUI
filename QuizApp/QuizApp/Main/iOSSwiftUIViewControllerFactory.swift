//
//  iOSSwiftUIViewControllerFactory.swift
//  QuizApp
//
//  Created by Everest Liu on 9/15/23.
//

import QuizEngine
import SwiftUI

final class iOSSwiftUIViewControllerFactory: ViewControllerFactory {
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
		let presenter = QuestionPresenter(currentQuestion: question, questions: questions)

		switch question {
			case .singleAnswer(let value):
				return UIHostingController(
					rootView: SingleAnswerQuestionView(
						title: presenter.title,
						question: value,
						options: options,
						selection: { answerCallback([$0]) }
					)
				)

			case .multipleAnswer(let value):
				return UIHostingController(
					rootView: MultipleAnswerQuestionView(
						title: presenter.title,
						question: value,
						store: .init(options: options, handler: answerCallback)
					)
				)
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
}
