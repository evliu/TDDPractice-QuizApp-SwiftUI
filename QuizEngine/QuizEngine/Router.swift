//
//  Router.swift
//  QuizEngine
//
//  Created by Everest Liu on 9/8/23.
//

import Foundation

public protocol QuizDelegate {
	associatedtype Question: Hashable
	associatedtype Answer

	func handle(question: Question, answerCallback: @escaping (Answer) -> Void)
	func handle(result: Result<Question, Answer>)
}

@available(*, deprecated)
public protocol Router {
	associatedtype Question: Hashable
	associatedtype Answer

	func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
	func routeTo(result: Result<Question, Answer>)
}

/** TODO:
 1. add message for deprecated protocol
 2. remove Hashable from Question; make Result type Generic
 */
