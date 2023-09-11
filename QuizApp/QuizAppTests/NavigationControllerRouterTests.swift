//
//  NavigationControllerRouterTests.swift
//  QuizAppTests
//
//  Created by Everest Liu on 9/9/23.
//

@testable import QuizApp
import XCTest

final class NavigationControllerRouterTests: XCTestCase {
	let navigationController = NonAnimatingNavigationViewController()
	let factory = ViewControllerFactoryStub()

	lazy var sut: NavigationControllerRouter = .init(self.navigationController, factory: self.factory)

	func test_routeToQuestions_presentsQuestionViewController() {
		let viewController = UIViewController()
		let secondViewController = UIViewController()
		factory.stub(question: "Q1", with: viewController)
		factory.stub(question: "Q2", with: secondViewController)

		sut.routeTo(question: "Q1", answerCallback: { _ in })
		sut.routeTo(question: "Q2", answerCallback: { _ in })

		XCTAssertEqual(navigationController.viewControllers.count, 2)
		XCTAssertEqual(navigationController.viewControllers.first, viewController)
		XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
	}

	func test_routeToQuestion_presentsQuestionViewControllerWithCorrectCallback() {
		var isAnswerCallbackFired = false
		sut.routeTo(question: "Q1", answerCallback: { _ in isAnswerCallbackFired = true })

		factory.answerCallbacks["Q1"]!("A1")

		XCTAssertTrue(isAnswerCallbackFired)
	}

	class ViewControllerFactoryStub: ViewControllerFactory {
		private var stubbedQuestions = [String: UIViewController]()
		var answerCallbacks = [String: (String) -> Void]()

		func questionViewController(for question: String, answerCallback: @escaping (String) -> Void) -> UIViewController {
			answerCallbacks[question] = answerCallback
			return stubbedQuestions[question] ?? UIViewController()
		}

		func stub(question: String, with viewController: UIViewController) {
			stubbedQuestions[question] = viewController
		}
	}

	class NonAnimatingNavigationViewController: UINavigationController {
		override func pushViewController(_ viewController: UIViewController, animated: Bool) {
			super.pushViewController(viewController, animated: false)
		}
	}
}
