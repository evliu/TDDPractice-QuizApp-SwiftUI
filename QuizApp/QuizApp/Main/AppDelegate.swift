//
//  AppDelegate.swift
//  QuizApp
//
//  Created by Everest Liu on 9/5/23.
//

import QuizEngine
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	var quiz: Quiz?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let Q1 = Question.singleAnswer("Q1")
		let Q2 = Question.multipleAnswer("Q2")
		let questions = [Q1, Q2]
		let options = [Q1: ["A1", "A2", "A3"], Q2: ["Right", "Wrong", "Correct", "Mistaken"]]
		let correctAnswers = [(Q1, ["A2"]), (Q2, ["Right", "Correct"])]

		let navigationController = UINavigationController()
		let factory = iOSSwiftUIViewControllerFactory(options: options, correctAnswers: correctAnswers)
		let router = NavigationControllerRouter(navigationController, factory: factory)

		let window = UIWindow(frame: UIScreen.main.bounds)
		self.window = window

		window.rootViewController = navigationController
		window.makeKeyAndVisible()

		quiz = Quiz.start(questions: questions, delegate: router)

		return true
	}
}
