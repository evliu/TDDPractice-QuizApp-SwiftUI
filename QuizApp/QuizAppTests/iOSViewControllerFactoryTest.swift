//
//  iOSViewControllerFactoryTest.swift
//  QuizAppTests
//
//  Created by Everest Liu on 9/15/23.
//

@testable import QuizApp
import XCTest

final class iOSViewControllerFactoryTest: XCTestCase {
	let options = ["A1", "A2"]

	func test_questionViewController_singleAnswer_createsViewControllerWithQuestion() {
		XCTAssertEqual(makeQuestionViewController(question: Question.singleAnswer("Q1")).question, "Q1")
	}

	func test_questionViewController_singleAnswer_createsViewControllerWithOptions() {
		XCTAssertEqual(makeQuestionViewController(question: Question.singleAnswer("Q1")).options, options)
	}

	func test_questionViewController_singleAnswer_createsViewControllerWithSingleSelection() {
		let controller = makeQuestionViewController(question: Question.singleAnswer("Q1"))
		controller.loadViewIfNeeded()

		XCTAssertFalse(controller.tableView.allowsMultipleSelection)
	}

	func test_questionViewController_multipleAnswer_createsViewControllerWithQuestion() {
		XCTAssertEqual(makeQuestionViewController(question: Question.multipleAnswer("Q1")).question, "Q1")
	}

	func test_questionViewController_multipleAnswer_createsViewControllerWithOptions() {
		XCTAssertEqual(makeQuestionViewController(question: Question.multipleAnswer("Q1")).options, options)
	}

	func test_questionViewController_multipleAnswer_createsViewControllerWithSingleSelection() {
		let controller = makeQuestionViewController(question: Question.multipleAnswer("Q1"))
		controller.loadViewIfNeeded()

		XCTAssertTrue(controller.tableView.allowsMultipleSelection)
	}

	// MARK: Helpers

	func makeSUT(options: [Question<String>: [String]]) -> iOSViewControllerFactory {
		return iOSViewControllerFactory(options: options)
	}

	func makeQuestionViewController(question: Question<String> = Question.singleAnswer("")) -> QuestionViewController {
		return makeSUT(options: [question: options]).questionViewController(for: question, answerCallback: { _ in }) as! QuestionViewController
	}
}
