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

	func test_routeToQuestions_presentsQuestionViewController() {
		let viewController = UIViewController()
		let secondViewController = UIViewController()
		factory.stub(question: singleAnswerQuestion1, with: viewController)
		factory.stub(question: singleAnswerQuestion2, with: secondViewController)

		sut.routeTo(question: singleAnswerQuestion1, answerCallback: { _ in })
		sut.routeTo(question: singleAnswerQuestion2, answerCallback: { _ in })

		XCTAssertEqual(navigationController.viewControllers.count, 2)
		XCTAssertEqual(navigationController.viewControllers.first, viewController)
		XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
	}

	func test_routeToQuestion_singleAnswer_answerCallbackGoesToNextQuestion() {
		var isAnswerCallbackFired = false
		sut.routeTo(question: singleAnswerQuestion1, answerCallback: { _ in isAnswerCallbackFired = true })

		factory.answerCallbacks[singleAnswerQuestion1]!(["A1"])

		XCTAssertTrue(isAnswerCallbackFired)
	}

	func test_routeToQuestion_multipleAnswer_answerCallbacNotGoToNextQuestion() {
		var isAnswerCallbackFired = false
		sut.routeTo(question: multipleAnswerQuestion1, answerCallback: { _ in isAnswerCallbackFired = true })

		factory.answerCallbacks[multipleAnswerQuestion1]!(["A1"])

		XCTAssertFalse(isAnswerCallbackFired)
	}

	func test_routeToQuestion_singleAnswer_doesNotConfigViewControllerWithSubmitButton() {
		let viewController = UIViewController()
		factory.stub(question: singleAnswerQuestion1, with: viewController)
		sut.routeTo(question: singleAnswerQuestion1, answerCallback: { _ in })

		XCTAssertNil(viewController.navigationItem.rightBarButtonItem)
	}

	func test_routeToQuestion_multipleAnswer_configsViewControllerWithSubmitButton() {
		let viewController = UIViewController()
		factory.stub(question: multipleAnswerQuestion1, with: viewController)
		sut.routeTo(question: multipleAnswerQuestion1, answerCallback: { _ in })

		XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
	}

	func test_routeToQuestion_multipleAnswer_submitButtonDisabledWithNoAnswers() {
		let viewController = UIViewController()
		let q = multipleAnswerQuestion1
		factory.stub(question: q, with: viewController)

		sut.routeTo(question: q, answerCallback: { _ in })
		XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)

		factory.answerCallbacks[q]!(["A1"])
		XCTAssertTrue(viewController.navigationItem.rightBarButtonItem!.isEnabled)

		factory.answerCallbacks[q]!([])
		XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
	}

	func test_routeToQuestion_multipleAnswer_submitButton_CallbackFiredAfterAnswer() {
		let viewController = UIViewController()
		let q = multipleAnswerQuestion1
		factory.stub(question: q, with: viewController)

		var isAnswerCallbackFired = false
		sut.routeTo(question: q, answerCallback: { _ in isAnswerCallbackFired = true })

		factory.answerCallbacks[q]!(["A1"])
		viewController.navigationItem.rightBarButtonItem?.simulateTap()

		XCTAssertTrue(isAnswerCallbackFired)
	}

	func test_routeToResults_presentsResultsViewController() {
		let viewController = UIViewController()
		let result = Result.make(answers: [singleAnswerQuestion1: ["A1"]], score: 10)

		let secondViewController = UIViewController()
		let secondResult = Result.make(answers: [singleAnswerQuestion2: ["A2"]], score: 20)

		factory.stub(result: result, with: viewController)
		factory.stub(result: secondResult, with: secondViewController)

		sut.routeTo(result: result)
		sut.routeTo(result: secondResult)

		XCTAssertEqual(navigationController.viewControllers.count, 2)
		XCTAssertEqual(navigationController.viewControllers.first, viewController)
		XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
	}

	// MARK: Helpers

	class ViewControllerFactoryStub: ViewControllerFactory {
		private var stubbedQuestions = [Question<String>: UIViewController]()
		private var stubbedResults = [Result<Question<String>, [String]>: UIViewController]()
		var answerCallbacks = [Question<String>: ([String]) -> Void]()

		func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
			answerCallbacks[question] = answerCallback
			return stubbedQuestions[question] ?? UIViewController()
		}

		func resultsViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
			return stubbedResults[result] ?? UIViewController()
		}

		func stub(question: Question<String>, with viewController: UIViewController) {
			stubbedQuestions[question] = viewController
		}

		func stub(result: Result<Question<String>, [String]>, with viewController: UIViewController) {
			stubbedResults[result] = viewController
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
