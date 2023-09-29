//
//  iOSUIKitViewControllerFactoryTest.swift
//  QuizAppTests
//
//  Created by Everest Liu on 9/15/23.
//

@testable import QuizApp
import QuizEngine
import SwiftUI
import XCTest

final class iOSSwiftUIViewControllerFactoryTest: XCTestCase {
	let singleAnswerQuestion = Question.singleAnswer("Q1")
	let multipleAnswerQuestion = Question.multipleAnswer("Q2")

	func test_questionViewController_singleAnswer_createsViewControllerWithTitle() throws {
		let presenter = QuestionPresenter(currentQuestion: singleAnswerQuestion, questions: [singleAnswerQuestion])
		let view = try XCTUnwrap(makeSingleAnswerQuestion())

		XCTAssertEqual(view.title, presenter.title)
	}

	func test_questionViewController_singleAnswer_createsViewControllerWithQuestion() throws {
		let view = try XCTUnwrap(makeSingleAnswerQuestion())
		XCTAssertEqual(view.question, "Q1")
	}

	func test_questionViewController_singleAnswer_createsViewControllerWithOptions() throws {
		let view = try XCTUnwrap(makeSingleAnswerQuestion())
		XCTAssertEqual(view.options, options[singleAnswerQuestion])
	}

	func test_questionViewController_singleAnswer_createsViewControllerWithAnswerCallback() throws {
		var answers: [[String]] = []
		let view = try XCTUnwrap(makeSingleAnswerQuestion(answerCallback: { answers.append($0) }))

		XCTAssertEqual(answers, [])

		view.selection(view.options[0])
		XCTAssertEqual(answers, [[view.options[0]]])

		view.selection(view.options[1])
		XCTAssertEqual(answers, [[view.options[0]], [view.options[1]]])
	}

	func test_questionViewController_multipleAnswer_createsViewControllerWithQuestion() {
		let presenter = QuestionPresenter(currentQuestion: multipleAnswerQuestion, questions: [singleAnswerQuestion, multipleAnswerQuestion])
		XCTAssertEqual(makeQuestionViewController(question: multipleAnswerQuestion).title, presenter.title)
	}

	func test_questionViewController_multipleAnswer_createsViewControllerWithOptions() {
		XCTAssertEqual(makeQuestionViewController(question: multipleAnswerQuestion).options, options[multipleAnswerQuestion])
	}

	func test_questionViewController_multipleAnswer_createsViewControllerWithSingleSelection() {
		XCTAssertTrue(makeQuestionViewController(question: multipleAnswerQuestion).allowsMultipleSelection)
	}

	func test_resultsViewController_createsViewControllerWithTitle() {
		let (controller, presenter) = makeResults()

		XCTAssertEqual(controller.title, presenter.title)
	}

	func test_resultsViewController_createsViewControllerWithSummary() {
		let (controller, presenter) = makeResults()

		XCTAssertEqual(controller.summary, presenter.summary)
	}

	func test_resultsViewController_createsViewControllerWithPresentableAnswers() {
		let (controller, presenter) = makeResults()

		XCTAssertEqual(controller.answers.count, presenter.presentableAnswers.count)
	}

	// MARK: Helpers

	private var questions: [Question<String>] { [singleAnswerQuestion, multipleAnswerQuestion] }
	private var options: [Question<String>: [String]] { [singleAnswerQuestion: ["A1", "A2", "A3"], multipleAnswerQuestion: ["A4", "A5", "A6"]] }
	private var correctAnswers: [(Question<String>, [String])] { [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A4", "A5"])] }

	private func makeSUT() -> iOSSwiftUIViewControllerFactory {
		return iOSSwiftUIViewControllerFactory(options: options, correctAnswers: correctAnswers)
	}

	private func makeSingleAnswerQuestion(answerCallback: @escaping ([String]) -> Void = { _ in }) -> SingleAnswerQuestion? {
		let sut = makeSUT()

		let controller = sut.questionViewController(for: singleAnswerQuestion, answerCallback: answerCallback) as? UIHostingController<SingleAnswerQuestion>

		return controller?.rootView
	}

	private func makeQuestionViewController(question: Question<String> = Question.singleAnswer("")) -> QuestionViewController {
		let sut = makeSUT()

		return sut.questionViewController(for: question, answerCallback: { _ in }) as! QuestionViewController
	}

	func makeResults() -> (controller: ResultsViewController, presenter: ResultsPresenter) {
		let sut = makeSUT()
		let controller = sut.resultsViewController(for: correctAnswers) as! ResultsViewController
		let presenter = ResultsPresenter(
			userAnswers: correctAnswers,
			correctAnswers: correctAnswers,
			scorer: BasicScore.score
		)

		return (controller, presenter)
	}
}
