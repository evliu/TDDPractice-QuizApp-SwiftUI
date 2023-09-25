//
//  ScoreTest.swift
//  QuizEngine
//
//  Created by Everest Liu on 9/25/23.
//

import XCTest

final class ScoreTest: XCTestCase {
	func test_noAnswers_scoresZero() {
		XCTAssertEqual(BasicScore.score(for: [], comparingTo: []), 0)
	}

	func test_oneNonMatchingAnswer_scoresZero() {
		XCTAssertEqual(BasicScore.score(for: ["user answer"], comparingTo: ["other answer"]), 0)
	}

	func test_oneMatchingAnswer_scoresOne() {
		XCTAssertEqual(BasicScore.score(for: ["first answer"], comparingTo: ["first answer"]), 1)
	}

	func test_oneMatchingOneNonMatchingAnswer_scoresOne() {
		let score = BasicScore.score(
			for: ["first answer", "another answer"],
			comparingTo: ["first answer", "second answer"]
		)

		XCTAssertEqual(score, 1)
	}

	func test_twoMatchingAnswers_scoresTwo() {
		let score = BasicScore.score(
			for: ["first answer", "second answer"],
			comparingTo: ["first answer", "second answer"]
		)

		XCTAssertEqual(score, 2)
	}

	func test_withTooManyAnswers_twoMatchingAnswers_scoresTwo() {
		let score = BasicScore.score(
			for: ["first answer", "second answer", "extra"],
			comparingTo: ["first answer", "second answer"]
		)

		XCTAssertEqual(score, 2)
	}

	func test_withTooManyCorrectAnswers_oneMatchingAnswers_scoresOne() {
		let score = BasicScore.score(
			for: ["not matching", "second answer"],
			comparingTo: ["first answer", "second answer", "extra"]
		)

		XCTAssertEqual(score, 1)
	}

	private enum BasicScore {
		static func score(for answers: [String], comparingTo correctAnswers: [String] = []) -> Int {
			if answers.isEmpty { return 0 }

			return zip(answers, correctAnswers).reduce(0) { score, tuple in
				score + (tuple.0 == tuple.1 ? 1 : 0)
			}
		}
	}
}
