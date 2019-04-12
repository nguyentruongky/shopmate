//
//  knPicker.swift
//  SnapShop
//
//  Created by Ky Nguyen Coinhako on 11/5/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import UIKit
class knPickerView: knView {
    private let animationDuration: Double = 0.3
    let contentHeight: CGFloat = 250
    let headerHeight: CGFloat = 50
    
    let confirmButton = UIMaker.makeButton(title: "Done", titleColor: UIColor.black,
                                    font: UIFont.boldSystemFont(ofSize: 14))
    let cancelButton = UIMaker.makeButton(title: "Cancel", titleColor: UIColor.black,
                                           font: UIFont.boldSystemFont(ofSize: 14))
    let headerView = UIMaker.makeView(background: .white)
    let contentView = UIMaker.makeView(background: .white)
    let dismissButton = UIMaker.makeButton()
    let titleLabel = UIMaker.makeLabel(font: UIFont.systemFont(ofSize: 14), color: UIColor.black)
    weak var delegate: knPickerViewDelegate?

    static func make(startDate: Date?) -> knPickerView {
        let dp = knDatePicker()
        dp._picker.date = startDate ?? Date()
        return dp
    }
    
    static func make(texts: [String]) -> knPickerView {
        let dp = knTextPicker()
        dp.textDatasource = texts
        return dp
    }
    
    override func setupView() {
        dismissButton.alpha = 0
        dismissButton.backgroundColor = UIColor.black.alpha(0.5)
        headerView.addSubviews(views: cancelButton, confirmButton)
        cancelButton.left(toView: headerView, space: 20)
        cancelButton.centerY(toView: headerView)
        
        confirmButton.right(toView: headerView, space: -20)
        confirmButton.centerY(toView: headerView)
        
        let line = UIMaker.makeHorizontalLine()
        contentView.addSubviews(views: headerView, line)
        headerView.horizontal(toView: contentView)
        headerView.top(toView: contentView)
        headerView.height(headerHeight)
        
        line.horizontal(toView: contentView)
        line.bottom(toView: headerView)
        
        addSubviews(views: dismissButton, contentView)
        dismissButton.fill(toView: self)
        
        contentView.horizontal(toView: self)
        contentView.verticalSpacing(toView: self)
        contentView.height(contentHeight + headerHeight)
        
        dismissButton.addTarget(self, action: #selector(closeView))
        cancelButton.addTarget(self, action: #selector(closeView))
        confirmButton.addTarget(self, action: #selector(confirm))
    }
    
    @objc func confirm() {}
    
    @objc func closeView() { dismiss() }
    
    func dismiss() {
        UIView.animate(withDuration: animationDuration,
                       animations: { [weak self] in
                        self?.move(up: false)
                        self?.dismissButton.alpha = 0
            }, completion: { [weak self] _ in self?.removeFromSuperview() })
    }
    
    private func move(up: Bool) {
        let posision: CGFloat = contentHeight + headerHeight
        contentView.transform = CGAffineTransform(translationX: 0, y: up ? -posision : 0)
    }

    func show(in controller: UIViewController, completion: (() -> ())? = nil) {
        hideKeyboard()
        controller.view.addSubviews(views: self)
        fill(toView: controller.view)

        UIView.animate(withDuration: animationDuration,
                       delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 5, options: .curveEaseIn,
                       animations: { [weak self] in
                        self?.move(up: true)
                        self?.dismissButton.alpha = 1
            }, completion: { (finished) in completion?() })
    }
    
    func changeDateMode(mode: UIDatePicker.Mode) {
        let picker = self as? knDatePicker
        picker?._picker.datePickerMode = mode
    }
    
    func updateDatasource(_ texts: [String]) {
        let picker = self as? knTextPicker
        picker?.textDatasource = texts
        
    }
}

private class knDatePicker: knPickerView {
    let _picker = UIDatePicker()
    
    override func setupView() {
        super.setupView()
        _picker.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubviews(views: _picker)
        _picker.horizontal(toView: contentView)
        _picker.bottom(toView: contentView)
        _picker.verticalSpacing(toView: headerView)
    }
    
    override func confirm() {
        dismiss()
        delegate?.didSelectDate?(_picker.date)
    }
}

private class knTextPicker: knPickerView {
    private let _picker = UIPickerView()
    var textDatasource = [String]() { didSet {
            _picker.reloadComponent(0)
        }
    }

    override func setupView() {
        super.setupView()
        _picker.translatesAutoresizingMaskIntoConstraints = false
        _picker.dataSource = self
        _picker.delegate = self
        contentView.addSubviews(views: _picker)
        _picker.horizontal(toView: contentView)
        _picker.bottom(toView: contentView)
        _picker.verticalSpacing(toView: headerView)
    }
    
    override func confirm() {
        dismiss()
        let index = _picker.selectedRow(inComponent: 0)
        let text = textDatasource[index]
        delegate?.didSelectText?(text)
    }
}

extension knTextPicker: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return textDatasource.count }
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return textDatasource[row] }
}

@objc protocol knPickerViewDelegate: class {
    @objc optional func didSelectDate(_ date: Date)
    @objc optional func cancel()
    @objc optional func didSelectText(_ text: String)
}
