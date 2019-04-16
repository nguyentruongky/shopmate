//
//  UIViewControllerExtension.swift
//  knStore
//
//  Created by Ky Nguyen Coinhako on 12/11/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import UIKit

private var scrollViewKey : UInt8 = 0

extension UIViewController {
    func setEnabled(_ enabled: Bool) {
        view.isUserInteractionEnabled = enabled
    }
    
    private func createFakeBackButton() -> [UIBarButtonItem] {
        let height: CGFloat = 36
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: height))
        let image = UIImage(named: "back_arrow")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 36, height: height)
        backView.addSubview(imageView)
        let content = UILabel()
        content.sizeToFit()
        content.frame.size = CGSize(width: content.frame.size.width, height: height)
        content.frame.origin = CGPoint(x: 30, y: 0)
        backView.addSubview(content)
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: height))
        button.addTarget(self, action: #selector(dismissBack), for: .touchUpInside)
        backView.addSubview(button)
        
        let barButton = UIBarButtonItem(customView: backView)
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -20
        
        return [negativeSpacer, barButton]
    }
    
    func addFakeBackButton() {
        navigationItem.leftBarButtonItems = createFakeBackButton()
    }
    
    @objc func dismissBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @discardableResult
    func addBackButton(tintColor: UIColor = .black) -> UIBarButtonItem {
        let backArrowImageView = UIImageView(image: UIImage(named: "back_arrow")?.changeColor())
        backArrowImageView.contentMode = .scaleAspectFit
        backArrowImageView.tintColor = tintColor
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 36))
        backButton.addSubview(backArrowImageView)
        backButton.addConstraints(withFormat: "H:|-(-4)-[v0]", views: backArrowImageView)
        backArrowImageView.vertical(toView: backButton)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        let backBarButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButton
        return backBarButton
    }
    
    @objc func back() {
        pop()
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    func present(_ controller: UIViewController) {
        present(controller, animated: true)
    }
    
    func push(_ controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func pop(to controller: UIViewController) {
        navigationController?.popToViewController(controller, animated: true)
    }
    
    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setNavBarTitle(text: String, font: UIFont = UIFont.main(.bold, size: 14),
                        color: UIColor = UIColor.white) {
        let navTitleLabel = UIMaker.makeLabel(text: text, font: font, color: color, alignment: .center)
        navTitleLabel.tag = 1001
        navigationItem.titleView = UIView()
        navigationItem.titleView?.addSubview(navTitleLabel)
        navTitleLabel.centerY(toView: navigationItem.titleView!)
        navTitleLabel.centerX(toView: navigationItem.titleView!)
    }
    
    func setNavBarColor(_ color: UIColor) {
        navigationController?.removeLine(color: color)
    }
    

    func hideNavBar(_ value: Bool) {
        navigationController?.hideBar(value)
    }

    func setControllers(_ ctrs: [UIViewController]) {
        navigationController?.setViewControllers(ctrs, animated: true)
    }

}





