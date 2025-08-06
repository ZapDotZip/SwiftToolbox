//
//  STBPathListController.swift
//  SwiftToolbox
//

import Cocoa

/// Manages an `STBPathList`, A single-column table designed for users to interact with a list of paths. Users can drag and drop, delete, paste a list of paths, or type their own path in.
///
/// See ``STBPathListView`` for details on how to add the view to Interface builder.
public class STBPathListController: NSViewController, STBDropAcceptor, NSMenuItemValidation {
	
	/// Used to validate drag and drop.
	public var canChooseFiles = true
	/// Used to validate drag and drop.
	public var canChooseDirectories = true
	/// Required for conformance with `STBDropAcceptor`. Setting the value has no effect.
	public var canSelectMultipleItems: Bool {
		get { return true }
		set { }
	}
	
	/// Will be set to true if the list changes. Is observable.
	@objc dynamic public private(set) var listDidChange: Bool = false
	/// The number of paths in the list.
	public var listCount: Int {
		return list.count
	}
	
	@IBOutlet var dropView: STBDroppableScrollView!
	@IBOutlet var table: NSTableView!
	
	@objc dynamic private var list: [STBPLPathObject] = []
	
	/// Sets the table to show the specified list, replacing the current list of paths. Sets ``listDidChange`` to false.
	/// - Parameter list: The list of paths to display instead of the old list.
	public func setList(to list: [URL]) {
		self.list = list.map({
			let newItem = STBPLPathObject($0.localPath)
			newItem.addObserver(self, forKeyPath: "path", context: nil)
			return newItem
		})
		listDidChange = false
	}
	
	/// Adds an empty cell for the user to enter a path.
	/// - Parameter sender: Not used.
	@IBAction public func newItem(_ sender: Any) {
		list.append(STBPLPathObject.init("Type in a path..."))
		table.editColumn(0, row: list.count - 1, with: nil, select: true)
		listDidChange = true
	}
	
	/// Adds paths to the bottom of the list. Will not add duplicate paths.
	/// - Parameter items: An array of paths to add.
	public func addItems(_ items: [URL]) {
		list.append(contentsOf: items.compactMap { item in
			if !list.contains(where: { $0.path == item.localPath }) {
				let newItem: STBPLPathObject = STBPLPathObject.init(item.localPath)
				newItem.addObserver(self, forKeyPath: "path", context: nil)
				return newItem
			} else {
				return nil
			}
		})
		listDidChange = true
	}
	
	/// Removes a path from the list. Removes all instances of the path.
	/// - Parameter item: The path to remove.
	public func removeItem(_ item: URL) {
		let initialCount = list.count
		list.removeAll(where: { $0.path == item.localPath })
		if initialCount != list.count {
			listDidChange = true
		}
	}
	
	/// Gets the current state of the list displayed by the table.
	/// - Returns: The list of URLs being displayed.
	public func getList() -> [URL] {
		return list.map({ URL(localPath: $0.path) })
	}
	
	/// Internally used to accept items dropped on the table. Use ``addItems(_:)`` to add items to the list programmatically.
	public func droppedItems(_ items: [URL]) {
		addItems(items)
	}
	
	/// Sets the clipboard to the selected row(s).
	@IBAction private func copyPath(_ sender: Any) {
		let str = table.selectedRowIndexes.compactMap ({ row in
			if isRowValid(row) {
				return list[row].path
			}
			return nil
		}).joined(separator: "\n")
		NSPasteboard.general.clearContents()
		NSPasteboard.general.setString(str, forType: .string)
	}
	
	/// Deletes the item from the list when the user selects the delete menu item.
	@IBAction private func delete(_ sender: Any) {
		if table.selectedRowIndexes.count != 0 {
			print(table.selectedRowIndexes)
			table.selectedRowIndexes.reversed().forEach { row in
				guard isRowValid(row) else { return }
				list.remove(at: row)
			}
		} else {
			guard isRowValid(table.clickedRow) else { return }
			list.remove(at: table.clickedRow)
		}
		listDidChange = true
	}
	
	/// Handles importing the pasteboard when the user selects the paste menu item.
	@IBAction @objc private func paste(_ sender: AnyObject?) {
		if let urls = NSPasteboard.general.readObjects(forClasses: [NSURL.self], options: [.urlReadingFileURLsOnly : NSNumber.init(booleanLiteral: true)])?.compactMap ({ return ($0 as? URL) ?? nil }) {
			addItems(urls)
		} else if let strings = NSPasteboard.general.string(forType: .string)?.split(separator: "\n").map({ str in
			return URL(localPath: String(str))
		}) {
			addItems(strings)
		}
	}
	
	/// Internally used for displaying the right-click menu.
	public func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
		if isRowValid(table.clickedRow) ||
			menuItem.identifier?.rawValue == "pastePathsMenuItem" ||
			menuItem.identifier?.rawValue == "newItemMenuItem" {
			return true
		}
		return false
	}
	
	/// Checks if the passed row is a valid index in the array.
	/// - Parameter row: The row to check.
	/// - Returns: True if the row is a valid index, false if not.
	private final func isRowValid(_ row: Int) -> Bool {
		if row < 0 || row >= list.count {
			return false
		} else {
			return true
		}
	}
	
	/// Internally used for detecting list changes.
	public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		guard keyPath == "path" else {
			return super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
		}
		listDidChange = true
	}
	
}
