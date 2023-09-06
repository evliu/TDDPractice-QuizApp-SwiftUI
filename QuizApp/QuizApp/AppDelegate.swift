//
//  AppDelegate.swift
//  QuizApp
//
//  Created by Everest Liu on 9/5/23.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let window = UIWindow(frame: UIScreen.main.bounds)
		let viewController = QuestionViewController(question: "A question?", options: ["Option 1", "Option 2"], selection: { selected in
			print(selected)
		})

		viewController.loadViewIfNeeded()
		viewController.tableView.allowsMultipleSelection = false

		window.rootViewController = viewController

		self.window = window
		window.makeKeyAndVisible()

		return true
	}
}
