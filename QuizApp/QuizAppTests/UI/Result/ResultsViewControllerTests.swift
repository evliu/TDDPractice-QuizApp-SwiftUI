//
//  ResultsViewControllerTests.swift
//  QuizAppTests
//
//  Created by Everest Liu on 9/5/23.
//

import XCTest

@testable import QuizApp

final class ResultsViewControllerTests: XCTestCase {
	func test_viewDidLoad_renderSummary() {
		XCTAssertEqual(makeSUT(summary: "a summary").headerLabel.text, "a summary")
	}

	func test_viewDidLoad_withoutAnswers_renderAnswers() {
		let oneAnswer = makeSUT(answers: [makeAnswer()])
		XCTAssertEqual(makeSUT(answers: []).tableView.numberOfRows(inSection: 0), 0)
		XCTAssertEqual(oneAnswer.tableView.numberOfRows(inSection: 0), 1)
	}

	func test_viewDidLoad_withCorrectAnswer_configuredCell() {
		let answer = makeAnswer(question: "Q1", answer: "A1")
		let sut = makeSUT(answers: [answer])
		let cell = sut.tableView.cell(at: 0) as? CorrectAnswerCell

		XCTAssertNotNil(cell)
		XCTAssertEqual(cell?.questionLabel.text, "Q1")
		XCTAssertEqual(cell?.answerLabel.text, "A1")
	}

	func test_viewDidLoad_withWrongAnswer_renderWrongAnswerCell() {
		let answer = makeAnswer(question: "Q1", answer: "A1", wrongAnswer: "wrong")
		let sut = makeSUT(answers: [answer])
		let cell = sut.tableView.cell(at: 0) as? WrongAnswerCell

		XCTAssertNotNil(cell)
		XCTAssertEqual(cell?.questionLabel.text, "Q1")
		XCTAssertEqual(cell?.correctAnswerLabel.text, "A1")
		XCTAssertEqual(cell?.wrongAnswerLabel.text, "wrong")
	}

	// MARK: Helpers

	func makeSUT(summary: String = "", answers: [PresentableAnswer] = []) -> ResultsViewController {
		let sut = ResultsViewController(summary: summary, answers: answers)
		sut.loadViewIfNeeded()

		return sut
	}

	func makeAnswer(question: String = "", answer: String = "", wrongAnswer: String? = nil) -> PresentableAnswer {
		return PresentableAnswer(question: question, answer: answer, wrongAnswer: wrongAnswer)
	}
}
