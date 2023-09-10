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
	
	init(_ navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	typealias Question = String
	typealias Answer = String
	
	func routeTo(question: Question, answerCallback: @escaping AnswerCallback) {
		navigationController.pushViewController(UIViewController(), animated: false)
	}
	
	func routeTo(result: Result<Question, Answer>) {}
}
