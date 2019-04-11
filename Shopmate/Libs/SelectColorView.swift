//
//  SelectColorView.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/10/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

class ColorCell: knGridCell<String> {
    override func setData(data: String) {
        self.data = data
        colorView.backgroundColor = UIColor(hex: data)
    }
    let colorView = UIMaker.makeView()
    let checkImageView = UIMaker.makeImageView(image: UIImage(named: "check"))
    override func setupView() {
        checkImageView.changeColor(to: .white)
        colorView.square(edge: 32)
        colorView.setCorner(radius: 16)
        addSubviews(views: colorView, checkImageView)
        colorView.fill(toView: self)

        checkImageView.center(toView: colorView)
        checkImageView.square(edge: 16)
        checkImageView.isHidden = true
    }

    func selectThis(_ value: Bool) {
        checkImageView.isHidden = !value
    }
    override func prepareForReuse() {
        selectThis(false)
    }
}

class SelectColorView: knGridView<ColorCell, String> {
    override func setupView() {
        itemSize = CGSize(width: 32, height: 32)
        lineSpacing = 8

        super.setupView()
        layout?.scrollDirection = .horizontal

        addSubviews(views: collectionView)
        collectionView.fillSuperView()
        collectionView.contentInset = UIEdgeInsets(left: -40)
    }

    var selectedIndex: IndexPath?
    override func getCell(atIndex indexPath: IndexPath) -> ColorCell {
        let cell = super.getCell(atIndex: indexPath)
        cell.selectThis(selectedIndex == indexPath)
        return cell
    }
    override func didSelectItem(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCell else { return }
        if selectedIndex == nil {
            cell.selectThis(true)
            selectedIndex = indexPath
            return
        }

        if let oldCell = collectionView.cellForItem(at: selectedIndex!) as? ColorCell {
            oldCell.selectThis(false)
        } else {
            collectionView.reloadItems(at: [selectedIndex!])
        }

        cell.selectThis(true)
        selectedIndex = indexPath
    }
}

