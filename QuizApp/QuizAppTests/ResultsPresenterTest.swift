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
	func test_summary_withThree_QuestionsScoreTwo_returnsSummary() {
		let answers = [
			Question.singleAnswer("Q1"): ["A1"],
			Question.multipleAnswer("Q2"): ["A2", "A2.1"],
			Question.multipleAnswer("Q3"): ["A3"]
		]
		let result = Result.make(answers: answers, score: 1)
		let sut = ResultsPresenter(result: result, correctAnswers: [:])

		XCTAssertEqual(sut.summary, "You got 1/3 correct")
	}

	func test_presentableAnswers_withNoQuestions_isEmpty() {
		let sut = ResultsPresenter(
			result: Result.make(answers: [Question<String>: [String]](), score: 0),
			correctAnswers: [:]
		)

		XCTAssertTrue(sut.presentableAnswers.isEmpty)
	}

	func test_presentableAnswers_withWrongSingleAnswer_mapsAnswer() {
		let result = Result.make(answers: [Question.singleAnswer("Q1"): ["A1"]])
		let correctAnswers = [Question.singleAnswer("Q1"): ["A2"]]
		let sut = ResultsPresenter(result: result, correctAnswers: correctAnswers)

		XCTAssertEqual(sut.presentableAnswers.count, 1)
		XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
		XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2")
		XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1")
	}

	func test_presentableAnswers_withWrongMultipleAnswer_mapsAnswer() {
		let result = Result.make(answers: [Question.singleAnswer("Q1"): ["A1", "A4"]])
		let correctAnswers = [Question.singleAnswer("Q1"): ["A2", "A3"]]
		let sut = ResultsPresenter(result: result, correctAnswers: correctAnswers)

		XCTAssertEqual(sut.presentableAnswers.count, 1)
		XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
		XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2, A3")
		XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1, A4")
	}

	func test_presentableAnswers_withRightSingleAnswer_mapsAnswer() {
		let result = Result.make(answers: [Question.singleAnswer("Q1"): ["A1"]])
		let correctAnswers = [Question.singleAnswer("Q1"): ["A1"]]
		let sut = ResultsPresenter(result: result, correctAnswers: correctAnswers)

		XCTAssertEqual(sut.presentableAnswers.count, 1)
		XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
		XCTAssertEqual(sut.presentableAnswers.first!.answer, "A1")
		XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)
	}

	func test_presentableAnswers_withRightMultipleAnswer_mapsAnswer() {
		let result = Result.make(answers: [Question.singleAnswer("Q1"): ["A1", "A2"]])
		let correctAnswers = [Question.singleAnswer("Q1"): ["A1", "A2"]]
		let sut = ResultsPresenter(result: result, correctAnswers: correctAnswers)

		XCTAssertEqual(sut.presentableAnswers.count, 1)
		XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
		XCTAssertEqual(sut.presentableAnswers.first!.answer, "A1, A2")
		XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)
	}
}
