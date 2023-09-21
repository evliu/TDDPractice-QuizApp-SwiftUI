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

	func answer(for question: Question, completion: @escaping (Answer) -> Void)

	func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)])

	@available(*, deprecated, message: "use didCompleteQuiz(withAnswers:)")
	func handle(result: Result<Question, Answer>)
}

//default implementation for new API
public extension QuizDelegate {
	func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)]) {
		
	}
}
