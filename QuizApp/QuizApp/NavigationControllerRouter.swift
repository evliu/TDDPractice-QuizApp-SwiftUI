//
//  NavigationControllerRouter.swift
//  QuizApp
//
//  Created by Everest Liu on 9/9/23.
//

import QuizEngine
import UIKit

protocol ViewControllerFactory {
	func questionViewController(for question: Question<String>, answerCallback: @escaping (String) -> Void) -> UIViewController

	func resultsViewController(for result: Result<Question<String>, String>) -> UIViewController
}

class NavigationControllerRouter: Router {
	private let navigationController: UINavigationController
	private let factory: ViewControllerFactory

	init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
		self.navigationController = navigationController
		self.factory = factory
	}

	func routeTo(question: Question<String>, answerCallback: @escaping AnswerCallback) {
		show(factory.questionViewController(for: question, answerCallback: answerCallback))
	}

	func routeTo(result: Result<Question<String>, String>) {
		show(factory.resultsViewController(for: result))
	}

	private func show(_ viewController: UIViewController) {
		navigationController.pushViewController(viewController, animated: true)
	}
}
