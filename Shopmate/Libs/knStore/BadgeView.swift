//
//  BadgeView.swift
//  knStore
//
//  Created by Ky Nguyen on 4/19/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
extension UIView {
    static let badgeTag = 91109823
    func addBadge(amount: Int, topSpace: CGFloat = 0, rightSpace: CGFloat = 0) {
        var badgeView = viewWithTag(UIView.badgeTag) as? BadgeView
        if badgeView == nil {
            badgeView = BadgeView()
            addSubview(badgeView!)
            badgeView!.topRight(toView: self, top: topSpace, right: rightSpace)
        }

        badgeView?.setBadge(value: amount)
    }

    func getBadgeCount() -> Int {
        return (viewWithTag(UIView.badgeTag) as? BadgeView)?.value ?? 0
    }
}

class BadgeView: UIView {
    let numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.main(size: 11)
        return label
    }()
    var value = 0

    func setBadge(value: Int) {
        self.value = value
        isHidden = value <= 0
        numberLabel.text = String(value)
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.5
        animation.toValue = 1.0
        animation.duration = 0.2
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 1.3, 1, 1)

        layer.add(animation, forKey: "bounceAnimation")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        tag = UIView.badgeTag
        backgroundColor = UIColor.red
        addSubview(numberLabel)
        numberLabel.center(toView: self)

        let badgeHeight: CGFloat = 20
        square(edge: badgeHeight)
        layer.cornerRadius = badgeHeight / 2
        clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
}

