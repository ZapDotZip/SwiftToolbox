//
//  Alerts.swift
//  SwiftToolbox
//

import AppKit

public class STBAlerts {
	
	/// Creates and runs an NSAlert
	/// - Parameters:
	///   - title: The title of the alert
	///   - message: The message of the alert
	///   - style: The alert style
	///   - buttons: The buttons to add
	/// - Returns: The alert response.
	@discardableResult
	public static func alert(title: String, message: String, style: NSAlert.Style, buttons: [String]? = nil) -> NSApplication.ModalResponse {
		let alert = NSAlert()
		alert.messageText = title
		alert.informativeText = message
		alert.alertStyle = .critical
		if let buttons {
			for btn in buttons {
				alert.addButton(withTitle: btn)
			}
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
	public static func destructiveAlert(title: String, message: String, style: NSAlert.Style, destructiveButtonText: String) -> Bool {
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
	
	
	/// Creates an `NSPopover` with a single label relative to a view. Does not display if the view does not have a window.
	/// - Parameters:
	///   - text: The text to display in the label
	///   - view: The view to display the popover from.
	///   - preferredEdge: The edge of positioningView the popover should prefer to be anchored to.
	/// - Returns: The NSPopover, for reuse.
	@available(macOS 10.12, *)
	public static func popoverTextAlert(text: String, relativeTo view: NSView, preferredEdge: NSRectEdge) -> NSPopover {
		let label = NSTextField(wrappingLabelWithString: text)
		label.alignment = .left
		label.sizeToFit()
		label.translatesAutoresizingMaskIntoConstraints = false
		let contentViewController = NSViewController()
		let viewFrame = NSRect(x: 0, y: 0, width: label.frame.width + 16, height: label.frame.height + 16)
		contentViewController.view = NSView(frame: viewFrame)
		contentViewController.view.wantsLayer = true
		contentViewController.view.addSubview(label)
		let popover = NSPopover()
		popover.contentViewController = contentViewController
		popover.behavior = .semitransient
		NSLayoutConstraint.activate([
			label.topAnchor.constraint(equalTo: contentViewController.view.topAnchor, constant: 8),
			label.trailingAnchor.constraint(equalTo: contentViewController.view.trailingAnchor, constant: -8),
			label.bottomAnchor.constraint(equalTo: contentViewController.view.bottomAnchor, constant: -8),
			label.leadingAnchor.constraint(equalTo: contentViewController.view.leadingAnchor, constant: 8)
		])
		if view.window != nil {
			popover.show(relativeTo: view.bounds, of: view, preferredEdge: preferredEdge)
		}
		return popover
	}
	
}
