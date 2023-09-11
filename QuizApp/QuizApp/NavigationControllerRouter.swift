//
//  NavigationControllerRouter.swift
//  QuizApp
//
//  Created by Everest Liu on 9/9/23.
//

import QuizEngine
import UIKit

protocol ViewControllerFactory {
	func questionViewController(for question: String, answerCallback: @escaping (String) -> Void) -> UIViewController
}

class NavigationControllerRouter: Router {
	private let navigationController: UINavigationController
	private let factory: ViewControllerFactory

	init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
		self.navigationController = navigationController
		self.factory = factory
	}

	typealias Question = String
	typealias Answer = String

	func routeTo(question: Question, answerCallback: @escaping AnswerCallback) {
		let viewController = factory.questionViewController(for: question, answerCallback: answerCallback)
		navigationController.pushViewController(viewController, animated: true)
	}

	func routeTo(result: Result<Question, Answer>) {}
}
