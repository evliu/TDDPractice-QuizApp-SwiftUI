//
//  ResultsViewController.swift
//  QuizApp
//
//  Created by Everest Liu on 9/5/23.
//

import UIKit

struct PresentableAnswer {
	let question: String
	let answer: String
	let isCorrect: Bool
}

class CorrectAnswerCell: UITableViewCell {
	@IBOutlet var questionLabel: UILabel!
	@IBOutlet var answerLabel: UILabel!
}

class WrongAnswerCell: UITableViewCell {
	@IBOutlet var questionLabel: UILabel!
	@IBOutlet var correctAnswerLabel: UILabel!
}

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

		tableView.register(UINib(nibName: "CorrectAnswerCell", bundle: nil), forCellReuseIdentifier: "CorrectAnswerCell")
		tableView.register(UINib(nibName: "WrongAnswerCell", bundle: nil), forCellReuseIdentifier: "WrongAnswerCell")
	}

	// MARK: UITableViewDataSource

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return answers.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let answer = answers[indexPath.row]
		if answer.isCorrect {
			return correctAnswerCell(for: answer)
		} else {
			return wrongAnswerCell(for: answer)
		}
	}

	private func correctAnswerCell(for answer: PresentableAnswer) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CorrectAnswerCell") as! CorrectAnswerCell
		cell.questionLabel.text = answer.question
		cell.answerLabel.text = answer.answer

		return cell
	}

	private func wrongAnswerCell(for answer: PresentableAnswer) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "WrongAnswerCell") as! WrongAnswerCell
		cell.questionLabel.text = answer.question
		cell.correctAnswerLabel.text = answer.answer

		return cell
	}
}
