//
//  iOSViewControllerFactoryTest.swift
//  QuizAppTests
//
//  Created by Everest Liu on 9/15/23.
//

@testable import QuizApp
import QuizEngine
import XCTest

final class iOSViewControllerFactoryTest: XCTestCase {
	let options = ["A1", "A2"]
	let singleAnswerQuestion = Question.singleAnswer("Q1")
	let multipleAnswerQuestion = Question.multipleAnswer("Q2")

	func test_questionViewController_singleAnswer_createsViewControllerWithTitle() {
		let presenter = QuestionPresenter(currentQuestion: singleAnswerQuestion, questions: [singleAnswerQuestion, multipleAnswerQuestion])

		XCTAssertEqual(makeQuestionViewController(question: singleAnswerQuestion).title, presenter.title)
	}

	func test_questionViewController_singleAnswer_createsViewControllerWithQuestion() {
		XCTAssertEqual(makeQuestionViewController(question: singleAnswerQuestion).question, "Q1")
	}

	func test_questionViewController_singleAnswer_createsViewControllerWithOptions() {
		XCTAssertEqual(makeQuestionViewController(question: singleAnswerQuestion).options, options)
	}

	func test_questionViewController_singleAnswer_createsViewControllerWithSingleSelection() {
		XCTAssertFalse(makeQuestionViewController(question: singleAnswerQuestion).allowsMultipleSelection)
	}

	func test_questionViewController_multipleAnswer_createsViewControllerWithQuestion() {
		let presenter = QuestionPresenter(currentQuestion: multipleAnswerQuestion, questions: [singleAnswerQuestion, multipleAnswerQuestion])
		XCTAssertEqual(makeQuestionViewController(question: multipleAnswerQuestion).title, presenter.title)
	}

	func test_questionViewController_multipleAnswer_createsViewControllerWithOptions() {
		XCTAssertEqual(makeQuestionViewController(question: multipleAnswerQuestion).options, options)
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

	func makeSUT(
		options: [Question<String>: [String]] = [:],
		correctAnswers: [Question<String>: [String]] = [:]
	) -> iOSViewControllerFactory {
		return iOSViewControllerFactory(questions: [singleAnswerQuestion, multipleAnswerQuestion], options: options, correctAnswers: correctAnswers)
	}

	func makeSUT(
		options: [Question<String>: [String]] = [:],
		correctAnswers: [(Question<String>, [String])] = []
	) -> iOSViewControllerFactory {
		return iOSViewControllerFactory(options: options, correctAnswers: correctAnswers)
	}

	func makeQuestionViewController(question: Question<String> = Question.singleAnswer("")) -> QuestionViewController {
		return makeSUT(options: [question: options], correctAnswers: [:])
			.questionViewController(for: question, answerCallback: { _ in }) as! QuestionViewController
	}

	func makeResults() -> (controller: ResultsViewController, presenter: ResultsPresenter) {
		let userAnswers = [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A1", "A2"])]
		let correctAnswers = [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A1", "A2"])]

		let presenter = ResultsPresenter(
			userAnswers: userAnswers,
			correctAnswers: correctAnswers,
			scorer: BasicScore.score
		)
		let sut = makeSUT(correctAnswers: correctAnswers)
		let controller = sut.resultsViewController(for: userAnswers) as! ResultsViewController

		return (controller, presenter)
	}
}
