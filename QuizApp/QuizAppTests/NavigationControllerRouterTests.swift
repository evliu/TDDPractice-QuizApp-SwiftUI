//
//  NavigationControllerRouterTests.swift
//  QuizAppTests
//
//  Created by Everest Liu on 9/9/23.
//

@testable import QuizApp
import XCTest

final class NavigationControllerRouterTests: XCTestCase {
	func test_routeToQuestion_presentsQuestionController() {
		let navigationController = UINavigationController()
		let sut = NavigationControllerRouter(navigationController)

		sut.routeTo(question: "Q1", answerCallback: { _ in })

		print(navigationController.viewControllers)
		XCTAssertEqual(navigationController.viewControllers.count, 1)
	}

	func test_routeToQuestionTwice_presentsQuestionController() {
		let navigationController = UINavigationController()
		let sut = NavigationControllerRouter(navigationController)

		sut.routeTo(question: "Q1", answerCallback: { _ in })
		sut.routeTo(question: "Q2", answerCallback: { _ in })

		print(navigationController.viewControllers)
		XCTAssertEqual(navigationController.viewControllers.count, 2)
	}
}
