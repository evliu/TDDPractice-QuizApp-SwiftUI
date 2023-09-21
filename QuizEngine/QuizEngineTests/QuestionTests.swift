//
//  QuestionTests.swift
//  QuizAppTests
//
//  Created by Everest Liu on 9/11/23.
//

import QuizEngine
import XCTest

final class QuestionTests: XCTestCase {
	func test_hashValue_singleAnswer_returnsTypeHash() {
		let type = "A quiz string"
		let sut = Question.singleAnswer(type)

		XCTAssertEqual(sut.hashValue, type.hashValue)
	}

	func test_hashInto_singleAnswer_returnsTypeHash() {
		let type = "Another quiz string"
		let sut = Question.singleAnswer(type)

		var hasher1 = Hasher()
		var hasher2 = Hasher()

		type.hash(into: &hasher1)
		sut.hash(into: &hasher2)

		XCTAssertEqual(hasher1.finalize(), hasher2.finalize())
	}

	func test_hashInto_multipleAnswer_returnsTypeHash() {
		let type = ["Another quiz string", "a third type", "3"]
		let sut = Question.multipleAnswer(type)

		var hasher1 = Hasher()
		var hasher2 = Hasher()

		type.hash(into: &hasher1)
		sut.hash(into: &hasher2)

		XCTAssertEqual(hasher1.finalize(), hasher2.finalize())
	}
}
