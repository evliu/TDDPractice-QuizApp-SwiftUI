//
//  Question.swift
//  QuizApp
//
//  Created by Everest Liu on 9/11/23.
//

import Foundation

enum Question<T: Hashable>: Hashable {
	case singleAnswer(T)
	case multipleAnswer(T)

	func hash(into hasher: inout Hasher) {
		switch self {
			case .singleAnswer(let x):
				return hasher.combine(x)
			case .multipleAnswer(let x):
				return hasher.combine(x)
		}
	}

	var hashValue: Int {
		switch self {
			case .singleAnswer(let x):
				return x.hashValue
			case .multipleAnswer(let x):
				return x.hashValue
		}
	}

	static func ==(lhs: Question<T>, rhs: Question<T>) -> Bool {
		switch (lhs, rhs) {
			case (.singleAnswer(let x), .singleAnswer(let y)):
				return x == y
			case (.multipleAnswer(let x), .multipleAnswer(let y)):
				return x == y
			default:
				return false
		}
	}
}
