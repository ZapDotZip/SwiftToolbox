//
//  STBPathListViewController.swift
//  SwiftToolbox
//

import Cocoa

/// A single-column table designed for users to interact with a list of paths. Users can drag and drop, delete, paste a list of paths, or type their own path in.
///
/// This class specifically should only be used to set a custom view's class in the interface builder. Use ``STBPathListController`` to interact with the list.
public class STBPathListView: NSView {
	@IBOutlet private var mainView: NSView!
	@IBOutlet public var controller: STBPathListController!
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		let nib = NSNib(nibNamed: "STBPathList", bundle: Bundle(for: STBPathListView.self))
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
