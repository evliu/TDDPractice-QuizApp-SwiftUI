//
//  Game.swift
//  QuizEngine
//
//  Created by Everest Liu on 9/8/23.
//

import Foundation

@available(*, deprecated)
public class Game<Question: Hashable, Answer, R: Router> where R.Question == Question, R.Answer == Answer {
	let flow: Flow<R>

	init(flow: Flow<R>) {
		self.flow = flow
	}
}

@available(*, deprecated)
public func startGame<Question: Hashable, Answer: Equatable, R: Router>(
	questions: [Question],
	router: R,
	correctAnswers: [Question: Answer]
) -> Game<Question, Answer, R> where R.Question == Question, R.Answer == Answer {
	let flow = Flow(questions: questions, router: router) { scoring($0, correctAnswers: correctAnswers) }

	flow.start()

	return Game(flow: flow)
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

/**
 1. deprecate startGame function
 2. deprecate Game class
 */
