//
//  AppDelegate.swift
//  QuizApp
//
//  Created by Everest Liu on 9/5/23.
//

import UIKit
import QuizEngine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let window = UIWindow(frame: UIScreen.main.bounds)
		let viewController = QuestionViewController(question: "A question?", options: ["Option 1", "Option 2"], selection: { selected in
			print(selected)
		})

		let resultsViewController = ResultsViewController(summary: "You got 1/2 correct", answers: [
			PresentableAnswer(question: "Is this an answer?", answer: "Maybe?", wrongAnswer: "Not at all"),
			PresentableAnswer(question: "Is this an answer? Is this an answer? Is this an answer? Is this an answer? Is this an answer? Is this an answer? ", answer: "Maybe?", wrongAnswer: "Not at all Not at all Not at all Not at all Not at all Not at all Not at all "),
			PresentableAnswer(question: "Is this a question?", answer: "Of course", wrongAnswer: nil),
			PresentableAnswer(question: "Is this a question?Is this a question?Is this a question?Is this a question?", answer: "Of course Of course Of course Of course Of course Of course Of course Of course ", wrongAnswer: nil)
		])

		viewController.loadViewIfNeeded()
		viewController.tableView.allowsMultipleSelection = false

		window.rootViewController = resultsViewController

		self.window = window
		window.makeKeyAndVisible()

		return true
	}
}
