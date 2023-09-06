//
//  QuestionViewControllerTest.swift
//  QuizApp
//
//  Created by Everest Liu on 9/5/23.
//

@testable import QuizApp
import XCTest

class QuestionViewControllerTest: XCTestCase {
	func test_viewDidLoad_rendersQuestionHeaderText() {
		XCTAssertEqual(makeSUT(question: "Q1", options: []).headerLabel.text, "Q1")
	}

	func test_viewDidLoad_renderOptions() {
		XCTAssertEqual(makeSUT(options: []).tableView.numberOfRows(inSection: 0), 0)
		XCTAssertEqual(makeSUT(options: ["A1"]).tableView.numberOfRows(inSection: 0), 1)
		XCTAssertEqual(makeSUT(options: ["A1", "A2"]).tableView.numberOfRows(inSection: 0), 2)
	}

	func test_viewDidLoad_withOneOption_rendersOptionsText() {
		XCTAssertEqual(makeSUT(question: "Q1", options: ["A1", "A2"]).tableView.title(at: 0), "A1")
		XCTAssertEqual(makeSUT(question: "Q1", options: ["A1", "A2"]).tableView.title(at: 1), "A2")
	}

	func test_optionSelected_withSingleSelection_notifiesDelegateWithLastSelection() {
		var receivedAnswer = [String]()
		let sut = makeSUT(options: ["A1", "A2"]) { receivedAnswer = $0 }

		sut.tableView.select(row: 0)
		XCTAssertEqual(receivedAnswer, ["A1"])

		sut.tableView.select(row: 1)
		XCTAssertEqual(receivedAnswer, ["A2"])
	}

	func test_optionDeselected_withSingleSelection_doesNotNotifiesDelegateWithEmptySelection() {
		var callbackCount = 0
		let sut = makeSUT(options: ["A1", "A2"]) { _ in callbackCount += 1 }

		sut.tableView.select(row: 0)
		XCTAssertEqual(callbackCount, 1)

		sut.tableView.deselect(row: 0)
		XCTAssertEqual(callbackCount, 1)
	}

	func test_optionSelected_withMultipleSelectionEnabled_notifiesDelegateSelection() {
		var receivedAnswer = [String]()
		let sut = makeSUT(options: ["A1", "A2"]) { receivedAnswer = $0 }
		sut.tableView.allowsMultipleSelection = true

		sut.tableView.select(row: 0)
		XCTAssertEqual(receivedAnswer, ["A1"])

		sut.tableView.select(row: 1)
		XCTAssertEqual(receivedAnswer, ["A1", "A2"])
	}

	func test_optionSelected_withMultipleSelectionEnabled_notifiesDelegate() {
		var receivedAnswer = [String]()
		let sut = makeSUT(options: ["A1", "A2"]) { receivedAnswer = $0 }
		sut.tableView.allowsMultipleSelection = true

		sut.tableView.select(row: 0)
		XCTAssertEqual(receivedAnswer, ["A1"])

		sut.tableView.deselect(row: 0)
		XCTAssertEqual(receivedAnswer, [])
	}

	// MARK: Helpers

	func makeSUT(
		question: String = "",
		options: [String],
		selection: @escaping ([String]) -> Void = { _ in }) -> QuestionViewController
	{
		let sut = QuestionViewController(question: question, options: options, selection: selection)
		sut.loadViewIfNeeded()

		return sut
	}
}
