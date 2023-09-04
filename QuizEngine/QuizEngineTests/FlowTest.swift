//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by Everest Liu on 9/4/23.
//

import Foundation
@testable import QuizEngine
import XCTest

class FlowTest: XCTestCase {
	func test_start_withNoQuestions_doesNotRouteToQuestion() {
		let router = RouterSpy()
		let sut = Flow(questions: [], router: router)

		sut.start()

		XCTAssertTrue(router.routedQuestions.isEmpty)
	}

	func test_start_withOneQuestions_routeToCorrectQuestion() {
		let router = RouterSpy()
		let sut = Flow(questions: ["Q1"], router: router)

		sut.start()

		XCTAssertEqual(router.routedQuestions, ["Q1"])
	}

	func test_start_withOneQuestions_routeToCorrectQuestion_2() {
		let router = RouterSpy()
		let sut = Flow(questions: ["Q2"], router: router)

		sut.start()

		XCTAssertEqual(router.routedQuestions, ["Q2"])
	}

	func test_start_withTwoQuestions_routesToFirstQuestion() {
		let router = RouterSpy()
		let sut = Flow(questions: ["Q1", "Q2"], router: router)

		sut.start()

		XCTAssertEqual(router.routedQuestions, ["Q1"])
	}

	func test_startTwice_withTwoQuestions_routesToFirstQuestionTwice() {
		let router = RouterSpy()
		let sut = Flow(questions: ["Q1", "Q2"], router: router)

		sut.start()
		sut.start()

		XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
	}

	func test_startAndAnswerFirstQuestion_withTwoQuestions_routesToSecondQuestion() {
		let router = RouterSpy()
		let sut = Flow(questions: ["Q1", "Q2"], router: router)

		sut.start()

		router.answerCallback("A1")

		XCTAssertEqual(router.routedQuestions, ["Q1", "Q2"])
	}

	class RouterSpy: Router {
		var routedQuestions: [String] = []
		var answerCallback: ((String) -> Void) = { _ in }

		func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
			routedQuestions.append(question)
			self.answerCallback = answerCallback
		}
	}
}
