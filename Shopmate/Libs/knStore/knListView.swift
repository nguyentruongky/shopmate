//
//  ListView.swift
//  Ogenii
//
//  Created by Ky Nguyen Coinhako on 7/20/18.
//  Copyright © 2018 Ogenii. All rights reserved.
//

import UIKit

class knListCell<U>: knTableCell {
    var data: U?
}

class knListView<C: knListCell<U>, U>: knView, UITableViewDataSource, UITableViewDelegate {
    var datasource = [U]() { didSet { tableView.reloadData() }}
    fileprivate let cellId = String(describing: C.self)
    var rowHeight: CGFloat = UITableView.automaticDimension
    
    lazy var tableView: UITableView = { [weak self] in
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.separatorStyle = .none
        tb.showsVerticalScrollIndicator = false
        tb.dataSource = self
        tb.delegate = self
        return tb
        }()
    
    override func setupView() {
        addSubview(tableView)
        tableView.fill(toView: self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(C.self, forCellReuseIdentifier: cellId)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! C
        cell.data = datasource[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return rowHeight }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(at: indexPath)
    }
    func didSelectRow(at indexPath: IndexPath) { }
}

class knStaticListView: knView, UITableViewDataSource, UITableViewDelegate {
    var datasource = [knTableCell]() { didSet { tableView.reloadData() }}
    var rowHeight = UITableView.automaticDimension
    
    lazy var tableView: UITableView = { [weak self] in
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.separatorStyle = .none
        tb.showsVerticalScrollIndicator = false
        tb.dataSource = self
        tb.delegate = self
        return tb
        }()
    
    override func setupView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return datasource[indexPath.row] }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(at: indexPath)
    }
    func didSelectRow(at indexPath: IndexPath) { }
}


class knListController<C: knListCell<U>, U>: knController, UITableViewDataSource, UITableViewDelegate {
    var datasource = [U]() { didSet { tableView.reloadData() }}
    fileprivate let cellId = String(describing: C.self)
    var rowHeight = UITableView.automaticDimension
    var contentInset: UIEdgeInsets?
    
    lazy var tableView: UITableView = { [weak self] in
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.separatorStyle = .none
        tb.showsVerticalScrollIndicator = false
        tb.dataSource = self
        tb.delegate = self
        tb.separatorStyle = .none
        return tb
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(C.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100

        setupView()
        view.backgroundColor = .white
        setupKeyboardNotifcationListenerForScrollView(scrollView: tableView)
    }
    
    override func setupView() {
        if let inset = contentInset {
            tableView.contentInset = inset
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(at: indexPath)
    }
    
    func getCell(at index: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: index) as! C
        cell.data = datasource[index.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(at: indexPath)
    }
    func didSelectRow(at indexPath: IndexPath) { }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat { return 0 }
}

class knStaticListController: knController, UITableViewDelegate, UITableViewDataSource {
    var datasource = [UITableViewCell]() { didSet { tableView.reloadData() }}
    var rowHeight = UITableView.automaticDimension
    var contentInset: UIEdgeInsets?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        setupKeyboardNotifcationListenerForScrollView(scrollView: tableView)
    }
    
    func fillList(space: UIEdgeInsets = .zero) {
        view.addSubviews(views: tableView)
        tableView.fill(toView: view, space: space)
    }
    
    override func setupView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        if let inset = contentInset {
            tableView.contentInset = inset
        }
    }
    
    lazy var tableView: UITableView = { [weak self] in
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.separatorStyle = .none
        tb.showsVerticalScrollIndicator = false
        tb.dataSource = self
        tb.delegate = self
        return tb
        }()
    
    deinit {
        print("Deinit \(NSStringFromClass(type(of: self)))")
    }
    func wrapToCell(view: UIView) -> knTableCell {
        let cell = knTableCell()
        cell.addSubview(view)
        view.fill(toView: cell)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return datasource[indexPath.row] }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(at: indexPath)
    }
    func didSelectRow(at indexPath: IndexPath) { }
}
