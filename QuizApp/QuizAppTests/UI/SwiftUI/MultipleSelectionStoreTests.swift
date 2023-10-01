//
//  MultipleSelectionStoreTests.swift
//  QuizAppTests
//
//  Created by Everest Liu on 9/30/23.
//

@testable import QuizApp
import XCTest

final class MultipleSelectionStoreTests: XCTestCase {
	var twoOptions = ["Option 0", "Option 1"]
	func test_selectOption_togglesState() throws {
		var sut = MultipleSelectionState(options: twoOptions)

		XCTAssertFalse(sut.options[0].isSelected)

		sut.options[0].select()
		XCTAssertTrue(sut.options[0].isSelected)

		sut.options[0].select()
		XCTAssertFalse(sut.options[0].isSelected)
	}

	func test_canSubmit_whenMinOneOptionSelected() {
		var sut = MultipleSelectionState(options: twoOptions)

		XCTAssertFalse(sut.canSubmit)

		sut.options[0].select()
		XCTAssertTrue(sut.canSubmit)

		sut.options[0].select()
		XCTAssertFalse(sut.canSubmit)

		sut.options[1].select()
		XCTAssertTrue(sut.canSubmit)
	}

	func test_submit_callsHandlerWithSelected() {
		var submittedOptions: [[String]] = []
		var sut = MultipleSelectionState(options: twoOptions, handler: { submittedOptions.append($0) })

		sut.submit()
		XCTAssertEqual(submittedOptions, [])

		sut.options[0].select()
		sut.submit()
		XCTAssertEqual(submittedOptions, [[twoOptions[0]]])

		sut.options[1].select()
		sut.submit()
		XCTAssertEqual(submittedOptions, [[twoOptions[0]], twoOptions])
	}
}
