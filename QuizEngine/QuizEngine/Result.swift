//
//  Result.swift
//  QuizEngine
//
//  Created by Everest Liu on 9/8/23.
//

import Foundation

public struct Result<Question: Hashable, Answer> {
	public let answers: [Question: Answer]
	public let score: Int
}
