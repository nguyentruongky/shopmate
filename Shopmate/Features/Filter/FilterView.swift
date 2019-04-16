//
//  FilterView.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/16/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit
import RangeSeekSlider

class FilterView: knPopup {
    let slider = RangeSeekSlider()
    let applyButton = UIMaker.makeMainButton(title: "Apply")
    let clearButton = UIMaker.makeButton(title: "Clear filter",
                                         titleColor: .black,
                                         font: UIFont.main(.medium, size: 14))

    override func setupView() {
        let numberFont = UIFont.main(.medium, size: 15)
        slider.minLabelFont = numberFont
        slider.maxLabelFont = numberFont
        slider.translatesAutoresizingMaskIntoConstraints = false
        let label = UIMaker.makeLabel(text: "Price",
                                      font: UIFont.main(.semibold, size: 15),
                                      color: .black)
        let padding = gap * 2
        container.addSubviews(views: label, slider, applyButton, clearButton)
        label.topLeft(toView: container, top: padding, left: padding)

        slider.verticalSpacing(toView: label, space: padding)
        slider.horizontalSuperview(space: padding)

        applyButton.horizontalSuperview(space: padding)
        applyButton.verticalSpacing(toView: slider, space: padding)
        applyButton.bottomSuperView(space: -padding)

        clearButton.centerY(toView: label)
        clearButton.rightSuperView(space: -padding)
    }
}
