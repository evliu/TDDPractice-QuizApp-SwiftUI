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
		let presenter = QuestionPresenter(currentQuestion: singleAnswerQuestion, questions: [singleAnswerQuestion, multipleAnswerQuestion])
		let view = try XCTUnwrap(makeSingleAnswerQuestionView())

		XCTAssertEqual(view.title, presenter.title)
	}

	func test_questionViewController_singleAnswer_createsViewControllerWithQuestion() throws {
		let view = try XCTUnwrap(makeSingleAnswerQuestionView())
		XCTAssertEqual(view.question, "Q1")
	}

	func test_questionViewController_singleAnswer_createsViewControllerWithOptions() throws {
		let view = try XCTUnwrap(makeSingleAnswerQuestionView())
		XCTAssertEqual(view.options, options[singleAnswerQuestion])
	}

	func test_questionViewController_singleAnswer_createsViewControllerWithAnswerCallback() throws {
		var answers: [[String]] = []
		let view = try XCTUnwrap(makeSingleAnswerQuestionView(answerCallback: { answers.append($0) }))

		XCTAssertEqual(answers, [])

		view.selection(view.options[0])
		XCTAssertEqual(answers, [[view.options[0]]])

		view.selection(view.options[1])
		XCTAssertEqual(answers, [[view.options[0]], [view.options[1]]])
	}

	func test_questionViewController_multipleAnswer_createsViewControllerWithTitle() throws {
		let presenter = QuestionPresenter(currentQuestion: multipleAnswerQuestion, questions: [singleAnswerQuestion, multipleAnswerQuestion])
		let view = try XCTUnwrap(makeMultipleAnswerQuestionView())

		XCTAssertEqual(view.title, presenter.title)
	}

	func test_questionViewController_multipleAnswer_createsViewControllerWithQuestion() throws {
		let view = try XCTUnwrap(makeMultipleAnswerQuestionView())
		XCTAssertEqual(view.question, "Q2")
	}

	func test_questionViewController_multipleAnswer_createsViewControllerWithOptions() throws {
		let view = try XCTUnwrap(makeMultipleAnswerQuestionView())
		XCTAssertEqual(view.store.options.map(\.text), options[multipleAnswerQuestion])
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

	private func makeSingleAnswerQuestionView(answerCallback: @escaping ([String]) -> Void = { _ in }) -> SingleAnswerQuestionView? {
		let sut = makeSUT()

		let controller = sut.questionViewController(for: singleAnswerQuestion, answerCallback: answerCallback) as? UIHostingController<SingleAnswerQuestionView>

		return controller?.rootView
	}

	private func makeMultipleAnswerQuestionView(answerCallback: @escaping ([String]) -> Void = { _ in }) -> MultipleAnswerQuestionView? {
		let sut = makeSUT()

		let controller = sut.questionViewController(for: multipleAnswerQuestion, answerCallback: answerCallback) as? UIHostingController<MultipleAnswerQuestionView>

		return controller?.rootView
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
