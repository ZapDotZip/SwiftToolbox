//
//  PathSelectorLabelViewController.swift
//  SwiftToolbox
//

import Cocoa

public class PathSelectorLabelView: NSView {
	@IBOutlet var mainView: NSView!
	
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


public class PathSelectorLabelViewController: NSViewController {
	@IBOutlet private var selectPathButton: NSButton!
	@IBOutlet private var pathLabel: NSTextField!
	@IBOutlet private var unsetPathButton: NSButton!
	
	public func setup(into parentView: NSView) {
	}
	
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
			if #available(macOS 13.0, *) {
				if let str = newValue?.path() {
					pathLabel.stringValue = str
				}
			} else {
				if let str = newValue?.path {
					pathLabel.stringValue = str
				}
			}
			_path = newValue
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
		// Do view setup here.
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
