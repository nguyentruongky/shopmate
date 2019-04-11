//
//  SelectSizeView.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/10/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

class SizeCell: knGridCell<String> {
    override func setData(data: String) {
        self.data = data
        sizeLabel.text = data
    }

    let colorView = UIMaker.makeView(background: .white)
    let sizeLabel = UIMaker.makeLabel(font: UIFont.main(size: 11),
                                      color: .c19, alignment: .center)
    override func setupView() {
        colorView.setBorder(width: 0.5, color: UIColor.c151)
        colorView.square(edge: 32)
        colorView.setCorner(radius: 16)
        addSubviews(views: colorView, sizeLabel)
        colorView.fill(toView: self)

        sizeLabel.center(toView: self)
    }

    func selectThis(_ value: Bool) {
        colorView.backgroundColor = value ? .black : .white
        sizeLabel.textColor = value ? .white : .black
    }
}

class SelectSizeView: knGridView<SizeCell, String> {
    override func setupView() {
        itemSize = CGSize(width: 32, height: 32)
        lineSpacing = 8

        super.setupView()
        layout?.scrollDirection = .horizontal

        addSubviews(views: collectionView)
        collectionView.fillSuperView()
    }

    var selectedIndex: IndexPath?
    override func getCell(atIndex indexPath: IndexPath) -> SizeCell {
        let cell = super.getCell(atIndex: indexPath)
        cell.selectThis(selectedIndex == indexPath)
        return cell
    }
    override func didSelectItem(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SizeCell else { return }
        if selectedIndex == nil {
            cell.selectThis(true)
            selectedIndex = indexPath
            return
        }

        if let oldCell = collectionView.cellForItem(at: selectedIndex!) as? SizeCell {
            oldCell.selectThis(false)
        } else {
            collectionView.reloadItems(at: [selectedIndex!])
        }

        cell.selectThis(true)
        selectedIndex = indexPath
    }
}


