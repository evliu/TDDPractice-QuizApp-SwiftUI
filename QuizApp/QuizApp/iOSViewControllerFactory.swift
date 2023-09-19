//
//  iOSViewControllerFactory.swift
//  QuizApp
//
//  Created by Everest Liu on 9/15/23.
//

import QuizEngine
import UIKit

class iOSViewControllerFactory: ViewControllerFactory {
	private let questions: [Question<String>]
	private let options: [Question<String>: [String]]

	init(questions: [Question<String>], options: [Question<String>: [String]]) {
		self.questions = questions
		self.options = options
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

	func resultsViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
		return UIViewController()
	}
}
