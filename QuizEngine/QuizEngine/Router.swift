//
//  Router.swift
//  QuizEngine
//
//  Created by Everest Liu on 9/8/23.
//

import Foundation

public protocol Router {
	associatedtype Question: Hashable
	associatedtype Answer

	func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
	func routeTo(result: Result<Question, Answer>)
}
