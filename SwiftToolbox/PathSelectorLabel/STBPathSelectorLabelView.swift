//
//  STBPathSelectorLabelView.swift
//  SwiftToolbox
//

import Cocoa

public class STBPathSelectorLabelView: NSView {
	@IBOutlet private var mainView: NSView!
	@IBOutlet public var controller: STBPathSelectorLabelViewController!
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		let nib = NSNib(nibNamed: "PathSelectorLabelView", bundle: Bundle(for: STBPathSelectorLabelView.self))
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
