//
//  FileDialogues.swift
//  
//

import AppKit

public class FileDialogues {
	/// Creates an Open/Save Dialogue panel for the user.
	/// - Parameters:
	/// - Returns: The panel itself, to get URLs from, and the response from the user.
	public static func openPanel(message: String, prompt: String, canChooseDirectories: Bool, canChooseFiles: Bool, allowsMultipleSelection: Bool, canCreateDirectories: Bool, allowedFileTypes: [String]? = nil) -> (NSOpenPanel, NSApplication.ModalResponse) {
		let openPanel = NSOpenPanel()
		openPanel.message = message
		openPanel.prompt = prompt
		openPanel.canChooseDirectories = canChooseDirectories
		openPanel.canChooseFiles = canChooseFiles
		openPanel.allowsMultipleSelection = allowsMultipleSelection
		openPanel.canCreateDirectories = canCreateDirectories
		if allowedFileTypes != nil {
			openPanel.allowedFileTypes = allowedFileTypes
		}
		return (openPanel, openPanel.runModal())
	}
	
	public static func savePanel(title: String, message: String, nameFieldLabel: String, nameField: String, currentDirectory: URL?, canCreateDirectories: Bool, canSelectHiddenExtension: Bool) -> (URL?, NSApplication.ModalResponse) {
		let panel = NSSavePanel()
		panel.title = title
		panel.message = message
		panel.nameFieldLabel = nameFieldLabel
		panel.nameFieldStringValue = nameField
		if currentDirectory != nil {
			panel.directoryURL = currentDirectory
		}
		panel.canCreateDirectories = canCreateDirectories
		panel.canSelectHiddenExtension = canSelectHiddenExtension
		
		let res = panel.runModal()
		return (panel.url, res)
	}
	
	public static func savePanelModal(for window: NSWindow, message: String, nameFieldLabel: String, nameField: String, currentDirectory: URL?, canCreateDirectories: Bool, canSelectHiddenExtension: Bool, isExtensionHidden: Bool, completionHandler handler: @escaping (NSApplication.ModalResponse, URL?) -> Void) {
		let panel = NSSavePanel()
		panel.message = message
		panel.nameFieldLabel = nameFieldLabel
		panel.nameFieldStringValue = nameField
		if currentDirectory != nil {
			panel.directoryURL = currentDirectory
		}
		panel.canCreateDirectories = canCreateDirectories
		panel.canSelectHiddenExtension = canSelectHiddenExtension
		panel.isExtensionHidden = isExtensionHidden
		
		panel.beginSheetModal(for: window, completionHandler: { response in
			handler(response, panel.url)
		})
	}
	
}
