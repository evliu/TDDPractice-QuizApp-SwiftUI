//
//  ResultHelper.swift
//  QuizAppTests
//
//  Created by Everest Liu on 9/16/23.
//

@testable import QuizEngine

extension Result: Hashable {
	static func make(answers: [Question: Answer] = [:], score: Int = 0) -> Result<Question, Answer> {
		return Result(answers: answers, score: score)
	}

	public var hashValue: Int {
		return 1
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(1)
	}

	public static func ==(lhs: Result<Question, Answer>, rhs: Result<Question, Answer>) -> Bool {
		return lhs.score == rhs.score
	}
}
