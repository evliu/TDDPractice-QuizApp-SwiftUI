//
//  MultipleSelectionState.swift
//  QuizApp
//
//  Created by Everest Liu on 9/30/23.
//

import Foundation

struct MultipleSelectionOption {
	let text: String
	var isSelected = false

	mutating func select() { isSelected.toggle() }
}

struct MultipleSelectionState {
	var options: [MultipleSelectionOption]
	private let handler: ([String]) -> Void

	var canSubmit: Bool { options.contains { $0.isSelected }}

	init(options: [String], handler: @escaping ([String]) -> Void = { _ in }) {
		self.options = options.map { MultipleSelectionOption(text: $0) }
		self.handler = handler
	}

	func submit() {
		guard canSubmit else { return }

		handler(
			options
				.filter(\.isSelected)
				.map(\.text)
		)
	}
}
