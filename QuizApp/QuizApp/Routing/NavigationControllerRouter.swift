//
//  NavigationControllerRouter.swift
//  QuizApp
//
//  Created by Everest Liu on 9/9/23.
//

import QuizEngine
import UIKit

class NavigationControllerRouter: Router, QuizDelegate {
	private let navigationController: UINavigationController
	private let factory: ViewControllerFactory

	init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
		self.navigationController = navigationController
		self.factory = factory
	}

	func answer(for question: QuizEngine.Question<String>, completion: @escaping ([String]) -> Void) {
		switch question {
			case .singleAnswer:
				show(factory.questionViewController(for: question, answerCallback: completion))

			case .multipleAnswer:
				let button = UIBarButtonItem(title: "Submit", style: .done, target: nil, action: nil)
				let buttonController = SubmitButtonController(button, completion)
				let controller = factory.questionViewController(for: question, answerCallback: { selection in
					buttonController.update(selection)
				})
				controller.navigationItem.rightBarButtonItem = button

				show(controller)
		}
	}

	func didCompleteQuiz(withAnswers answers: [(question: QuizEngine.Question<String>, answer: [String])]) {
		show(factory.resultsViewController(for: answers.map { $0 }))
	}

	func routeTo(question: Question<String>, answerCallback: @escaping ([String]) -> Void) {
		answer(for: question, completion: answerCallback)
	}

	func routeTo(result: Result<Question<String>, [String]>) {
		show(factory.resultsViewController(for: result))
	}

	private func show(_ viewController: UIViewController) {
		navigationController.pushViewController(viewController, animated: true)
	}
}

// conform to NSObject so button.performSelector(button.action can work
private class SubmitButtonController: NSObject {
	let button: UIBarButtonItem
	let callback: ([String]) -> Void
	private var model: [String] = []

	init(_ button: UIBarButtonItem, _ callback: @escaping ([String]) -> Void) {
		self.button = button
		self.callback = callback
		super.init()
		setup()
	}

	private func setup() {
		button.target = self
		button.action = #selector(fireCallback)
		updateButtonState()
	}

	func update(_ model: [String]) {
		self.model = model
		updateButtonState()
	}

	private func updateButtonState() {
		button.isEnabled = !model.isEmpty
	}

	@objc private func fireCallback() {
		callback(model)
	}
}
