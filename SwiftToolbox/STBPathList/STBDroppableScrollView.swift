//
//  STBDroppableScrollView.swift
//  SwiftToolbox
//

import Cocoa

/// Accepts many dropped items.
class STBDroppableScrollView: NSScrollView {
	@IBOutlet var dropAcceptor: STBDropAcceptor!
	
	var defaultBorderColor = NSColor.clear.cgColor
	var hoverBorderColor = NSColor.selectedTextBackgroundColor.cgColor
	
	var defaultBorderWidth: CGFloat = 0.0
	var hoverBorderWidth: CGFloat = 2.0
	
	override func awakeFromNib() {
		super.awakeFromNib()
		if #available(macOS 10.13, *) {
			self.registerForDraggedTypes([.fileURL])
		} else {
			self.registerForDraggedTypes([NSPasteboard.PasteboardType(kUTTypeFileURL as String)])
		}
		self.wantsLayer = true
		defaultBorderColor = self.layer?.borderColor ?? defaultBorderColor
		defaultBorderWidth = self.layer?.borderWidth ?? 0.0
	}
	
	private final func isDragValid(_ sender: NSDraggingInfo) -> Bool {
		if let objs = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self]), objs.count > 0 {
			return true
		}
		return false
	}
	
	override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
		if isDragValid(sender) {
			self.layer?.borderWidth = hoverBorderWidth
			self.layer?.borderColor = hoverBorderColor
			return .copy
		} else {
			return NSDragOperation()
		}
	}
	
	override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
		return isDragValid(sender)
	}
	
	override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
		if let draggedItems = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: nil) {
			let validURLs = draggedItems.compactMap { return ($0 as? URL) ?? nil }
			if validURLs.count != 0 {
				dropAcceptor.droppedItems(validURLs)
				return true
			}
		}
		return false
	}
	
	override func draggingExited(_ sender: NSDraggingInfo?) {
		self.layer?.borderWidth = defaultBorderWidth
		self.layer?.borderColor = defaultBorderColor
	}
	
	override func draggingEnded(_ sender: NSDraggingInfo) {
		self.layer?.borderWidth = defaultBorderWidth
		self.layer?.borderColor = defaultBorderColor
	}
	
}
