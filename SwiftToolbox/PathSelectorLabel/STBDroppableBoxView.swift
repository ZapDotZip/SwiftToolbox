//
//  STBDroppableBoxView.swift
//  SwiftToolbox
//

import Cocoa

/// Accepts a single dropped file or folder.
class STBDroppableBoxView: NSView {
	@IBOutlet var dropAcceptor: STBDropAcceptor!
	private var defaultBorderColor: CGColor = NSColor.clear.cgColor
	
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	
	override public func awakeFromNib() {
		super.awakeFromNib()
		if #available(macOS 10.13, *) {
			self.registerForDraggedTypes([.fileURL])
		} else {
			self.registerForDraggedTypes([NSPasteboard.PasteboardType(kUTTypeFileURL as String)])
		}
	}
	
	private func commonInit() {
		self.wantsLayer = true
		self.layer!.borderWidth = 1.0
		self.layer!.borderColor = defaultBorderColor
		self.layer!.cornerRadius = 6
	}
	
	private final func isDragValid(_ sender: NSDraggingInfo) -> Bool {
		if let objs = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self]), objs.count == 1, let first = objs.first as? URL {
			if first.hasDirectoryPath {
				return dropAcceptor.canChooseDirectories
			} else {
				return dropAcceptor.canChooseFiles
			}
		}
		return false
	}
	
	override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
		if isDragValid(sender) {
			self.layer!.borderColor = NSColor.selectedControlColor.cgColor
			return .link
		} else {
			return NSDragOperation()
		}
	}
	
	override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
		return isDragValid(sender)
	}
	
	override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
		if let draggedItems = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: nil) {
			if let draggedItem = draggedItems.first as? URL {
				dropAcceptor.droppedItems([draggedItem])
			}
		}
		return false
	}
	
	override func draggingExited(_ sender: NSDraggingInfo?) {
		self.layer?.borderColor = defaultBorderColor
	}
	
	override func draggingEnded(_ sender: NSDraggingInfo) {
		self.layer?.borderColor = defaultBorderColor
	}
	
}
