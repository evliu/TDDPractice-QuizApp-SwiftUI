//
//  GameTest.swift
//  QuizEngineTests
//
//  Created by Everest Liu on 9/8/23.
//

import QuizEngine
import XCTest

@available(*, deprecated)
final class DeprecatedGameTest: XCTestCase {
	private let router = RouterSpy()
	private var game: Game<String, String, RouterSpy>!

	override func setUp() {
		super.setUp()

		game = startGame(
			questions: ["Q1", "Q2"],
			router: router,
			correctAnswers: ["Q1": "A1", "Q2": "A2"]
		)
	}

	func test_startGame_answerZeroOutOfTwoCorrectly_scores0() {
		router.answerCallback("wrong")
		router.answerCallback("wrong")

		XCTAssertEqual(router.routedResult!.score, 0)
	}

	func test_startGame_answerOneOutOfTwoCorrectly_scores1() {
		router.answerCallback("A1")
		router.answerCallback("wrong")

		XCTAssertEqual(router.routedResult!.score, 1)
	}

	func test_startGame_answerTwoOutOfTwoCorrectly_scores2() {
		router.answerCallback("A1")
		router.answerCallback("A2")

		XCTAssertEqual(router.routedResult!.score, 2)
	}

	private class RouterSpy: Router {
		var routedResult: Result<String, String>? = nil
		var answerCallback: ((String) -> Void) = { _ in }

		func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
			self.answerCallback = answerCallback
		}

		func routeTo(result: Result<String, String>) {
			routedResult = result
		}
	}
}
