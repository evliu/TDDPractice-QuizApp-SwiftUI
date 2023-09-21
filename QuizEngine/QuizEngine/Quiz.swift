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

	public static func start<Question, Answer: Equatable, Delegate: QuizDelegate>(
		questions: [Question],
		delegate: Delegate,
		correctAnswers: [Question: Answer]
	) -> Quiz where Delegate.Question == Question, Delegate.Answer == Answer {
		let flow = Flow(questions: questions, delegate: delegate) { scoring($0, correctAnswers: correctAnswers) }

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
