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

	lazy var sut: NavigationControllerRouter = .init(self.navigationController, factory: self.factory)

	func test_routeToQuestions_presentsQuestionViewController() {
		let viewController = UIViewController()
		let secondViewController = UIViewController()
		factory.stub(question: Question.singleAnswer("Q1"), with: viewController)
		factory.stub(question: Question.singleAnswer("Q2"), with: secondViewController)

		sut.routeTo(question: Question.singleAnswer("Q1"), answerCallback: { _ in })
		sut.routeTo(question: Question.singleAnswer("Q2"), answerCallback: { _ in })

		XCTAssertEqual(navigationController.viewControllers.count, 2)
		XCTAssertEqual(navigationController.viewControllers.first, viewController)
		XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
	}

	func test_routeToQuestion_presentsQuestionViewControllerWithCorrectCallback() {
		var isAnswerCallbackFired = false
		sut.routeTo(question: Question.singleAnswer("Q1"), answerCallback: { _ in isAnswerCallbackFired = true })

		factory.answerCallbacks[Question.singleAnswer("Q1")]!("A1")

		XCTAssertTrue(isAnswerCallbackFired)
	}

	func test_routeToResults_presentsResultsViewController() {
		let viewController = UIViewController()
		let result = Result(answers: [Question.singleAnswer("Q1"): "A1"], score: 10)
		let secondViewController = UIViewController()
		let secondResult = Result(answers: [Question.singleAnswer("Q2"): "A2"], score: 20)
		factory.stub(result: result, with: viewController)

		sut.routeTo(result: result)
		sut.routeTo(result: secondResult)

		XCTAssertEqual(navigationController.viewControllers.count, 2)
		XCTAssertEqual(navigationController.viewControllers.first, viewController)
		XCTAssertEqual(navigationController.viewControllers.first, secondViewController)
	}

	class ViewControllerFactoryStub: ViewControllerFactory {
		private var stubbedQuestions = [Question<String>: UIViewController]()
		private var stubbedResults = [Result<Question<String>, String>: UIViewController]()
		var answerCallbacks = [Question<String>: (String) -> Void]()

		func questionViewController(for question: Question<String>, answerCallback: @escaping (String) -> Void) -> UIViewController {
			answerCallbacks[question] = answerCallback
			return stubbedQuestions[question] ?? UIViewController()
		}

		func resultsViewController(for result: Result<Question<String>, String>) -> UIViewController {
			return stubbedResults[result] ?? UIViewController()
		}

		func stub(question: Question<String>, with viewController: UIViewController) {
			stubbedQuestions[question] = viewController
		}

		func stub(result: Result<Question<String>, String>, with viewController: UIViewController) {
			stubbedResults[result] = viewController
		}
	}

	class NonAnimatingNavigationViewController: UINavigationController {
		override func pushViewController(_ viewController: UIViewController, animated: Bool) {
			super.pushViewController(viewController, animated: false)
		}
	}
}

extension Result: Hashable {
	init(answers: [Question: Answer], score: Int) {
		self.answers = answers
		self.score = score
	}

	public static func == (lhs: QuizEngine.Result<Question, Answer>, rhs: QuizEngine.Result<Question, Answer>) -> Bool {
		return lhs.score == rhs.score
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(1)
	}
}
