//
//  SlimDataSource.swift
//  SlimDataSource
//
//  Created by Jakub Bogacki on 25/07/2019.
//  Copyright © 2019 Jakub Bogacki. All rights reserved.
//

import UIKit

public class SlimTableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private unowned var tableView: UITableView
    private var creators : [String: CreatorProtocol] = [:]

    public var data: [Any] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    public init(_ tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let creator = findCreator(indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: creator.reusableIdentifier, for: indexPath)
        creator.invoke(cell, data[indexPath.row])
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let creator = findCreator(indexPath.row)
        creator.invokeCellClick(data[indexPath.row])
    }

    public func register<V: UITableViewCell, T> (_ nibName: String, _ binder: @escaping (V, T) -> Void, onCellClick: @escaping (T) -> Void = {_ in }) -> Self {
        let nib = UINib(nibName: nibName, bundle: nil)
        return register(nib, nibName, binder, onCellClick: onCellClick)
    }

    public func register<V: UITableViewCell, T> (_ nib: UINib, _ reusableIdentifier: String, _ binder: @escaping (V, T) -> Void, onCellClick: @escaping (T) -> Void = {_ in }) -> Self {
        let nib = UINib(nibName: reusableIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: reusableIdentifier)
        creators[String(describing: T.self)] = TableCreator(reusableIdentifier, binder, onCellClick)
        return self
    }

    public func updateData(_ data: [Any]) -> Self {
        self.data = data
        return self
    }
    
    private func findCreator(_ row: Int) -> CreatorProtocol {
        let item = data[row]
        let itemType = type(of: item)
        return creators[String(describing: itemType)]!
    }
}

private class TableCreator<V: UITableViewCell, T>: CreatorProtocol {
    var reusableIdentifier: String
    var binder: (V, T) -> Void
    var onCellClick: (T) -> Void
    
    init(_ reusableIdentifier: String, _ binder: @escaping (V, T) -> Void, _ onCellClick: @escaping (T) -> Void) {
        self.reusableIdentifier = reusableIdentifier
        self.binder = binder
        self.onCellClick = onCellClick
    }
    
    func invoke(_ cell: Any, _ item: Any) {
        binder(cell as! V, item as! T)
    }
    
    func invokeCellClick(_ item: Any) {
        onCellClick(item as! T)
    }
}

protocol CreatorProtocol {
    var reusableIdentifier: String { get }
   
    func invoke(_ cell: Any, _ item: Any)
    func invokeCellClick(_ item: Any)
}
