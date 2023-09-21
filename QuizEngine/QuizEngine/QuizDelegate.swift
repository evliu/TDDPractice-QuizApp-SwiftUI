//
//  QuizDelegate.swift
//  QuizEngine
//
//  Created by Everest Liu on 9/21/23.
//

import Foundation

public protocol QuizDelegate {
	associatedtype Question: Hashable
	associatedtype Answer

	func handle(question: Question, answerCallback: @escaping (Answer) -> Void)
	func handle(result: Result<Question, Answer>)
}
