//
//  ResultsPresenterTest.swift
//  QuizAppTests
//
//  Created by Everest Liu on 9/16/23.
//

@testable import QuizApp
import QuizEngine
import XCTest

final class ResultsPresenterTest: XCTestCase {
	func test_title_formatsTitle() {
		XCTAssertEqual(makeSUT().title, "Result")
	}

	func test_summary_withThree_QuestionsScoreTwo_returnsSummary() {
		let userAnswers = [
			(singleAnswerQuestion, ["A1"]),
			(multipleAnswerQuestion, ["A2", "A2.1"]),
			(Question.multipleAnswer("Q3"), ["A3"])
		]
		let correctAnswers = [
			(singleAnswerQuestion, ["A1"]),
			(multipleAnswerQuestion, ["A2"]),
			(Question.multipleAnswer("Q3"), ["A3"])
		]

		let sut = makeSUT(userAnswers: userAnswers, correctAnswers: correctAnswers, score: 2)

		XCTAssertEqual(sut.summary, "You got 2/3 correct")
	}

	func test_presentableAnswers_withNoQuestions_isEmpty() {
		XCTAssertTrue(makeSUT(userAnswers: [], correctAnswers: []).presentableAnswers.isEmpty)
	}

	func test_presentableAnswers_withWrongSingleAnswer_mapsAnswer() {
		let sut = makeSUT(
			userAnswers: [(singleAnswerQuestion, ["A1"])],
			correctAnswers: [(singleAnswerQuestion, ["A2"])]
		)

		XCTAssertEqual(sut.presentableAnswers.count, 1)
		XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
		XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2")
		XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1")
	}

	func test_presentableAnswers_withWrongMultipleAnswer_mapsAnswer() {
		let sut = makeSUT(
			userAnswers: [(singleAnswerQuestion, ["A1", "A4"])],
			correctAnswers: [(singleAnswerQuestion, ["A2", "A3"])]
		)

		XCTAssertEqual(sut.presentableAnswers.count, 1)
		XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
		XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2, A3")
		XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1, A4")
	}

	func test_presentableAnswers_withRightSingleAnswer_mapsAnswer() {
		let sut = makeSUT(
			userAnswers: [(singleAnswerQuestion, ["A1"])],
			correctAnswers: [(singleAnswerQuestion, ["A1"])]
		)

		XCTAssertEqual(sut.presentableAnswers.count, 1)
		XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
		XCTAssertEqual(sut.presentableAnswers.first!.answer, "A1")
		XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)
	}

	func test_presentableAnswers_withRightMultipleAnswer_mapsAnswer() {
		let sut = makeSUT(
			userAnswers: [(Question.multipleAnswer("Q1"), ["A1", "A2"])],
			correctAnswers: [(Question.multipleAnswer("Q1"), ["A1", "A2"])]
		)

		XCTAssertEqual(sut.presentableAnswers.count, 1)
		XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
		XCTAssertEqual(sut.presentableAnswers.first!.answer, "A1, A2")
		XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)
	}

	func test_presentableAnswers_withTwoAnswers_mapsOrderedAnswer() {
		let sut = makeSUT(
			userAnswers: [
				(multipleAnswerQuestion, ["A1", "A2"]),
				(Question.multipleAnswer("Q1"), ["A3", "A4"])
			],
			correctAnswers: [
				(multipleAnswerQuestion, ["A1", "A2"]),
				(Question.multipleAnswer("Q1"), ["A3", "A4"])
			]
		)

		XCTAssertEqual(sut.presentableAnswers.count, 2)

		XCTAssertEqual(sut.presentableAnswers.first!.question, "Q2")
		XCTAssertEqual(sut.presentableAnswers.first!.answer, "A1, A2")
		XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)

		XCTAssertEqual(sut.presentableAnswers.last!.question, "Q1")
		XCTAssertEqual(sut.presentableAnswers.last!.answer, "A3, A4")
		XCTAssertNil(sut.presentableAnswers.last!.wrongAnswer)
	}

	// MARK: - Helpers

	private let singleAnswerQuestion = Question.singleAnswer("Q1")
	private let multipleAnswerQuestion = Question.multipleAnswer("Q2")

	private func makeSUT(
		userAnswers: ResultsPresenter.Answers = [],
		correctAnswers: ResultsPresenter.Answers = [],
		score: Int = 0
	) -> ResultsPresenter {
		return ResultsPresenter(
			userAnswers: userAnswers,
			correctAnswers: correctAnswers,
			scorer: { _, _ in score }
		)
	}
}
