//
//  STBFilePanels.swift
//  
//

import AppKit

/// Provides open and save file dialogues.
public class STBFilePanels {
	/// Used to indicate which file types a user can select in an file open panel.
	public enum SelectableTypes: Equatable {
		/// The user can select directories.
		case directories
		/// The user can select files.
		/// - Parameter allowedFileExtensions: An array of file extensions the user can select.
		case files(_ allowedExtensions: [String]? = nil)
	}
	
	public typealias CompletionHandler = ([URL]?) -> Void
	public typealias SaveCompletionHandler = (URL?) -> Void
	
	private static func createOpenPanel(message: String?, prompt: String?, canSelectMultipleItems: Bool, canCreateDirectories: Bool, selectableTypes: [SelectableTypes]?) -> NSOpenPanel {
		let openPanel = NSOpenPanel()
		if let message {
			openPanel.message = message
		}
		if let prompt {
			openPanel.prompt = prompt
		}
		if let selectableTypes, selectableTypes.count != 0 {
			openPanel.canChooseDirectories = false
			openPanel.canChooseFiles = false
			for st in selectableTypes {
				switch st {
					case .directories:
						openPanel.canChooseDirectories = true
					case .files(allowedFileExtensions: let allowedFileExtensions):
						openPanel.canChooseFiles = true
						if let allowedFileExtensions {
							openPanel.allowedFileTypes = allowedFileExtensions
						}
				}
			}
		} else {
			openPanel.canChooseDirectories = true
			openPanel.canChooseFiles = true
		}
		
		openPanel.allowsMultipleSelection = canSelectMultipleItems
		openPanel.canCreateDirectories = canCreateDirectories
		return openPanel
	}
	
	/// Creates and displays an open panel to the user.
	/// - Parameters:
	///   - message: The message to display to the user, nothing if `nil`.
	///   - prompt: The select button text, "Open" if unspecified.
	///   - canSelectMultipleItems: If the user can choose multiple items.
	///   - canCreateDirectories: If the user can create directories.
	///   - selectableTypes: An array of SelectableType options.
	/// - Returns: An array of selected `URL`s, or `nil` if the user clicked the cancel button.
	public static func openPanel(message: String?, prompt: String? = nil, canSelectMultipleItems: Bool, canCreateDirectories: Bool, selectableTypes: [SelectableTypes]?) -> [URL]? {
		let openPanel = createOpenPanel(message: message, prompt: prompt, canSelectMultipleItems: canSelectMultipleItems, canCreateDirectories: canCreateDirectories, selectableTypes: selectableTypes)
		
		if openPanel.runModal() == .OK {
			return openPanel.urls
		} else {
			return nil
		}
	}
	
	/// Creates and displays an open panel as a modal to the user.
	/// - Parameters:
	///   - window: The window to attach the modal to.
	///   - message: The message to display to the user, nothing if `nil`.
	///   - prompt: The select button text, "Open" if unspecified.
	///   - canSelectMultipleItems: If the user can choose multiple items.
	///   - canCreateDirectories: If the user can create directories.
	///   - selectableTypes: An array of SelectableType options.
	///   - handler: Recieves an array of urls if the user selected one or more URLs, otherwise `nil` if the user cancelled the panel.
	public static func openPanelModal(for window: NSWindow, message: String?, prompt: String? = nil, canSelectMultipleItems: Bool, canCreateDirectories: Bool, selectableTypes: [SelectableTypes]?, handler: @escaping CompletionHandler) {
		let openPanel = createOpenPanel(message: message, prompt: prompt, canSelectMultipleItems: canSelectMultipleItems, canCreateDirectories: canCreateDirectories, selectableTypes: selectableTypes)

		openPanel.beginSheetModal(for: window) { response in
			openPanel.orderOut(nil)
			if response == .OK {
				handler(openPanel.urls)
			} else {
				handler(nil)
			}
		}
	}
	
	private static func createSavePanel(title: String? = nil, message: String?, nameFieldLabel: String?, nameField: String?, currentDirectory: URL?, isExtensionHidden: Bool, allowedFileExtensions: [String]?) -> NSSavePanel {
		let panel = NSSavePanel()
		if let title {
			panel.title = title
		}
		if let message {
			panel.message = message
		}
		if let nameFieldLabel {
			panel.nameFieldLabel = nameFieldLabel
		}
		if let nameField {
			panel.nameFieldStringValue = nameField
		}
		if currentDirectory != nil {
			panel.directoryURL = currentDirectory
		}
		panel.canSelectHiddenExtension = true
		
		panel.isExtensionHidden = isExtensionHidden
		if let allowedFileExtensions {
			panel.allowedFileTypes = allowedFileExtensions
		}
		
		return panel
	}
	
	/// Creates and displays a save panel to the user.
	/// - Parameters:
	///   - title: The title of the window, "Save" if `nil`.
	///   - message: The message displayed above the name field prompt. Nothing if `nil`.
	///   - nameFieldLabel: The label in front of the name field. "Save As" if `nil`.
	///   - nameField: The inital text in the name field. "Untitled" if `nil`.
	///   - currentDirectory: The directory to place the user in. Defaults to the last navigated directory if `nil`.
	///   - isExtensionHidden: Determines whether or not the file extension is hidden by default.
	///   - allowedFileExtensions: A list of file extensions allowed, all are allowed if `nil`.
	/// - Returns: The `URL` the user selected, otherwise `nil` if the user cancelled the panel.
	public static func savePanel(title: String? = nil, message: String? = nil, nameFieldLabel: String? = nil, nameField: String?, currentDirectory: URL? = nil, isExtensionHidden: Bool, allowedFileExtensions: [String]?) -> URL? {
		let panel = createSavePanel(title: title, message: message, nameFieldLabel: nameFieldLabel, nameField: nameField, currentDirectory: currentDirectory, isExtensionHidden: isExtensionHidden, allowedFileExtensions: allowedFileExtensions)
		if panel.runModal() == .OK, let url = panel.url {
			return url
		} else {
			return nil
		}
	}
	
	/// Creates and displays a save panel as a modal to the user.
	/// - Parameters:
	///   - window: The window to attach the modal to.
	///   - message: The message displayed above the name field prompt. Nothing if `nil`.
	///   - nameFieldLabel: The label in front of the name field. "Save As" if `nil`.
	///   - nameField: The inital text in the name field. "Untitled" if `nil`.
	///   - currentDirectory: The directory to place the user in. Defaults to the last navigated directory if `nil`.
	///   - isExtensionHidden: Determines whether or not the file extension is hidden by default.
	///   - allowedFileExtensions: A list of file extensions allowed, all are allowed if `nil`.
	///   - handler: Receives the `URL` the user selected, otherwise `nil` if the user cancelled the panel.
	public static func savePanelModal(for window: NSWindow, message: String? = nil, nameFieldLabel: String? = nil, nameField: String?, currentDirectory: URL? = nil, isExtensionHidden: Bool, allowedFileExtensions: [String]?, completionHandler handler: @escaping SaveCompletionHandler) {
		let panel = createSavePanel(message: message, nameFieldLabel: nameFieldLabel, nameField: nameField, currentDirectory: currentDirectory, isExtensionHidden: isExtensionHidden, allowedFileExtensions: allowedFileExtensions)
		
		panel.beginSheetModal(for: window, completionHandler: { response in
			panel.orderOut(nil)
			if response == .OK, let url = panel.url {
				handler(url)
			} else {
				handler(nil)
			}
		})

	}
	
}
