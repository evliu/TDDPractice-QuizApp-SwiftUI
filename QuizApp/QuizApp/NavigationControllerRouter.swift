//
//  NavigationControllerRouter.swift
//  QuizApp
//
//  Created by Everest Liu on 9/9/23.
//

import QuizEngine
import UIKit

class NavigationControllerRouter: Router {
	private let navigationController: UINavigationController
	private let factory: ViewControllerFactory

	init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
		self.navigationController = navigationController
		self.factory = factory
	}

	func routeTo(question: Question<String>, answerCallback: @escaping ([String]) -> Void) {
		switch question {
			case .singleAnswer:
				show(factory.questionViewController(for: question, answerCallback: answerCallback))
			case .multipleAnswer:
				show(factory.questionViewController(for: question, answerCallback: { _ in }))
		}
	}

	func routeTo(result: Result<Question<String>, [String]>) {
		show(factory.resultsViewController(for: result))
	}

	private func show(_ viewController: UIViewController) {
		navigationController.pushViewController(viewController, animated: true)
	}
}
