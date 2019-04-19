//
//  MenuUI.swift
//  Shopmate
//
//  Created by Ky Nguyen on 4/12/19.
//  Copyright © 2019 Ky Nguyen. All rights reserved.
//

import UIKit

extension MenuController {
    class UI {
        func setupView() -> [knTableCell] {
            let spaceCell = knTableCell()
            spaceCell.backgroundColor = UIColor(r: 243, g: 245, b: 248)
            spaceCell.height(16)

            let profile = makeItem(icon: "profile", title: "Edit profile")
            profile.tag = Item.profile.rawValue

            let address = makeItem(icon: "address", title: "Address Book")
            address.tag = Item.addressBook.rawValue

            let payment = makeItem(icon: "payment_method", title: "Payment Methods")
            payment.tag = Item.paymentMethod.rawValue

            let logout = makeItem(icon: "logout", title: "Log Out")
            logout.tag = Item.logout.rawValue


            return [
                profile,
                address,
                payment,
                spaceCell,
                logout
            ]
        }

        func makeItem(icon: String, title: String) -> knTableCell {
            let imgView = UIMaker.makeImageView(image: UIImage(named: icon), contentMode: .scaleAspectFit)
            imgView.changeColor(to: UIColor.c19)
            let label = UIMaker.makeLabel(text: title,
                                          font: UIFont.main(size: 13),
                                          color: UIColor.c19)
            let arrow = UIMaker.makeImageView(image: UIImage(named: "next_arrow"))
            let line = UIMaker.makeHorizontalLine(color: UIColor(r: 108, g: 123, b: 138, a: 0.08), height: 1)
            let cell = knTableCell()
            cell.addSubviews(views: imgView, label, arrow, line)
            cell.addConstraints(withFormat: "H:|-24-[v0]-24-[v1]",
                                views: imgView, label)
            imgView.square(edge: 20)
            imgView.centerY(toView: cell)

            label.centerY(toView: cell)

            arrow.square(edge: 8)
            arrow.right(toView: cell, space: -24)
            arrow.centerY(toView: cell)

            line.horizontal(toView: cell, leftPadding: 24, rightPadding: 0)
            line.bottom(toView: cell)

            cell.height(66)
            return cell
        }
    }
}


