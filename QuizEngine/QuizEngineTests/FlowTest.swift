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

		XCTAssertEqual(router.routedQuestionCount, 0)
	}

	func test_start_withOneQuestions_routeToQuestion() {
		let router = RouterSpy()
		let sut = Flow(questions: ["Q1"], router: router)

		sut.start()

		XCTAssertEqual(router.routedQuestionCount, 1)
	}

	func test_start_withOneQuestions_routeToCorrectQuestion() {
		let router = RouterSpy()
		let sut = Flow(questions: ["Q1"], router: router)

		sut.start()

		XCTAssertEqual(router.routedQuestion, "Q1")
	}

	class RouterSpy: Router {
		var routedQuestionCount: Int = 0
		var routedQuestion: String? = nil

		func routeTo(question: String) {
			routedQuestionCount += 1
			routedQuestion = question
		}
	}
}
