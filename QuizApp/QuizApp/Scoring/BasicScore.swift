//
//  BasicScore.swift
//  QuizApp
//
//  Created by Everest Liu on 9/25/23.
//

import Foundation

enum BasicScore {
	static func score<T: Equatable>(for answers: [T], comparingTo correctAnswers: [T] = []) -> Int {
		if answers.isEmpty { return 0 }

		return zip(answers, correctAnswers).reduce(0) { score, tuple in
			score + (tuple.0 == tuple.1 ? 1 : 0)
		}
	}
}
