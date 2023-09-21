//
//  Quiz.swift
//  QuizEngine
//
//  Created by Everest Liu on 9/21/23.
//

import Foundation

public final class Quiz {
	private let flow: Any

	private init(flow: Any) {
		self.flow = flow
	}

	public static func start<Delegate: QuizDelegate>(
		questions: [Delegate.Question],
		delegate: Delegate,
		correctAnswers: [Delegate.Question: Delegate.Answer]
	) -> Quiz where Delegate.Answer: Equatable {
		let flow = Flow(
			questions: questions,
			delegate: delegate,
			scoring: { scoring($0, correctAnswers: correctAnswers) }
		)

		flow.start()

		return Quiz(flow: flow)
	}
}

func scoring<Question: Hashable, Answer: Equatable>(_ answers: [Question: Answer], correctAnswers: [Question: Answer]) -> Int {
	var correctCount = 0
	answers.forEach { (key: Question, value: Answer) in
		if correctAnswers[key] == value {
			correctCount += 1
		}
	}

	return correctCount
}
