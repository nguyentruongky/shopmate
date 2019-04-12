//
//  CardCell.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
class CardCell: knListCell<Card> {
    override func setData(data: Card) {
        nameLabel.text = data.userName
        numberLabel.text = data.number
        iconImageView.backgroundColor = .green
    }
    let iconImageView = UIMaker.makeImageView()
    let nameLabel = UIMaker.makeLabel(font: UIFont.main(size: 14),
                                      color: .darkGray)
    let numberLabel = UIMaker.makeLabel(font: UIFont.main(.semibold, size: 14),
                                      color: .darkGray)

    override func setupView() {
        let stackView = UIMaker.makeStackView(axis: .vertical,
                                              distributon: .fill,
                                              alignment: .leading,
                                              space: 4)
        stackView.addViews(numberLabel, nameLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubviews(views: iconImageView, stackView)
        iconImageView.leftSuperView(space: gap)
        iconImageView.centerYSuperView()
        iconImageView.square(edge: 36)

        stackView.leftHorizontalSpacing(toView: iconImageView, space: -gap)
        stackView.centerYSuperView()

//        numberLabel.leftHorizontalSpacing(toView: iconImageView, space: -gap)
//        numberLabel.bottom(toAnchor: centerYAnchor, space: -3)
//
//        nameLabel.verticalSpacing(toView: numberLabel, space: 6)
//        nameLabel.left(toView: numberLabel)
    }
}
