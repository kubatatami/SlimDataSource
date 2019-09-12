//
//  SlimDataSource.swift
//  SlimDataSource
//
//  Created by Jakub Bogacki on 25/07/2019.
//  Copyright © 2019 Jakub Bogacki. All rights reserved.
//

import UIKit

public class SlimCollectionDataSource: NSObject, UICollectionViewDataSource {

    private unowned var collectionView: UICollectionView
    private var creators: [String: CreatorProtocol] = [:]
    public var data: [Any] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    public init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        self.collectionView.dataSource = self
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let creator = findCreator(indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: creator.reusableIdentifier, for: indexPath)
        creator.invoke(cell, data[indexPath.row], indexPath.row)
        return cell
    }

    @discardableResult
    public func register<V: UICollectionViewCell, T>(_ nibName: String, _ binder: @escaping (V, T) -> Void) -> Self {
        return register(nibName, { (cell: V, type: T, index: Int) in binder(cell, type)})
    }

    @discardableResult
    public func register<V: UICollectionViewCell, T>(_ nibName: String, _ binder: @escaping (V, T, Int) -> Void) -> Self {
        let nib = UINib(nibName: nibName, bundle: nil)
        return register(nib, nibName, binder)
    }

    @discardableResult
    public func register<V: UICollectionViewCell, T>(_ nib: UINib, _ reusableIdentifier: String, _ binder: @escaping (V, T) -> Void) -> Self {
        register(nib, reusableIdentifier, { (cell: V, type: T, index: Int) in binder(cell, type)})
        return self
    }

    @discardableResult
    public func register<V: UICollectionViewCell, T>(_ nib: UINib, _ reusableIdentifier: String, _ binder: @escaping (V, T, Int) -> Void) -> Self {
        collectionView.register(nib, forCellWithReuseIdentifier: reusableIdentifier)
        creators[String(describing: T.self)] = CellCreator(reusableIdentifier, binder)
        return self
    }

    @discardableResult
    public func updateData(_ data: [Any]) -> Self {
        self.data = data
        return self
    }

    func findCreator(_ row: Int) -> CreatorProtocol {
        let item = data[row]
        let itemType = type(of: item)
        return creators[String(describing: itemType)]!
    }

}

private class CellCreator<V: UICollectionViewCell, T>: CreatorProtocol {
    var reusableIdentifier: String
    var binder: (V, T, Int) -> Void

    init(_ reusableIdentifier: String, _ binder: @escaping (V, T, Int) -> Void) {
        self.reusableIdentifier = reusableIdentifier
        self.binder = binder
    }

    func invoke(_ cell: Any, _ item: Any, _ index: Int) {
        binder(cell as! V, item as! T, index)
    }
}
