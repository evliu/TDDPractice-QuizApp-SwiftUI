//
//  NavigationControllerRouterTests.swift
//  QuizAppTests
//
//  Created by Everest Liu on 9/9/23.
//

@testable import QuizApp
import QuizEngine
import XCTest

final class NavigationControllerRouterTests: XCTestCase {
	let navigationController = NonAnimatingNavigationViewController()
	let factory = ViewControllerFactoryStub()

	let singleAnswerQuestion1 = Question.singleAnswer("Q1")
	let singleAnswerQuestion2 = Question.singleAnswer("Q2")
	let multipleAnswerQuestion1 = Question.multipleAnswer("Q1z")

	lazy var sut: NavigationControllerRouter = .init(self.navigationController, factory: self.factory)

	func test_answerForQuestions_presentsQuestionViewController() {
		let viewController = UIViewController()
		let secondViewController = UIViewController()
		factory.stub(question: singleAnswerQuestion1, with: viewController)
		factory.stub(question: singleAnswerQuestion2, with: secondViewController)

		sut.answer(for: singleAnswerQuestion1, completion: { _ in })
		sut.answer(for: singleAnswerQuestion2, completion: { _ in })

		XCTAssertEqual(navigationController.viewControllers.count, 2)
		XCTAssertEqual(navigationController.viewControllers.first, viewController)
		XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
	}

	func test_answerForQuestion_singleAnswer_answerCallbackGoesToNextQuestion() {
		var isAnswerCallbackFired = false
		sut.answer(for: singleAnswerQuestion1, completion: { _ in isAnswerCallbackFired = true })

		factory.answerCallbacks[singleAnswerQuestion1]!(["A1"])

		XCTAssertTrue(isAnswerCallbackFired)
	}

	func test_answerForQuestion_multipleAnswer_answerCallbacNotGoToNextQuestion() {
		var isAnswerCallbackFired = false
		sut.answer(for: multipleAnswerQuestion1, completion: { _ in isAnswerCallbackFired = true })

		factory.answerCallbacks[multipleAnswerQuestion1]!(["A1"])

		XCTAssertFalse(isAnswerCallbackFired)
	}

	func test_answerForQuestion_singleAnswer_doesNotConfigViewControllerWithSubmitButton() {
		let viewController = UIViewController()
		factory.stub(question: singleAnswerQuestion1, with: viewController)
		sut.answer(for: singleAnswerQuestion1, completion: { _ in })

		XCTAssertNil(viewController.navigationItem.rightBarButtonItem)
	}

	func test_answerForQuestion_multipleAnswer_configsViewControllerWithSubmitButton() {
		let viewController = UIViewController()
		factory.stub(question: multipleAnswerQuestion1, with: viewController)
		sut.answer(for: multipleAnswerQuestion1, completion: { _ in })

		XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
	}

	func test_answerForQuestion_multipleAnswer_submitButtonDisabledWithNoAnswers() {
		let viewController = UIViewController()
		let q = multipleAnswerQuestion1
		factory.stub(question: q, with: viewController)

		sut.answer(for: q, completion: { _ in })
		XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)

		factory.answerCallbacks[q]!(["A1"])
		XCTAssertTrue(viewController.navigationItem.rightBarButtonItem!.isEnabled)

		factory.answerCallbacks[q]!([])
		XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
	}

	func test_answerForQuestion_multipleAnswer_submitButton_CallbackFiredAfterAnswer() {
		let viewController = UIViewController()
		let q = multipleAnswerQuestion1
		factory.stub(question: q, with: viewController)

		var isAnswerCallbackFired = false
		sut.answer(for: q, completion: { _ in isAnswerCallbackFired = true })

		factory.answerCallbacks[q]!(["A1"])
		viewController.navigationItem.rightBarButtonItem?.simulateTap()

		XCTAssertTrue(isAnswerCallbackFired)
	}

	func test_routeToResults_presentsResultsViewController() {
		let viewController = UIViewController()
		let userAnswers = [(singleAnswerQuestion1, ["A1"])]

		let secondViewController = UIViewController()
		let secondUserAnswers = [(multipleAnswerQuestion1, ["A2"])]

		factory.stub(resultForQuestion: [singleAnswerQuestion1], with: viewController)
		factory.stub(resultForQuestion: [multipleAnswerQuestion1], with: secondViewController)

		sut.didCompleteQuiz(withAnswers: userAnswers)
		sut.didCompleteQuiz(withAnswers: secondUserAnswers)

		XCTAssertEqual(navigationController.viewControllers.count, 2)
		XCTAssertEqual(navigationController.viewControllers.first, viewController)
		XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
	}

	// MARK: Helpers

	class ViewControllerFactoryStub: ViewControllerFactory {
		private var stubbedQuestions = [Question<String>: UIViewController]()
		private var stubbedResults = [[Question<String>]: UIViewController]()
		var answerCallbacks = [Question<String>: ([String]) -> Void]()

		func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
			answerCallbacks[question] = answerCallback
			return stubbedQuestions[question] ?? UIViewController()
		}

		func resultsViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
			return UIViewController()
		}

		func resultsViewController(for userAnswers: Answers) -> UIViewController {
			return stubbedResults[userAnswers.map { $0.question }] ?? UIViewController()
		}

		func stub(question: Question<String>, with viewController: UIViewController) {
			stubbedQuestions[question] = viewController
		}

		func stub(resultForQuestion questions: [Question<String>], with viewController: UIViewController) {
			stubbedResults[questions] = viewController
		}
	}

	class NonAnimatingNavigationViewController: UINavigationController {
		override func pushViewController(_ viewController: UIViewController, animated: Bool) {
			super.pushViewController(viewController, animated: false)
		}
	}
}

private extension UIBarButtonItem {
	func simulateTap() {
		target!.performSelector(onMainThread: action!, with: nil, waitUntilDone: true)
	}
}
