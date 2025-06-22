//
//  FileDialogues.swift
//  
//

import AppKit

public class FileDialogues {
	public typealias completionHandler = ([URL]?) -> Void
	
	private static func createOpenPanel(message: String?, prompt: String?, canChooseDirectories: Bool, canChooseFiles: Bool, canSelectMultipleItems: Bool, canCreateDirectories: Bool, allowedFileTypes: [String]? = nil) -> NSOpenPanel {
		let openPanel = NSOpenPanel()
		if let message {
			openPanel.message = message
		}
		if let prompt {
			openPanel.prompt = prompt
		}
		openPanel.canChooseDirectories = canChooseDirectories
		openPanel.canChooseFiles = canChooseFiles
		openPanel.allowsMultipleSelection = canSelectMultipleItems
		openPanel.canCreateDirectories = canCreateDirectories
		if let allowedFileTypes {
			openPanel.allowedFileTypes = allowedFileTypes
		}
		return openPanel
	}
	
	/// Creates an Open/Save Dialogue panel for the user.
	/// - Parameters:
	///   - message: The message to display to the user, nothing if unspecified.
	///   - prompt: The select button text, "Open" if unspecified.
	///   - canChooseDirectories: If the user can select directories.
	///   - canChooseFiles: If the user can choose files.
	///   - canSelectMultipleItems: If the user can choose multiple items.
	///   - canCreateDirectories: If the user can create directories.
	///   - allowedFileTypes: The files types that are allowed to be selected. All items are allowed if unspecified.
	/// - Returns: An array of selected `URL`s, or `nil` if the user clicked the cancel button.
	public static func openPanel(message: String?, prompt: String?, canChooseDirectories: Bool, canChooseFiles: Bool, canSelectMultipleItems: Bool, canCreateDirectories: Bool, allowedFileTypes: [String]? = nil) -> [URL]? {
		let openPanel = createOpenPanel(message: message, prompt: prompt, canChooseDirectories: canChooseDirectories, canChooseFiles: canChooseFiles, canSelectMultipleItems: canSelectMultipleItems, canCreateDirectories: canCreateDirectories, allowedFileTypes: allowedFileTypes)
		
		if openPanel.runModal() == .OK {
			return openPanel.urls
		} else {
			return nil
		}
	}
	
	/// Creates an Open/Save Dialogue panel for the user.
	/// - Parameters:
	///   - message: The message to display to the user, nothing if unspecified.
	///   - prompt: The select button text, "Open" if unspecified.
	///   - canChooseDirectories: If the user can select directories.
	///   - canChooseFiles: If the user can choose files.
	///   - canSelectMultipleItems: If the user can choose multiple items.
	///   - canCreateDirectories: If the user can create directories.
	///   - allowedFileTypes: The files types that are allowed to be selected. All items are allowed if unspecified.
	///   - handler: Receives an array of selected `URL`s, or `nil` if the user clicked the cancel button..
	public static func openPanelModal(for window: NSWindow, message: String?, prompt: String?, canChooseDirectories: Bool, canChooseFiles: Bool, canSelectMultipleItems: Bool, canCreateDirectories: Bool, allowedFileTypes: [String]? = nil, handler: @escaping completionHandler) {
		let openPanel = createOpenPanel(message: message, prompt: prompt, canChooseDirectories: canChooseDirectories, canChooseFiles: canChooseFiles, canSelectMultipleItems: canSelectMultipleItems, canCreateDirectories: canCreateDirectories, allowedFileTypes: allowedFileTypes)
		
		openPanel.beginSheetModal(for: window) { response in
			openPanel.orderOut(nil)
			if response == .OK {
				handler(openPanel.urls)
			} else {
				handler(nil)
			}
		}
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
