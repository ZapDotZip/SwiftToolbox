//
//  STBPathListController.swift
//  SwiftToolbox
//

import Cocoa

public class STBPathListController: NSViewController, STBDropAcceptor, NSMenuItemValidation {
	
	public var canChooseFiles = true
	public var canChooseDirectories = true
	public var canSelectMultipleItems = true
	
	@IBOutlet var dropView: STBDroppableScrollView!
	@IBOutlet var table: NSTableView!
	
	@objc dynamic var list: [STBPLPathObject] = []
	
	public func droppedItems(_ items: [URL]) {
		addItems(items)
	}
	
	public func addItems(_ items: [URL]) {
		list.append(contentsOf: items.compactMap { item in
			let newItem = STBPLPathObject.init(item.localPath)
			if !list.contains(newItem) {
				return newItem
			} else {
				return nil
			}
		})
	}
	
	internal final func isRowValid(_ row: Int) -> Bool {
		if row < 0 || row >= list.count {
			return false
		} else {
			return true
		}
	}
	
	public func setList(to list: [URL]) {
		self.list = list.map({ STBPLPathObject($0.localPath) })
	}
	
	public func removeItem(_ item: URL) {
		list.removeAll(where: { $0.path == item.localPath })
	}
	
	public func getList() -> [URL] {
		list.map({ URL(localPath: $0.path) })
	}
	
	@IBAction func copyPath(_ sender: Any) {
		let str = table.selectedRowIndexes.compactMap ({ row in
			if isRowValid(row) {
				return list[row].path
			}
			return nil
		}).joined(separator: "\n")
		
		NSPasteboard.general.setString(str, forType: .string)
	}
	
	@IBAction func delete(_ sender: Any) {
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
	}
	
	@IBAction @objc func paste(_ sender: AnyObject?) {
		if let urls = NSPasteboard.general.readObjects(forClasses: [NSURL.self], options: [.urlReadingFileURLsOnly : NSNumber.init(booleanLiteral: true)])?.compactMap ({ return ($0 as? URL) ?? nil }) {
			addItems(urls)
		} else if let strings = NSPasteboard.general.string(forType: .string)?.split(separator: "\n").map({ str in
			return URL(localPath: String(str))
		}) {
			addItems(strings)
		}
	}
	
	public func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
		if isRowValid(table.clickedRow) || menuItem.identifier?.rawValue == "pastePathsMenuItem" {
			return true
		}
		return false
	}

}
