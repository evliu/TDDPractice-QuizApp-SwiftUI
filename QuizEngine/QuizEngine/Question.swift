//
//  Question.swift
//  QuizApp
//
//  Created by Everest Liu on 9/11/23.
//

import Foundation

public enum Question<T: Hashable>: Hashable {
	case singleAnswer(T)
	case multipleAnswer(T)

	public func hash(into hasher: inout Hasher) {
		switch self {
			case .singleAnswer(let x):
				return hasher.combine(x)
			case .multipleAnswer(let x):
				return hasher.combine(x)
		}
	}

	public var hashValue: Int {
		switch self {
			case .singleAnswer(let x):
				return x.hashValue
			case .multipleAnswer(let x):
				return x.hashValue
		}
	}
}
