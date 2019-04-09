//
//  NavigationExtension.swift
//  knStore
//
//  Created by Ky Nguyen Coinhako on 12/11/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import UIKit

extension UINavigationBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 70)
    }
}

extension UINavigationController {
    func hideBar(_ hide: Bool) {
        UIView.animate(withDuration: 0.35,
                       animations: { [weak self] in
                        self?.isNavigationBarHidden = hide })
    }
    
    func hideBarWhenScrolling(inScrollView scrollView: UIScrollView) {
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if actualPosition.y > 0 {
            setNavigationBarHidden(false, animated: true)
            return
        }
        setNavigationBarHidden(scrollView.contentOffset.y > 24, animated: true)
    }
    
    func changeTitleFont(_ font: UIFont, color: UIColor = .white) {
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font: font]
    }
    
    func removeLine(color: UIColor = .white, titleColor: UIColor = .black) {
        navigationBar.setBackgroundImage(UIImage.createImage(from: color), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = titleColor
    }
    
    func fillNavigationBar(withColors colors: [CGColor],
                           startPoint: CGPoint = CGPoint(x: 0, y: 0),
                           endPoint: CGPoint = CGPoint(x: 1, y: 1)) {
        let gradientLayer = CAGradientLayer()
        var updatedFrame = navigationBar.bounds
        updatedFrame.size.height += 20
        gradientLayer.frame = updatedFrame
        gradientLayer.colors = colors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        let image = gradientLayer.renderImage()
        navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
    }
}

/// Extend navigation bar height
extension UINavigationController {
//    var statusBarView: UIView? {
//        return view.viewWithTag(999)
//    }
//    
//    open override func viewDidLoad() {
//        super.viewDidLoad()
//        if hasNotch() == false {
//            let statusBarView = UIView(frame: CGRect(x: 0, y: -38, width: screenWidth, height: 20))
//            statusBarView.tag = 999
//            statusBarView.backgroundColor = .white
//            navigationBar.addSubview(statusBarView)
//        }
//    }
//    
//    override open func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        if hasNotch() == false {
//            let height = CGFloat(48)
//            navigationBar.frame = CGRect(x: 0, y: 38, width: screenWidth, height: height)
//        }
//    }
}


public extension UINavigationController {
    
    /**
     Pop current view controller to previous view controller.
     
     - parameter type:     transition animation type.
     - parameter duration: transition animation duration.
     */
    func kn_dismiss() {
        guard viewControllers.count >= 2 else { return }
        guard let previousView = viewControllers[0].view, let thisView = viewControllers[1].view, let screenshot = thisView.takeScreenshot() else { return }
        
        let imageView = UIMaker.makeImageView(image: screenshot, contentMode: .scaleAspectFill)
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.frame = UIScreen.main.bounds
        
        func animate() {
            imageView.frame.origin.y = screenHeight
        }
        
        func complete(_ isCompleted: Bool) {
            imageView.removeFromSuperview()
        }
        
        previousView.addSubviews(views: imageView)
        popViewController(animated: false)
        UIView.animate(withDuration: 0.35, animations: animate, completion: complete)
    }
    
    /**
     Push a new view controller on the view controllers's stack.
     
     - parameter vc:       view controller to push.
     - parameter type:     transition animation type.
     - parameter duration: transition animation duration.
     */
    func kn_present(controller vc: UIViewController) {
        guard let newView = vc.view, let thisView = viewControllers.first?.view else { return }
        
        func animate() {
            newView.frame.origin.y = 0
        }
        
        func complete(_ isCompleted: Bool) {
            pushViewController(vc, animated: false)
            newView.removeFromSuperview()
        }
        
        newView.frame.origin.y = screenHeight
        thisView.addSubview(newView)
        
        UIView.animate(withDuration: 0.35, animations: animate, completion: complete)
    }
    
    private func addTransition(transitionType type: String, duration: CFTimeInterval = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype(rawValue: type)
        view.layer.add(transition, forKey: nil)
    }
    
}

extension UIView {
    
    func takeScreenshot() -> UIImage? {
        
        // Begin context
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
