//
//  iOSViewControllerFactory.swift
//  QuizApp
//
//  Created by Everest Liu on 9/15/23.
//

import QuizEngine
import UIKit

class iOSViewControllerFactory: ViewControllerFactory {
	private let options: [Question<String>: [String]]

	init(options: [Question<String>: [String]]) {
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
				return QuestionViewController(question: value, options: options, selection: answerCallback)

			case .multipleAnswer(let value):
				let controller = QuestionViewController(question: value, options: options, selection: answerCallback)
				controller.loadViewIfNeeded()
				controller.tableView.allowsMultipleSelection = true

				return controller
		}
	}

	func resultsViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
		return UIViewController()
	}
}
