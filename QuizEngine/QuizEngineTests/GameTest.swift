//
//  GameTest.swift
//  QuizEngineTests
//
//  Created by Everest Liu on 9/8/23.
//

import QuizEngine
import XCTest

final class GameTest: XCTestCase {
	let router = RouterSpy()
	var game: Game<String, String, RouterSpy>!

	func test_startGame_answerZeroOutOfTwoCorrectly_scores0() {
		game = startGame(
			questions: ["Q1", "Q2"],
			router: router,
			correctAnswers: ["Q1": "A1", "Q2": "A2"]
		)

		router.answerCallback("wrong")
		router.answerCallback("wrong")

		XCTAssertEqual(router.routedResult!.score, 0)
	}

	func test_startGame_answerOneOutOfTwoCorrectly_scores1() {
		game = startGame(
			questions: ["Q1", "Q2"],
			router: router,
			correctAnswers: ["Q1": "A1", "Q2": "A2"]
		)

		router.answerCallback("A1")
		router.answerCallback("wrong")

		XCTAssertEqual(router.routedResult!.score, 1)
	}

	func test_startGame_answerTwoOutOfTwoCorrectly_scores2() {
		game = startGame(
			questions: ["Q1", "Q2"],
			router: router,
			correctAnswers: ["Q1": "A1", "Q2": "A2"]
		)

		router.answerCallback("A1")
		router.answerCallback("A2")

		XCTAssertEqual(router.routedResult!.score, 2)
	}
}
