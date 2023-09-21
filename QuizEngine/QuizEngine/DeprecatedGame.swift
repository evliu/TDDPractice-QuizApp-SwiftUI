//
//  Game.swift
//  QuizEngine
//
//  Created by Everest Liu on 9/8/23.
//

import Foundation

@available(*, deprecated)
public class Game<Question: Hashable, Answer, R: Router> {
	let flow: Any

	init(flow: Any) {
		self.flow = flow
	}
}

@available(*, deprecated)
public func startGame<Question: Hashable, Answer: Equatable, R: Router>(
	questions: [Question],
	router: R,
	correctAnswers: [Question: Answer]
) -> Game<Question, Answer, R> where R.Question == Question, R.Answer == Answer {
	let flow = Flow(questions: questions, delegate: QuizDelegateToRouterAdapter(router)) { scoring($0, correctAnswers: correctAnswers) }

	flow.start()

	return Game(flow: flow)
}

@available(*, deprecated)
private class QuizDelegateToRouterAdapter<R: Router>: QuizDelegate {
	private let router: R

	init(_ router: R) {
		self.router = router
	}

	func handle(result: Result<R.Question, R.Answer>) {
		router.routeTo(result: result)
	}

	func handle(question: R.Question, answerCallback: @escaping (R.Answer) -> Void) {
		router.routeTo(question: question, answerCallback: answerCallback)
	}
}

private func scoring<Question: Hashable, Answer: Equatable>(_ answers: [Question: Answer], correctAnswers: [Question: Answer]) -> Int {
	var correctCount = 0
	answers.forEach { (key: Question, value: Answer) in
		if correctAnswers[key] == value {
			correctCount += 1
		}
	}

	return correctCount
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

/**
 1. deprecate startGame function
 2. deprecate Game class
 3. deprecate adapter
 */
