//
//  knConstraints.swift
//  knConstraints
//
//  Created by Ky Nguyen on 4/12/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit

extension UIView {
    
    func addConstraint(attribute: NSLayoutConstraint.Attribute, equalTo view: UIView, toAttribute: NSLayoutConstraint.Attribute, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
        let myConstraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: view, attribute: toAttribute, multiplier: multiplier, constant: constant)
        return myConstraint
    }
    
    func addConstraints(withFormat format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        
        for i in 0 ..< views.count {
            let key = "v\(i)"
            views[i].translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = views[i]
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func addConstraints(withFormat format: String, arrayOf views: [UIView]) {
        var viewsDictionary = [String: UIView]()
        
        for i in 0 ..< views.count {
            let key = "v\(i)"
            views[i].translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = views[i]
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func removeAllConstraints() {
        removeConstraints(constraints)
    }
    
    func addSubviews(views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    func addFill(_ view: UIView) {
        addSubview(view)
        view.fill(toView: self)
    }
    
    @discardableResult
    public func left(toAnchor anchor: NSLayoutXAxisAnchor, space: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = leftAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    public func left(toView view: UIView, space: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = leftAnchor.constraint(equalTo: view.leftAnchor, constant: space)
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    public func right(toAnchor anchor: NSLayoutXAxisAnchor, space: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = rightAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    public func right(toView view: UIView, space: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = rightAnchor.constraint(equalTo: view.rightAnchor, constant: space)
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    public func top(toAnchor anchor: NSLayoutYAxisAnchor, space: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = topAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    public func top(toView view: UIView, space: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = topAnchor.constraint(equalTo: view.topAnchor, constant: space)
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    public func topLeft(toView view: UIView, top: CGFloat = 0, left: CGFloat = 0, isActive: Bool = true)
        -> (top: NSLayoutConstraint, left: NSLayoutConstraint) {
            let topConstraint = self.top(toView: view, space: top)
            let leftConstraint = self.left(toView: view, space: left)
            return (topConstraint, leftConstraint)
    }
    
    @discardableResult
    public func topRight(toView view: UIView, top: CGFloat = 0, right: CGFloat = 0)
        -> (top: NSLayoutConstraint, right: NSLayoutConstraint){
            let topConstraint = self.top(toView: view, space: top)
            let rightConstraint = self.right(toView: view, space: right)
            return (topConstraint, rightConstraint)
    }
    
    @discardableResult
    public func bottomRight(toView view: UIView, bottom: CGFloat = 0, right: CGFloat = 0)
        -> (bottom: NSLayoutConstraint, right: NSLayoutConstraint){
            let bottomConstraint = self.bottom(toView: view, space: bottom)
            let rightConstraint = self.right(toView: view, space: right)
            return (bottomConstraint, rightConstraint)
    }
    
    @discardableResult
    public func bottomLeft(toView view: UIView, bottom: CGFloat = 0, left: CGFloat = 0)
        -> (bottom: NSLayoutConstraint, left: NSLayoutConstraint) {
            let bottomConstraint = self.bottom(toView: view, space: bottom)
            let leftConstraint = self.left(toView: view, space: left)
            return (bottomConstraint, leftConstraint)
    }
    
    @discardableResult
    public func bottom(toAnchor anchor: NSLayoutYAxisAnchor, space: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = bottomAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    public func bottom(toView view: UIView, space: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: space)
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    public func verticalSpacing(toView view: UIView, space: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = topAnchor.constraint(equalTo: view.bottomAnchor, constant: space)
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    public func verticalSpacingDown(toView view: UIView, space: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = bottomAnchor.constraint(equalTo: view.topAnchor, constant: space)
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    public func horizontalSpacing(toView view: UIView, space: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = rightAnchor.constraint(equalTo: view.leftAnchor, constant: -space)
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    public func leftHorizontalSpacing(toView view: UIView, space: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = leftAnchor.constraint(equalTo: view.rightAnchor, constant: -space)
        constraint.isActive = isActive
        return constraint
    }
    
    
    
    public func size(_ size: CGSize) {
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
    
    public func size(toView view: UIView, greater: CGFloat = 0) {
        widthAnchor.constraint(equalTo: view.widthAnchor, constant: greater).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor, constant: greater).isActive = true
    }
    
    public func square(edge: CGFloat) {
        size(CGSize(width: edge, height: edge))
    }
    
    public func square() {
        widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1, constant: 0).isActive = true
    }
    
    @discardableResult
    public func width(_ width: CGFloat, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalToConstant: width)
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    public func width(toDimension dimension: NSLayoutDimension, multiplier: CGFloat = 1, greater: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalTo: dimension, multiplier: multiplier, constant: greater)
        constraint.isActive = isActive
        return constraint
    }
    
    
    @discardableResult
    public func width(toView view: UIView, multiplier: CGFloat = 1, greater: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier, constant: greater)
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    public func height(_ height: CGFloat, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalToConstant: height)
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    public func height(toDimension dimension: NSLayoutDimension, multiplier: CGFloat = 1, greater: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalTo: dimension, multiplier: multiplier, constant: greater)
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    public func height(toView view: UIView, multiplier: CGFloat = 1, greater: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier, constant: greater)
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    public func centerX(toView view: UIView, space: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: space)
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    public func centerX(toAnchor anchor: NSLayoutXAxisAnchor,
                        space: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = centerXAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = isActive
        return constraint
    }
    
    public func center(toView view: UIView, spaceX: CGFloat = 0,
                       spaceY: CGFloat = 0){
        centerX(toView: view, space: spaceX)
        centerY(toView: view, space: spaceY)
    }
    
    @discardableResult
    public func centerY(toView view: UIView, space: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: space)
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    public func centerY(toAnchor anchor: NSLayoutYAxisAnchor, space: CGFloat = 0, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = centerYAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = isActive
        return constraint
    }
    
    @discardableResult
    public func horizontal(toView view: UIView, space: CGFloat = 0, isActive: Bool = true) ->
        (left: NSLayoutConstraint, right: NSLayoutConstraint) {
            let left = leftAnchor.constraint(equalTo: view.leftAnchor, constant: space)
            left.priority = UILayoutPriority(rawValue: 999)
            left.isActive = isActive
            let right = rightAnchor.constraint(equalTo: view.rightAnchor, constant: -space)
            right.isActive = isActive
            return (left, right)
    }
    
    @discardableResult
    public func horizontal(toView view: UIView, leftPadding: CGFloat, rightPadding: CGFloat, isActive: Bool = true)
        -> (left: NSLayoutConstraint, right: NSLayoutConstraint) {
            let left = leftAnchor.constraint(equalTo: view.leftAnchor, constant: leftPadding)
            left.isActive = isActive
            let right = rightAnchor.constraint(equalTo: view.rightAnchor, constant: rightPadding)
            right.isActive = isActive
            return (left, right)
    }
    
    @discardableResult
    public func vertical(toView view: UIView, space: CGFloat = 0, isActive: Bool = true)
        -> (top: NSLayoutConstraint, bottom: NSLayoutConstraint) {
            let top = topAnchor.constraint(equalTo: view.topAnchor, constant: space)
            let bottom = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -space)
            top.isActive = isActive
            bottom.isActive = isActive
            return (top, bottom)
    }
    
    @discardableResult
    public func vertical(toView view: UIView, topPadding: CGFloat, bottomPadding: CGFloat, isActive: Bool = true)
        -> (top: NSLayoutConstraint, bottom: NSLayoutConstraint) {
            let top = topAnchor.constraint(equalTo: view.topAnchor, constant: topPadding)
            let bottom = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomPadding)
            top.isActive = isActive
            bottom.isActive = isActive
            return (top, bottom)
    }
    
    @discardableResult
    public func fill(toView view: UIView, space: UIEdgeInsets = .zero, isActive: Bool = true)
        -> (left: NSLayoutConstraint, top: NSLayoutConstraint,
        right: NSLayoutConstraint, bottom: NSLayoutConstraint) {
            let leftCons = left(toView: view, space: space.left, isActive: isActive)
            let rightCons = right(toView: view, space: -space.right, isActive: isActive)
            let topCons = top(toView: view, space: space.top, isActive: isActive)
            let bottomCons = bottom(toView: view, space: -space.bottom, isActive: isActive)
            return (leftCons, topCons, rightCons, bottomCons)
    }
}

extension UIEdgeInsets {
    init(space: CGFloat) {
        self.init(top: space, left: space, bottom: space, right: space)
    }
    
    init(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        self.init()
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }
}



extension CALayer {
    func renderImage() -> UIImage? {
        UIGraphicsBeginImageContext(bounds.size)
        render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
