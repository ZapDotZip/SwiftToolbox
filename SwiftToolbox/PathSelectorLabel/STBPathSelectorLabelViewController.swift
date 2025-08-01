//
//  STBPathSelectorLabelViewController.swift
//  SwiftToolbox
//

import Cocoa


public class STBPathSelectorLabelViewController: NSViewController, STBDropAcceptor {
	
	public typealias Callback = ((URL?) -> Bool)
	@IBOutlet private var selectPathButton: NSButton!
	@IBOutlet private var pathLabel: NSTextField!
	@IBOutlet private var unsetPathButton: NSButton!
	@IBOutlet private weak var dropBox: STBDroppableBoxView!
	
	public func setup(path: URL?, callback: Callback?) {
		if let path {
			self._path = path
			pathLabel.stringValue = path.localPath
			unsetPathButton.isEnabled = true
		} else {
			pathLabel.stringValue = ""
			unsetPathButton.isEnabled = false
		}
		self.pathSelectedCallback = callback
	}
	
	
	/// Called when the path changes. Return `true` if the selected path should change, otherwise `false` to keep the previous path.
	public var pathSelectedCallback: Callback?
	
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
				pathLabel.stringValue = newValue?.localPath ?? ""
				_path = newValue
				if newValue != nil {
					unsetPathButton.isEnabled = true
				} else {
					unsetPathButton.isEnabled = false
				}
			}
		}
	}
	
	public func droppedItems(_ items: [URL]) {
		if let url = items.first {
			path = url
		}
	}
	
	public var openPanelMessage: String = "Select an item."
	public var openPanelPrompt: String = "Select"
	public var canChooseDirectories: Bool = true
	public var canChooseFiles: Bool = true
	public var canSelectMultipleItems: Bool = false
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
		let res = STBFilePanels.openPanel(message: openPanelMessage, prompt: openPanelPrompt, canSelectMultipleItems: canSelectMultipleItems, canCreateDirectories: canCreateDirectories, selectableTypes: nil)
		if let url = res?.first {
			path = url
		}
	}
	
	@IBAction func resetButtonPressed(_ sender: NSButton) {
		path = nil
	}
	
}
