//
//  ViewControllerFactory.swift
//  QuizApp
//
//  Created by Everest Liu on 9/15/23.
//

import QuizEngine
import UIKit

protocol ViewControllerFactory {
	typealias Answers = [(question: Question<String>, answer: [String])]

	func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController
	func resultsViewController(for userAnswers: Answers) -> UIViewController
}
