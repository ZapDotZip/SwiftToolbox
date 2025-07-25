//
//  ViewController.swift
//  SwiftToolboxTestApp
//

import Cocoa
import SwiftToolbox

class ViewController: NSViewController {
	
	@IBOutlet var label: NSTextField!
	
	var mainWindow: NSWindow {
		return NSApplication.shared.keyWindow!
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	override func viewDidAppear() {
		super.viewDidAppear()
	}
	
	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
	@IBAction func openPanel(_ sender: Any) {
		label.stringValue = FileDialogues.openPanel(message: "Open Something", canSelectMultipleItems: false, canCreateDirectories: false, selectableTypes: nil)?.first?.localPath ?? "nothing selected"
	}
	
	@IBAction func openPanelModal(_ sender: Any) {
		FileDialogues.openPanelModal(for: mainWindow, message: "Select a file", canSelectMultipleItems: false, canCreateDirectories: false, selectableTypes: [.files(allowedFileExtensions: nil)], handler: { urls in
			self.label.stringValue = urls?.first?.localPath ?? "nothing selected"
		})
	}
	
	@IBAction func savePanel(_ sender: Any) {
		label.stringValue = FileDialogues.savePanel(title: "Title", message: "Message", nameFieldLabel: "NameFieldLabel", nameField: "NameField", isExtensionHidden: true, allowedFileExtensions: ["test"])?.localPath ?? "nothing selected"
	}
	
	
	
}
