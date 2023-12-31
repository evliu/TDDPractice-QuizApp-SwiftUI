//
//  QuestionViewController.swift
//  QuizApp
//
//  Created by Everest Liu on 9/5/23.
//

import UIKit

class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	@IBOutlet var headerLabel: UILabel!
	@IBOutlet var tableView: UITableView!

	private(set) var question = ""
	private(set) var options = [String]()
	private(set) var allowsMultipleSelection = false
	private var selection: (([String]) -> Void)? = nil
	private var reuseIndentifier = "Cell"

	convenience init(question: String, options: [String], allowsMultipleSelection: Bool, selection: @escaping ([String]) -> Void) {
		self.init()
		self.question = question
		self.options = options
		self.allowsMultipleSelection = allowsMultipleSelection
		self.selection = selection
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.allowsMultipleSelection = allowsMultipleSelection

		headerLabel.text = question
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return options.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = dequeueCell(in: tableView)
		cell.textLabel?.text = options[indexPath.row]

		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selection?(selectedOptions(in: tableView))
	}

	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		if tableView.allowsMultipleSelection {
			selection?(selectedOptions(in: tableView))
		}
	}

	private func selectedOptions(in tableView: UITableView) -> [String] {
		guard let indexPaths = tableView.indexPathsForSelectedRows else { return [] }

		return indexPaths.map { options[$0.row] }
	}

	private func dequeueCell(in tableView: UITableView) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIndentifier) {
			return cell
		} else {
			return UITableViewCell(style: .default, reuseIdentifier: reuseIndentifier)
		}
	}
}
