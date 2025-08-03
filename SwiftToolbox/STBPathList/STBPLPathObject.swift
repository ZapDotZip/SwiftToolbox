//
//  STBPLPathObject.swift
//  SwiftToolbox
//

import Cocoa

internal class STBPLPathObject: NSObject {
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
