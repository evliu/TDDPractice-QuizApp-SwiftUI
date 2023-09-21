//
//  QuestionPresenterTests.swift
//  QuizAppTests
//
//  Created by Everest Liu on 9/17/23.
//

@testable import QuizApp
import QuizEngine
import XCTest

final class QuestionPresenterTests: XCTestCase {
	let questions = [
		Question.singleAnswer("A1"),
		Question.singleAnswer("A2"),
		Question.singleAnswer("A3"),
	]

	func test_title_forQuestion() {
		let sut = QuestionPresenter(currentQuestion: questions[0], questions: [questions[0]])

		XCTAssertEqual(sut.title, "Question #1")
	}

	func test_title_forQuestions() {
		var sut = QuestionPresenter(currentQuestion: questions[0], questions: questions)
		XCTAssertEqual(sut.title, "Question #1")

		sut = QuestionPresenter(currentQuestion: questions[1], questions: questions)
		XCTAssertEqual(sut.title, "Question #2")

		sut = QuestionPresenter(currentQuestion: questions[2], questions: questions)
		XCTAssertEqual(sut.title, "Question #3")
	}

	func test_title_isEmpty() {
		var sut = QuestionPresenter(currentQuestion: Question.singleAnswer("DNE"), questions: questions)
		XCTAssertEqual(sut.title, "")

		sut = QuestionPresenter(currentQuestion: Question.singleAnswer("DNE"), questions: [])
		XCTAssertEqual(sut.title, "")
	}
}
