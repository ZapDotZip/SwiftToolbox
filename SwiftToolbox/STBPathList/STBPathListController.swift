//
//  STBPathListController.swift
//  SwiftToolbox
//

import Cocoa

public class STBPLPathObject: NSObject {
	@objc dynamic var path: String {
		didSet {
			icon = NSWorkspace.shared.icon(forFile: path)
		}
	}
	@objc dynamic var icon: NSImage
	init(_ path: String) {
		self.path = path
		self.icon = NSWorkspace.shared.icon(forFile: path)
	}
	
	static public func == (lhs: STBPLPathObject, rhs: STBPLPathObject) -> Bool {
		return lhs.path == rhs.path
	}
	
	public override func isEqual(_ object: Any?) -> Bool {
		guard let obj = object as? STBPLPathObject else {
			return false
		}
		return self.path == obj.path
	}
	
}

public class STBPathListController: NSObject, STBDropAcceptor {
	public var canChooseFiles = true
	public var canChooseDirectories = true
	public var canSelectMultipleItems = true
	
	@IBOutlet var dropView: STBDroppableScrollView!
	
	@objc dynamic var list: [STBPLPathObject] = [STBPLPathObject("one"), STBPLPathObject("two")]
	
	public override func awakeFromNib() {
		super.awakeFromNib()
		dropView.dropAcceptor = self
	}
	
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
}
