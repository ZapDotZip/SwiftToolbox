//
//  STBDropAcceptor.swift
//  SwiftToolbox
//

/// Standarized way to communicate between a view that accepts drag-and-drop for files.
@objc public protocol STBDropAcceptor {
	/// Whether or not the user can drop files.
	var canChooseFiles: Bool { get set }
	/// Whether or not the user can drop folders.
	var canChooseDirectories: Bool { get set }
	/// Whether or not the user can drop multiple items..
	var canSelectMultipleItems: Bool { get set }
	
	/// Called when valid items are dropped.
	/// - Parameter items: The dropped items.
	func droppedItems(_ items: [URL])
}
