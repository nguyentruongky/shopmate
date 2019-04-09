//
//  knUIButton.swift
//  kynguyenCodebase
//
//  Created by Ky Nguyen on 12/9/16.
//  Copyright © 2016 kynguyen. All rights reserved.
//

import UIKit

extension UIButton {
    func setTitle(_ title: String) {
        setTitle(title, for: .normal)
    }
    
    func setTitleColor(_ color: UIColor) {
        setTitleColor(color, for: .normal)
    }
    
    func addTarget(_ target: Any?, action: Selector) {
        addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setBackground(color: UIColor, forState: UIControl.State) {
        let colorImage = imageFromColor(color: color)
        setBackgroundImage(colorImage, for: forState)
    }

    private func imageFromColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    func animate(atPosition position: CGPoint) {
        clipsToBounds = true
        CATransaction.begin()
        
        let startPath = UIBezierPath(arcCenter: position, radius: 1, startAngle: 0, endAngle: CGFloat(Double.pi) * 2, clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = startPath.cgPath
        shapeLayer.fillColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.addSublayer(shapeLayer)
        
        CATransaction.setCompletionBlock({ [weak self] in
            shapeLayer.removeFromSuperlayer()
            self?.clipsToBounds = false
        })
        
        let endPath = UIBezierPath(arcCenter: position, radius: frame.size.width * 2, startAngle: 0, endAngle: CGFloat(Double.pi) * 2, clockwise: true)
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = endPath.cgPath
        animation.duration = 0.4
        animation.isRemovedOnCompletion = true
        shapeLayer.add(animation, forKey: "scale")
        
        CATransaction.commit()
    }

    func setProcess(visible: Bool,
                             style: UIActivityIndicatorView.Style = .white) {
        if visible {
            titleLabel?.layer.opacity = 0
            isEnabled = false
            let indicator = UIActivityIndicatorView(style: style)
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.tag = 10001
            indicator.startAnimating()
            addSubview(indicator)
            indicator.center(toView: self)
        } else {
            titleLabel?.layer.opacity = 1
            isEnabled = true
            let indicator = viewWithTag(10001)
            indicator?.removeFromSuperview()
        }
    }
}
