//
//  Game.swift
//  QuizEngine
//
//  Created by Everest Liu on 9/8/23.
//

import Foundation

@available(*, deprecated, message: "Replaced with QuizDelegate")
public protocol Router {
	associatedtype Question: Hashable
	associatedtype Answer

	func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
	func routeTo(result: Result<Question, Answer>)
}

@available(*, deprecated, message: "Scoring is deprecated. Please implement it in your client")
public struct Result<Question: Hashable, Answer> {
	public let answers: [Question: Answer]
	public let score: Int
}

@available(*, deprecated, message: "Replaced with Quiz")
public class Game<Question: Hashable, Answer, R: Router> {
	let quiz: Quiz

	init(quiz: Quiz) {
		self.quiz = quiz
	}
}

@available(*, deprecated, message: "Replaced with Quiz.start()")
public func startGame<Question: Hashable, Answer: Equatable, R: Router>(
	questions: [Question],
	router: R,
	correctAnswers: [Question: Answer]
) -> Game<Question, Answer, R> where R.Question == Question, R.Answer == Answer {
	let adapter = QuizDelegateToRouterAdapter(router, correctAnswers)
	let quiz = Quiz.start(questions: questions, delegate: adapter)

	return Game(quiz: quiz)
}

@available(*, deprecated, message: "Removed with deprecated Game types")
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
