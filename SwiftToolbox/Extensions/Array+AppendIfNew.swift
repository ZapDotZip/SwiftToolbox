//
//  Array+AppendIfNew.swift
//  SwiftToolbox
//

import Foundation


extension Array where Element : Equatable {
	
	/// Adds a new element at the end of the array if it does not already exist in the array.
	///
	/// - Parameter newElement: The element to append to the array.
	///
	/// - Complexity: O(*n*) on average, where *n* is the length of the array, in addition to the overhead for adding new elements.
	@inlinable public mutating func appendIfNew(_ newElement: Element) {
		if !contains(newElement) {
			append(newElement)
		}
	}
	
	/// Adds all elements of a sequence to the array if they do not already exist in the array.
	///
	/// - Parameter newElements: The elements to append to the array.
	///
	/// - Complexity: O(*n* \* *m*) on average, where *m* is the length of
	///   `newElements` and *n* is the length of the array, in addition to the overhead for adding new elements.
	@inlinable public mutating func appendIfNew<S>(contentsOf newElements: S) where Element == S.Element, S : Sequence {
		for element in newElements {
			if !contains(element) {
				append(element)
			}
		}
	}
	
}
