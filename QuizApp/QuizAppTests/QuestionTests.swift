//
//  QuestionTests.swift
//  QuizAppTests
//
//  Created by Everest Liu on 9/11/23.
//

import XCTest

@testable import QuizApp

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

	func test_equatable_isEqual() {
		XCTAssertEqual(Question.singleAnswer("one"), Question.singleAnswer("one"))
		XCTAssertEqual(Question.singleAnswer(8), Question.singleAnswer(8))
		XCTAssertEqual(Question.multipleAnswer(["one", "two"]), Question.multipleAnswer(["one", "two"]))
		XCTAssertEqual(Question.multipleAnswer([1, 2]), Question.multipleAnswer([1, 2]))
	}

	func test_equatable_isNotEqual() {
		XCTAssertNotEqual(Question.singleAnswer("one"), Question.singleAnswer("two"))
		XCTAssertNotEqual(Question.multipleAnswer(["one", "two"]), Question.multipleAnswer(["two", "two"]))
		XCTAssertNotEqual(Question.multipleAnswer([1, 2]), Question.multipleAnswer([3, 2]))
		XCTAssertNotEqual(Question.singleAnswer(1), Question.multipleAnswer(1))
	}
}
