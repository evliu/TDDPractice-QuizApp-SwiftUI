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
	let flow = Flow(questions: questions, delegate: QuizDelegateToRouterAdapter(router, correctAnswers))

	flow.start()

	return Game(flow: flow)
}

@available(*, deprecated)
private class QuizDelegateToRouterAdapter<R: Router>: QuizDelegate where R.Answer: Equatable {
	private let router: R
	private let correctAnswers: [R.Question: R.Answer]

	init(_ router: R, _ correctAnswers: [R.Question: R.Answer]) {
		self.router = router
		self.correctAnswers = correctAnswers
	}

	func didCompleteQuiz(withAnswers answers: [(question: R.Question, answer: R.Answer)]) {
		let answers = answers.reduce([R.Question: R.Answer]()) { acc, tuple in
			var acc = acc
			acc[tuple.question] = tuple.answer

			return acc
		}

		let score = scoring(answers, correctAnswers: correctAnswers)
		let result = Result(answers: answers, score: score)
		router.routeTo(result: result)
	}

	func answer(for question: R.Question, completion: @escaping (R.Answer) -> Void) {
		router.routeTo(question: question, answerCallback: completion)
	}

	private func scoring(_ answers: [R.Question: R.Answer], correctAnswers: [R.Question: R.Answer]) -> Int {
		return answers.reduce(0) { score, tuple in
			score + (correctAnswers[tuple.key] == tuple.value ? 1 : 0)
		}
	}
}

@available(*, deprecated)
public protocol Router {
	associatedtype Question: Hashable
	associatedtype Answer

	func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
	func routeTo(result: Result<Question, Answer>)
}
