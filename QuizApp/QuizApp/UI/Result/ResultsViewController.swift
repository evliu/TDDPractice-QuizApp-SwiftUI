//
//  ResultsViewController.swift
//  QuizApp
//
//  Created by Everest Liu on 9/5/23.
//

import UIKit

class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	@IBOutlet var headerLabel: UILabel!
	@IBOutlet var tableView: UITableView!

	private(set) var summary = ""
	private(set) var answers = [PresentableAnswer]()

	// MARK: UIViewController

	convenience init(summary: String, answers: [PresentableAnswer]) {
		self.init()
		self.summary = summary
		self.answers = answers
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		headerLabel.text = summary
		tableView.rowHeight = UITableView.automaticDimension
		tableView.register(CorrectAnswerCell.self)
		tableView.register(WrongAnswerCell.self)
	}

	// MARK: UITableViewDataSource

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return answers.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let answer = answers[indexPath.row]
		if answer.wrongAnswer == nil {
			return correctAnswerCell(for: answer)
		} else {
			return wrongAnswerCell(for: answer)
		}
	}

	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return answers[indexPath.row].wrongAnswer == nil ? 90 : 130
	}

	private func correctAnswerCell(for answer: PresentableAnswer) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(CorrectAnswerCell.self)!
		cell.questionLabel.text = answer.question
		cell.answerLabel.text = answer.answer

		return cell
	}

	private func wrongAnswerCell(for answer: PresentableAnswer) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(WrongAnswerCell.self)!
		cell.questionLabel.text = answer.question
		cell.correctAnswerLabel.text = answer.answer
		cell.wrongAnswerLabel.text = answer.wrongAnswer

		return cell
	}
}
