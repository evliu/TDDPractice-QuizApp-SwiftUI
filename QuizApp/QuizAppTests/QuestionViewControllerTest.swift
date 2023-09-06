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

	func test_viewDidLoad_withOneOption_rendersOneOptionText() {
		XCTAssertEqual(makeSUT(question: "Q1", options: ["A1", "A2"]).tableView.title(at: 0), "A1")
		XCTAssertEqual(makeSUT(question: "Q1", options: ["A1", "A2"]).tableView.title(at: 1), "A2")
	}

	func test_optionSelected_notifiesDelegate() {
		var receivedAnswer = ""
		let sut = makeSUT(options: ["A1"]) {
			receivedAnswer = $0
		}

		let indexPath = IndexPath(row: 0, section: 0)
		sut.tableView.delegate?.tableView?(sut.tableView, didSelectRowAt: indexPath)

		XCTAssertEqual(receivedAnswer, "A1")
	}

	// MARK: Helpers

	func makeSUT(
		question: String = "",
		options: [String],
		selection: @escaping (String) -> Void = { _ in }) -> QuestionViewController
	{
		let sut = QuestionViewController(question: question, options: options, selection: selection)
		sut.loadViewIfNeeded()

		return sut
	}
}

private extension UITableView {
	func cell(at row: Int) -> UITableViewCell? {
		return dataSource?.tableView(self, cellForRowAt: IndexPath(row: row, section: 0))
	}

	func title(at row: Int) -> String? {
		return cell(at: row)?.textLabel?.text
	}
}
