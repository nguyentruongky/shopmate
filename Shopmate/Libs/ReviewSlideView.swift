//
//  ReviewSlideView.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/11/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

struct knReview {
    var name: String
    var date: String
    var value: Double
    var content: String

    init(name: String, date: String, value: Double, content: String) {
        self.name = name
        self.date = date
        self.value = value
        self.content = content
    }
}

class knReviewCell: knGridCell<knReview> {
    let nameLabel = UIMaker.makeLabel(font: UIFont.main(.semibold, size: 14),
                                      color: .c19)
    let dateLabel = UIMaker.makeLabel(font: UIFont.main(size: 13),
                                      color: .c151)
    let contentLabel = UIMaker.makeLabel(font: UIFont.main(size: 14),
                                         color: .black, numberOfLines: 3)
    let startView = UIMaker.makeView(background: .green)

    override func setData(data: knReview) {
        self.data = data
        nameLabel.text = data.name
        contentLabel.text = data.content
        dateLabel.text = data.date
    }

    override func setupView() {
        backgroundColor = .c_230_232_234
        setCorner(radius: 7)
        contentLabel.setLineSpacing()
        addSubviews(views: contentLabel, dateLabel, nameLabel, startView)
        contentLabel.horizontalSuperview(space: gap)
        contentLabel.topSuperView(space: gap)

        dateLabel.left(toView: contentLabel)

        startView.size(CGSize(width: 48, height: 24))
        startView.right(toView: self, space: -gap)
        startView.centerY(toView: dateLabel)

        nameLabel.horizontal(toView: contentLabel)
        nameLabel.verticalSpacing(toView: dateLabel, space: 4)
        nameLabel.bottomSuperView(space: -gap)
    }
}

class knReviewSlideView: knGridView<knReviewCell, knReview> {
    override func setupView() {
        itemSize = CGSize(width: screenWidth - 32, height: 0)
        lineSpacing = 8
        layout = FAPaginationLayout()
        super.setupView()
        collectionView.decelerationRate = .fast
        layout.scrollDirection = .horizontal

        addSubviews(views: collectionView)
        collectionView.fillSuperView()
    }
}

