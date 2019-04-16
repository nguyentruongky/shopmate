//
//  StateView.swift
//  CaloriesTracker
//
//  Created by Ky Nguyen Coinhako on 12/24/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import UIKit

enum knState: String {
    case success
    case noInternet
    case error, empty, loading
    case unknown
}

class knOffineView: knView {
    var retry: (() -> Void)?
}



class knStateView: knView {
    struct StateContent {
        var icon: UIImage?
        var title: String?
        var content: String?
        init(iconName: String?, title: String?, content: String?) {
            if let name = iconName {
                icon = UIImage(named: name)
            }
            self.title = title
            self.content = content
        }
    }
    private var currentView: UIView?
    var retry: (() -> Void)?
    private var customViews = [knState: UIView]()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private var stateContents: [knState: StateContent] = [
        knState.noInternet: StateContent(iconName: "no_internet",
                                         title: "Oops, no connection",
                                         content: "The internet connection appears to be offline."),
        knState.error: StateContent(iconName: "generic_error",
                                    title: "There's an error",
                                    content: "There was an error. Please try again later."),
        knState.empty: StateContent(iconName: "empty",
                                    title: "No content",
                                    content: "I am lonly here"),
    ]

    func setStateContent(state: knState, imageName: String?, title: String?, content: String?) {
        stateContents[state] = StateContent(iconName: imageName, title: title, content: content)
    }

    private func set(icon: UIImage?, title: String?, content: String?) {
        imgView.image = icon
        titleLabel.text = title
        contentLabel.text = content
        if icon == nil {
            imgView.removeFromSuperview()
        }

        if title == nil {
            titleLabel.removeFromSuperview()
        }

        if content == nil {
            contentLabel.removeFromSuperview()
        }
    }

    func setCustomView(_ view: UIView, for state: knState) {
        customViews[state] = view
    }

    private func getView(for state: knState) -> UIView? {
        return customViews[state]
    }

    func show(state: knState, in view: UIView, space: UIEdgeInsets = .zero) {
        view.addSubviews(views: self)
        fill(toView: view, space: space)

        self.state = state
    }

    var state = knState.unknown {
        didSet {
            guard state != oldValue else { return }
            currentView?.removeFromSuperview()
            if let view = customViews[state] {
                currentView = view
                addSubviews(views: view)
                view.center(toView: self)
                clearState()
                currentView = view
                return
            }

            if let stateData = stateContents[state] {
                clearState()
                set(icon: stateData.icon, title: stateData.title, content: stateData.content)
                return
            }

            switch state {
            case .success:
                removeFromSuperview()

            case .loading:
                imgView.loadGif(name: "loading")

            default: break
            }
        }
    }

    private var imgView = UIMaker.makeImageView()
    private let titleLabel = UIMaker.makeLabel(font: UIFont.main(.bold, size: 17),
                                               color: UIColor.darkGray,
                                               numberOfLines: 2, alignment: .center)
    private let contentLabel = UIMaker.makeLabel(font: UIFont.main(.regular, size: 13),
                                                 color: UIColor.lightGray,
                                                 numberOfLines: 2, alignment: .center)
    private let container = UIMaker.makeStackView()
    override func setupView() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        container.addViews(imgView, titleLabel, contentLabel)
        imgView.centerX(toView: container)
        imgView.width(toView: container, multiplier: 0.5, greater: 0)
        imgView.square()

        titleLabel.horizontal(toView: container, space: 16)
        contentLabel.horizontal(toView: titleLabel)

        addSubviews(views: container)
        container.horizontal(toView: self)
        container.centerY(toView: self, space: -75)
    }

    private func clearState() {
        imgView.stopAnimating()
        imgView.image = nil
        titleLabel.text = ""
        contentLabel.text = ""
    }
}

