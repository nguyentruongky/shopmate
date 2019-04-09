//
//  StringExtension.swift
//  kLibrary
//
//  Created by Ky Nguyen on 1/25/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit

extension String {
    static func format(strings: [String],
                       boldFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                       boldColor: UIColor = UIColor.blue,
                       inString string: String,
                       font: UIFont = UIFont.systemFont(ofSize: 14),
                       color: UIColor = UIColor.black,
                       lineSpacing: CGFloat = 7,
                       alignment: NSTextAlignment = .left) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.maximumLineHeight = 40
        paragraphStyle.alignment = alignment
        
        let attributedString =
            NSMutableAttributedString(string: string,
                                      attributes: [
                                        NSAttributedString.Key.font: font,
                                        NSAttributedString.Key.foregroundColor: color,
                                        NSAttributedString.Key.paragraphStyle: paragraphStyle])
        let boldFontAttribute = [NSAttributedString.Key.font: boldFont,
                                 NSAttributedString.Key.foregroundColor: boldColor]
        for bold in strings {
            attributedString.addAttributes(boldFontAttribute, range: (string as NSString).range(of: bold))
        }
        return attributedString
    }

    func formatParagraph(alignment: NSTextAlignment = NSTextAlignment.left,
                         spacing: CGFloat = 7) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.alignment = alignment
        paragraphStyle.maximumLineHeight = 40

        let attributed = [NSAttributedString.Key.paragraphStyle:paragraphStyle]
        return NSAttributedString(string: self, attributes:attributed)
    }
    
    func strikethroughText() -> NSMutableAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    func estimateFrameForText(withFont font: UIFont, estimateSize: CGSize) -> CGRect {
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: self).boundingRect(with: estimateSize, options: options, attributes: [NSAttributedString.Key.font: font], context: nil)
    }
}

extension String {
    func formatThousandSeparator(_ separatorCharacter: String = " ") -> String {
        guard let numberFromString = Double(self) else { return self }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = separatorCharacter
        formatter.roundingMode = .down
        formatter.maximumFractionDigits = 5
        var formattedString = formatter.string(from: NSNumber(value: numberFromString as Double))
        formattedString = formattedString != nil ? formattedString! : self
        
        if substring(from: 1) == "." {
            formattedString! += "."
        }
        
        return formattedString!
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func splitString(_ separator: String) -> [String] {   
        return components(separatedBy: separator)
    }
    
    func substring(from: Int, to: Int) -> String {
        let start = index(startIndex, offsetBy: from)
        let end = index(endIndex, offsetBy: -(count - to) + 1)
        let range = start ..< end
        return String(self[range])
    }

    func substring(from: Int) -> String {
        return String(suffix(from))
    }

    func substring(to: Int) -> String {
        return String(prefix(to))
    }
    
    func remove(_ string: String) -> String {
        return replacingOccurrences(of: string, with: "")
    }
    
    func replace(_ string: String, with newString: String) -> String {
        return replacingOccurrences(of: string, with: newString)
    }
    
    var wordCount: Int {
        let regex = try? NSRegularExpression(pattern: "\\w+")
        return regex?.numberOfMatches(in: self, range: NSRange(location: 0, length: self.utf16.count)) ?? 0
    }
    
    func replacingOccurrences(of search: String, with replacement: String, count maxReplacements: Int) -> String {
        var count = 0
        var returnValue = self
        
        while let range = returnValue.range(of: search) {
            returnValue = returnValue.replacingCharacters(in: range, with: replacement)
            count += 1
            
            if count == maxReplacements {
                return returnValue
            }
        }
        
        return returnValue
    }
}

public extension String {
    func contains(_ substring: String) -> Bool {
        return range(of: substring) != nil
    }
    
    func collapseWhitespace() -> String {
        let parts = components(separatedBy: CharacterSet.whitespacesAndNewlines).filter { !$0.isEmpty }
        return parts.joined(separator: " ")
    }
    
    func clean(_ with: String, allOf: String...) -> String {
        var string = self
        for target in allOf {
            string = string.replacingOccurrences(of: target, with: with)
        }
        return string
    }
    
    func count(_ substring: String) -> Int {
        return components(separatedBy: substring).count - 1
    }
    
    func endsWith(_ suffix: String) -> Bool {
        return hasSuffix(suffix)
    }

    func indexOf(_ substring: String) -> Int? {
        guard let range = range(of: substring) else { return nil }
        return distance(from: startIndex, to: range.lowerBound)
    }
    
    func lastIndexOf(_ target: String) -> Int? {
        guard let range = range(of: target, options: .backwards) else { return nil }
        return distance(from: startIndex, to: range.lowerBound)
    }
    
    func isAlpha() -> Bool {
        for chr in self {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }
    
    func isAlphaNumeric() -> Bool {
        let alphaNumeric = CharacterSet.alphanumerics
        return components(separatedBy: alphaNumeric).joined(separator: "").count == 0
    }
    
    func isNumeric() -> Bool {
        return NumberFormatter().number(from: self) != nil
    }
    
    static func random(_ length: Int = 5) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0 ..< length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        
        return randomString
    }
}
