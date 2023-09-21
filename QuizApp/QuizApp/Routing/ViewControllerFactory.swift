//
//  ViewControllerFactory.swift
//  QuizApp
//
//  Created by Everest Liu on 9/15/23.
//

import QuizEngine
import UIKit

protocol ViewControllerFactory {
	func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController

	func resultsViewController(for result: Result<Question<String>, [String]>) -> UIViewController
}
