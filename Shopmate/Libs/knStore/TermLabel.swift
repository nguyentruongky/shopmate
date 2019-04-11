//
//  TermLabel.swift
//  invo-ios
//
//  Created by Ky Nguyen Coinhako on 7/23/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit

class knTermLabel: UILabel {
    private var fullText = ""
    private var boldTexts = [String]()
    private var actions = [() -> Void]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        numberOfLines = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTermTapped))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
        textAlignment = .left
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func formatText(fullText: String, boldTexts: [String],
                    boldFont: UIFont, boldColor: UIColor,
                    font: UIFont, color: UIColor,
                    alignment: NSTextAlignment,
                    lineSpacing: CGFloat = 5,
                    actions: [() -> Void]) {
        self.fullText = fullText
        self.boldTexts = boldTexts
        self.actions = actions
        let formattedText = String.format(strings: boldTexts,
                                          boldFont: boldFont,
                                          boldColor: boldColor,
                                          inString: fullText,
                                          font: font,
                                          color: color,
                                          lineSpacing: lineSpacing,
                                          alignment: alignment)
        attributedText = formattedText
    }
    
    @objc func handleTermTapped(gesture: UITapGestureRecognizer) {
        let termString = fullText as NSString
        
        let tapLocation = gesture.location(in: self)
        let index = indexOfAttributedTextCharacterAtPoint(point: tapLocation)
        
        for i in 0 ..< boldTexts.count {
            let range = termString.range(of: boldTexts[i])
            if checkRange(range, contain: index) == true {
                if (i < actions.count) {
                    actions[i]()
                }
                return
            }
        }
    }
    
    func checkRange(_ range: NSRange, contain index: Int) -> Bool {
        return index > range.location && index < range.location + range.length
    }
}


extension UILabel {
    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        assert(self.attributedText != nil, "This method is developed for attributed string")
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        
        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }
}
