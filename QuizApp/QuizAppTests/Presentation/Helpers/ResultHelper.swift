//
//  ResultHelper.swift
//  QuizAppTests
//
//  Created by Everest Liu on 9/16/23.
//

@testable import QuizEngine

extension Result {
	static func make(answers: [Question: Answer] = [:], score: Int = 0) -> Result<Question, Answer> {
		return Result(answers: answers, score: score)
	}
}

extension Result: Hashable where Answer: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(answers)
		hasher.combine(score)
	}
}

extension Result: Equatable where Answer: Equatable {
	public static func ==(lhs: Result<Question, Answer>, rhs: Result<Question, Answer>) -> Bool {
		return lhs.score == rhs.score && lhs.answers == rhs.answers
	}
}
