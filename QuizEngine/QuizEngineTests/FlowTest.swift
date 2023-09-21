//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by Everest Liu on 9/4/23.
//

import Foundation
import XCTest

@testable import QuizEngine

class FlowTest: XCTestCase {
	private let delegate = DelegateSpy()

	func test_start_withNoQuestions_doesNotDelegateQuestionHandling() {
		makeSUT(questions: []).start()
		XCTAssertTrue(delegate.handledQuestions.isEmpty)
	}

	func test_start_withOneQuestions_delegatesCorrectQuestionHandling() {
		makeSUT(questions: ["Q1"]).start()
		XCTAssertEqual(delegate.handledQuestions, ["Q1"])
	}

	func test_start_withOneQuestions_delegatesAnotherCorrectQuestionHandling() {
		makeSUT(questions: ["Q2"]).start()
		XCTAssertEqual(delegate.handledQuestions, ["Q2"])
	}

	func test_start_withTwoQuestions_delegatesFirstQuestionHandling() {
		makeSUT(questions: ["Q1", "Q2"]).start()
		XCTAssertEqual(delegate.handledQuestions, ["Q1"])
	}

	func test_startTwice_withTwoQuestions_delegatesFirstQuestionHandlingTwice() {
		let sut = makeSUT(questions: ["Q1", "Q2"])

		sut.start()
		sut.start()

		XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q1"])
	}

	func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_delegatesSecondAndThirdQuestionHandling() {
		let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
		sut.start()

		delegate.answerCallback("A1")
		delegate.answerCallback("A2")

		XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q2", "Q3"])
	}

	func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotDelegateAnotherQuestionHandling() {
		let sut = makeSUT(questions: ["Q1"])
		sut.start()

		delegate.answerCallback("A1")

		XCTAssertEqual(delegate.handledQuestions, ["Q1"])
	}

	func delegatesResult() {
		makeSUT(questions: []).start()
		XCTAssertEqual(delegate.handledResult!.answers, [:])
	}

	func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotDelegateResultHandling() {
		makeSUT(questions: ["Q1"]).start()
		XCTAssertNil(delegate.handledResult)
	}

	func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotDelegateResultHandling() {
		let sut = makeSUT(questions: ["Q1", "Q2"])
		sut.start()

		delegate.answerCallback("A1")

		XCTAssertNil(delegate.handledResult)
	}

	func test_startAndAnswerFirstAndSecondQuestions_withTwoQuestions_delegatesResultHandling() {
		let sut = makeSUT(questions: ["Q1", "Q2"])
		sut.start()

		delegate.answerCallback("A1")
		delegate.answerCallback("A2")

		XCTAssertEqual(delegate.handledResult!.answers, ["Q1": "A1", "Q2": "A2"])
	}

	func test_startAndAnswerFirstAndSecondQuestions_withTwoQuestions_scores() {
		let sut = makeSUT(questions: ["Q1", "Q2"], scoring: { _ in 10 })
		sut.start()

		delegate.answerCallback("A1")
		delegate.answerCallback("A2")

		XCTAssertEqual(delegate.handledResult!.score, 10)
	}

	func test_startAndAnswerFirstAndSecondQuestions_withTwoQuestions_scoresWithTheRightAnswers() {
		var receivedAnswers = [String: String]()
		let sut = makeSUT(questions: ["Q1", "Q2"], scoring: { answers in
			receivedAnswers = answers

			return 20
		})

		sut.start()

		delegate.answerCallback("A1")
		delegate.answerCallback("A2")

		XCTAssertEqual(receivedAnswers, ["Q1": "A1", "Q2": "A2"])
	}

	// MARK: Helpers

	private func makeSUT(
		questions: [String],
		scoring: @escaping ([String: String]) -> Int = { _ in 0 }) -> Flow<DelegateSpy>
	{
		return Flow(questions: questions, delegate: delegate, scoring: scoring)
	}

	private class DelegateSpy: QuizDelegate {
		var handledQuestions: [String] = []
		var handledResult: Result<String, String>? = nil
		var answerCallback: ((String) -> Void) = { _ in }

		func handle(question: String, answerCallback: @escaping (String) -> Void) {
			handledQuestions.append(question)
			self.answerCallback = answerCallback
		}

		func handle(result: Result<String, String>) {
			handledResult = result
		}
	}
}
