//
//  ResultsViewController.swift
//  QuizApp
//
//  Created by Everest Liu on 9/5/23.
//

import UIKit

struct PresentableAnswer {
	let isCorrect: Bool
}

class CorrectAnswerCell: UITableViewCell {}
class WrongAnswerCell: UITableViewCell {}

class ResultsViewController: UIViewController, UITableViewDataSource {
	@IBOutlet var headerLabel: UILabel!
	@IBOutlet var tableView: UITableView!

	private var summary = ""
	private var answers = [PresentableAnswer]()

	// MARK: UIViewController

	convenience init(summary: String, answers: [PresentableAnswer]) {
		self.init()
		self.summary = summary
		self.answers = answers
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		headerLabel.text = summary
	}

	// MARK: UITableViewDataSource

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return answers.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let answer = answers[indexPath.row]
		return answer.isCorrect ? CorrectAnswerCell() : WrongAnswerCell()
	}
}
