//
//  iOSViewControllerFactoryTest.swift
//  QuizAppTests
//
//  Created by Everest Liu on 9/15/23.
//

@testable import QuizApp
import XCTest

final class iOSViewControllerFactoryTest: XCTestCase {
	func test_questionViewController_createsViewControllerWithQuestion() {
		let question = Question.singleAnswer("Q1")
		let options = ["A1", "A2"]
		let sut = iOSViewControllerFactory(options: [question: options])

		let controller = sut.questionViewController(for: Question.singleAnswer("Q1"), answerCallback: { _ in }) as? QuestionViewController

		XCTAssertEqual(controller?.question, "Q1")
	}

	func test_questionViewController_createsViewControllerWithOptions() {
		let question = Question.singleAnswer("Q1")
		let options = ["A1", "A2"]
		let sut = iOSViewControllerFactory(options: [question: options])

		let controller = sut.questionViewController(for: question, answerCallback: { _ in }) as! QuestionViewController
		
		XCTAssertEqual(controller.options, options)
	}
}
