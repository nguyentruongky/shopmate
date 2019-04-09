//
//  T4TextViewPlaceHolder.swift
//  Voice
//
//  Created by SB 3 on 9/25/15.
//  Copyright © 2015 Snapbuck. All rights reserved.
//

import UIKit


class KMPlaceholderTextView: UITextView {
    
    struct Constants {
        static let defaultiOSPlaceholderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0980392, alpha: 0.22)
    }
    
    @IBInspectable internal var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    @IBInspectable internal var placeholderColor: UIColor = KMPlaceholderTextView.Constants.defaultiOSPlaceholderColor {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    internal let placeholderLabel: UILabel = UILabel()
    
    override internal var font: UIFont! {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    override internal var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    override internal var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    override internal var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
    override internal var textContainerInset: UIEdgeInsets {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }
    
    var placeholderLabelConstraints = [NSLayoutConstraint]()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(textDidChange),
            name: UITextView.textDidChangeNotification,
            object: nil)
        
        placeholderLabel.font = font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.text = placeholder
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        
        updateConstraintsForPlaceholderLabel()
        
    }
    
    func updateConstraintsForPlaceholderLabel() {
        var newConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(textContainerInset.left + textContainer.lineFragmentPadding))-[placeholder]-(\(textContainerInset.right + textContainer.lineFragmentPadding))-|",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        newConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(textContainerInset.top))-[placeholder]-(>=\(textContainerInset.bottom))-|",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        removeConstraints(placeholderLabelConstraints)
        addConstraints(newConstraints)
        placeholderLabelConstraints = newConstraints
    }
    
    @objc func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    override internal func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2.0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
            name: UITextView.textDidChangeNotification,
            object: nil)
    }
    
    
}
