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
	let singleAnswerQuestion = Question.singleAnswer("Q1")
	let multipleAnswerQuestion = Question.multipleAnswer("Q2")

	func test_title_formatsTitle() {
		XCTAssertEqual(ResultsPresenter(result: .make(), questions: [], correctAnswers: [:]).title, "Result")
	}

	func test_summary_withThree_QuestionsScoreTwo_returnsSummary() {
		let answers = [
			singleAnswerQuestion: ["A1"],
			multipleAnswerQuestion: ["A2", "A2.1"],
			Question.multipleAnswer("Q3"): ["A3"]
		]
		let result = Result.make(answers: answers, score: 1)
		let sut = ResultsPresenter(
			result: result,
			questions: [
				singleAnswerQuestion,
				multipleAnswerQuestion,
				Question.multipleAnswer("Q3")
			],
			correctAnswers: [:]
		)

		XCTAssertEqual(sut.summary, "You got 1/3 correct")
	}

	func test_presentableAnswers_withNoQuestions_isEmpty() {
		XCTAssertTrue(ResultsPresenter(result: .make(), questions: [], correctAnswers: [:]).presentableAnswers.isEmpty)
	}

	func test_presentableAnswers_withWrongSingleAnswer_mapsAnswer() {
		let result = Result.make(answers: [singleAnswerQuestion: ["A1"]])
		let correctAnswers = [singleAnswerQuestion: ["A2"]]
		let sut = ResultsPresenter(
			result: result,
			questions: [singleAnswerQuestion],
			correctAnswers: correctAnswers
		)

		XCTAssertEqual(sut.presentableAnswers.count, 1)
		XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
		XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2")
		XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1")
	}

	func test_presentableAnswers_withWrongMultipleAnswer_mapsAnswer() {
		let result = Result.make(answers: [singleAnswerQuestion: ["A1", "A4"]])
		let correctAnswers = [singleAnswerQuestion: ["A2", "A3"]]
		let sut = ResultsPresenter(
			result: result,
			questions: [singleAnswerQuestion],
			correctAnswers: correctAnswers
		)

		XCTAssertEqual(sut.presentableAnswers.count, 1)
		XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
		XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2, A3")
		XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1, A4")
	}

	func test_presentableAnswers_withRightSingleAnswer_mapsAnswer() {
		let result = Result.make(answers: [singleAnswerQuestion: ["A1"]])
		let correctAnswers = [singleAnswerQuestion: ["A1"]]
		let sut = ResultsPresenter(
			result: result,
			questions: [singleAnswerQuestion],
			correctAnswers: correctAnswers
		)

		XCTAssertEqual(sut.presentableAnswers.count, 1)
		XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
		XCTAssertEqual(sut.presentableAnswers.first!.answer, "A1")
		XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)
	}

	func test_presentableAnswers_withRightMultipleAnswer_mapsAnswer() {
		let result = Result.make(answers: [Question.multipleAnswer("Q1"): ["A1", "A2"]])
		let correctAnswers = [Question.multipleAnswer("Q1"): ["A1", "A2"]]
		let sut = ResultsPresenter(
			result: result,
			questions: [Question.multipleAnswer("Q1")],
			correctAnswers: correctAnswers
		)

		XCTAssertEqual(sut.presentableAnswers.count, 1)
		XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
		XCTAssertEqual(sut.presentableAnswers.first!.answer, "A1, A2")
		XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)
	}

	func test_presentableAnswers_withTwoAnswers_mapsOrderedAnswer() {
		let result = Result.make(answers: [
			multipleAnswerQuestion: ["A1", "A2"],
			Question.multipleAnswer("Q1"): ["A3", "A4"]
		])
		let correctAnswers = [
			Question.multipleAnswer("Q1"): ["A3", "A4"],
			multipleAnswerQuestion: ["A1", "A2"]
		]
		let orderedQuestions = [Question.multipleAnswer("Q1"), multipleAnswerQuestion]
		let sut = ResultsPresenter(result: result, questions: orderedQuestions, correctAnswers: correctAnswers)

		XCTAssertEqual(sut.presentableAnswers.count, 2)

		XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
		XCTAssertEqual(sut.presentableAnswers.first!.answer, "A3, A4")
		XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)

		XCTAssertEqual(sut.presentableAnswers.last!.question, "Q2")
		XCTAssertEqual(sut.presentableAnswers.last!.answer, "A1, A2")
		XCTAssertNil(sut.presentableAnswers.last!.wrongAnswer)
	}
}
