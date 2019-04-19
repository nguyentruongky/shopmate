//
//  CategoryView.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/19/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

class CategoryCell: knGridCell<Category> {
    override func setData(data: Category) {
        self.data = data
        nameLabel.text = data.name
        containerView.backgroundColor = .white
    }

    let nameLabel = UIMaker.makeLabel(font: .main(.medium, size: 14),
                                      color: .black,
                                      alignment: .center)
    let containerView = UIMaker.makeView()
    override func setupView() {
        containerView.addSubviews(views: nameLabel)
        nameLabel.horizontalSuperview()
        nameLabel.centerYSuperView()

        addSubviews(views: containerView)
        containerView.fillSuperView()
        layoutIfNeeded()
        containerView.setCorner(radius: frame.height / 2)
        containerView.setBorder(width: 1, color: .black)
    }

    func selectThis(_ value: Bool) {
        containerView.backgroundColor = value ? .black : .white
        nameLabel.textColor = value ? .white : .black
    }
    override func prepareForReuse() {
        selectThis(false)
    }
}

class CategoryView: knGridView<CategoryCell, Category> {
    weak var productsController: ProductsController?
    override func setupView() {
        itemSize = CGSize(width: 100, height: 0)
        lineSpacing = 8
        contentInset = UIEdgeInsets(left: gap, right: gap)

        super.setupView()
        layout?.scrollDirection = .horizontal

        addSubviews(views: collectionView)
        collectionView.fillSuperView()
    }

    var selectedIndex: IndexPath?
    override func getCell(atIndex indexPath: IndexPath) -> CategoryCell {
        let cell = super.getCell(atIndex: indexPath)
        cell.selectThis(selectedIndex == indexPath)
        return cell
    }
    override func didSelectItem(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell else { return }
        productsController?.didSelectCategory(category: datasource[indexPath.item])
        if selectedIndex == nil {
            cell.selectThis(true)
            selectedIndex = indexPath
            return
        }

        if let oldCell = collectionView.cellForItem(at: selectedIndex!) as? CategoryCell {
            oldCell.selectThis(false)
        } else {
            collectionView.reloadItems(at: [selectedIndex!])
        }

        cell.selectThis(true)
        selectedIndex = indexPath
    }
}


