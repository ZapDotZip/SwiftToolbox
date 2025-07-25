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
	
	@IBAction func openPanel(_ sender: Any) {
		label.stringValue = STBFilePanels.openPanel(message: "Open Something", canSelectMultipleItems: false, canCreateDirectories: false, selectableTypes: nil)?.first?.localPath ?? "nothing selected"
	}
	
	@IBAction func openPanelModal(_ sender: Any) {
		STBFilePanels.openPanelModal(for: mainWindow, message: "Select a file", canSelectMultipleItems: false, canCreateDirectories: false, selectableTypes: [.files(allowedFileExtensions: nil)], handler: { urls in
			self.label.stringValue = urls?.first?.localPath ?? "nothing selected"
		})
	}
	
	@IBAction func savePanel(_ sender: Any) {
		label.stringValue = STBFilePanels.savePanel(title: "Title", message: "Message", nameFieldLabel: "NameFieldLabel", nameField: "NameField", isExtensionHidden: true, allowedFileExtensions: ["test"])?.localPath ?? "nothing selected"
	}
	
	
	
}
