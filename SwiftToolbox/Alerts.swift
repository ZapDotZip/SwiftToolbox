//
//  Alerts.swift
//  SwiftToolbox
//

import AppKit

public class Alerts {
	
	/// Creates and runs an NSAlert
	/// - Parameters:
	///   - title: The title of the alert
	///   - message: The message of the alert
	///   - style: The alert style
	///   - buttons: The buttons to add
	/// - Returns: The alert response.
	@discardableResult
	public static func Alert(title: String, message: String, style: NSAlert.Style, buttons: [String]) -> NSApplication.ModalResponse {
		let alert = NSAlert()
		alert.messageText = title
		alert.informativeText = message
		alert.alertStyle = .critical
		for btn in buttons {
			alert.addButton(withTitle: btn)
		}
		return alert.runModal()
	}
	
	/// Creates and runs an alert for a destructive action
	/// - Parameters:
	///   - title: The title of the alert
	///   - message: The message of the alert
	///   - style: The alert style
	/// - Returns: Whether or not the user has agreed to the destructive action.
	@discardableResult
	public static func DestructiveAlert(title: String, message: String, style: NSAlert.Style, destructiveButtonText: String) -> Bool {
		let alert = NSAlert()
		alert.messageText = title
		alert.informativeText = message
		alert.alertStyle = .critical
		alert.addButton(withTitle: destructiveButtonText)
		alert.addButton(withTitle: "Cancel")
		if #available(macOS 11.0, *) {
			alert.buttons[0].hasDestructiveAction = true
			alert.buttons[0].bezelColor = .red
		}
		return alert.runModal() == .alertFirstButtonReturn
	}
	
}
