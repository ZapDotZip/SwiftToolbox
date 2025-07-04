//
//  PathSelectorLabelViewController.swift
//  SwiftToolbox
//

import Cocoa

public class PathSelectorLabelView: NSView {
	@IBOutlet private var mainView: NSView!
	@IBOutlet public var controller: PathSelectorLabelViewController!
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		let nib = NSNib(nibNamed: "PathSelectorLabelView", bundle: Bundle(for: PathSelectorLabelView.self))
		nib?.instantiate(withOwner: self, topLevelObjects: nil)
		let previousConstraints = mainView.constraints
		mainView.subviews.forEach({addSubview($0)})
		for constraint in previousConstraints {
			let firstItem = (constraint.firstItem as? NSView == mainView) ? self : constraint.firstItem
			let secondItem = (constraint.secondItem as? NSView == mainView) ? self : constraint.secondItem
			addConstraint(NSLayoutConstraint(item: firstItem as Any, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: secondItem, attribute: constraint.secondAttribute, multiplier: constraint.multiplier, constant: constraint.constant))
		}

	}
	
}


public class PathSelectorLabelViewController: NSViewController, DroppableView.DropAcceptor {
	public typealias callback = ((URL?) -> Bool)
	@IBOutlet private var selectPathButton: NSButton!
	@IBOutlet private var pathLabel: NSTextField!
	@IBOutlet private var unsetPathButton: NSButton!
	@IBOutlet private weak var dropBox: DroppableView!
	
	public func setup(path: URL?, callback: callback?) {
		if let path {
			self._path = path
			if #available(macOS 13.0, *) {
				pathLabel.stringValue = path.path()
			} else {
				pathLabel.stringValue = path.path
			}
			unsetPathButton.isEnabled = true
		} else {
			pathLabel.stringValue = ""
			unsetPathButton.isEnabled = false
		}
		self.pathSelectedCallback = callback
	}
	
	
	/// Called when the path changes. Return `true` if the selected path should change, otherwise `false` to keep the previous path.
	public var pathSelectedCallback: callback?
	
	public var selectPathButtonText: String {
		get {
			return selectPathButton.title
		}
		set {
			selectPathButton.title = newValue
		}
	}
	
	public var pathLabelPlaceholder: String? {
		get {
			return pathLabel.placeholderString
		}
		set {
			pathLabel.placeholderString = newValue
		}
	}
	
	private var _path: URL?
	public var path: URL? {
		get {
			return _path
		}
		set {
			let shouldSetNewValue = {
				guard let pathSelectedCallback else {
					return true
				}
				return pathSelectedCallback(newValue)
			}()
			
			if shouldSetNewValue {
				if #available(macOS 13.0, *) {
					pathLabel.stringValue = newValue?.path() ?? ""
				} else {
					pathLabel.stringValue = newValue?.path ?? ""
				}
				_path = newValue
				if newValue != nil {
					unsetPathButton.isEnabled = true
				} else {
					unsetPathButton.isEnabled = false
				}
			}
		}
	}
	
	public var openPanelMessage: String = "Select an item."
	public var openPanelPrompt: String = "Select"
	public var canChooseDirectories: Bool = true
	public var canChooseFiles: Bool = true
	public var canSelectMultipleItems: Bool = true
	public var canCreateDirectories: Bool = true
	public var allowedFileTypes: [String]?
	
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		if path != nil {
			unsetPathButton.isEnabled = true
		} else {
			unsetPathButton.isEnabled = false
		}
	}
	
	@IBAction func selectPathButtonPressed(_ sender: NSButton) {
		let res = FileDialogues.openPanel(message: openPanelMessage, prompt: openPanelPrompt, canChooseDirectories: canChooseDirectories, canChooseFiles: canChooseFiles, canSelectMultipleItems: canSelectMultipleItems, canCreateDirectories: canCreateDirectories, allowedFileTypes: allowedFileTypes)
		if let url = res?.first {
			path = url
		}
	}
	
	@IBAction func resetButtonPressed(_ sender: NSButton) {
		path = nil
	}
	
}

public class DroppableView: NSView {
	@objc public protocol DropAcceptor {
		var path: URL? { get set }
		var canChooseFiles: Bool { get set }
	}
	@IBOutlet var dropAcceptor: DropAcceptor!
	private var NormalBorderColor: CGColor = NSColor.clear.cgColor
	
	public override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		commonInit()
	}
	public required init?(coder: NSCoder) {
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
		self.layer!.borderColor = NormalBorderColor
		self.layer!.cornerRadius = 6
	}
	
	private final func isDragValid(_ sender: NSDraggingInfo) -> Bool {
		if let objs = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self]), objs.count == 1 {
			if dropAcceptor.canChooseFiles {
				return true
			} else if let url = objs.first as? URL {
				return url.hasDirectoryPath
			}
		}
		return false
	}
	
	public override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
		if isDragValid(sender) {
			self.layer!.borderColor = NSColor.selectedControlColor.cgColor
			return .copy
		} else {
			return NSDragOperation()
		}
	}
	
	public override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
		return isDragValid(sender)
	}
	
	public override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
		if let draggedItems = sender.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: nil) {
			if let draggedItem = draggedItems.first as? NSURL {
				dropAcceptor.path = draggedItem as URL
			}
		}
		return true
	}
	
	public override func draggingEnded(_ sender: NSDraggingInfo) {
		self.layer?.borderColor = NormalBorderColor
	}
	
	public override func draggingExited(_ sender: NSDraggingInfo?) {
		self.layer?.borderColor = NormalBorderColor
	}

}
