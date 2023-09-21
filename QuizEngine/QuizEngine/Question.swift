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
}
