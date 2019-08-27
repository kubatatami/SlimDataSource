//
//  SlimDataSource.swift
//  SlimDataSource
//
//  Created by Jakub Bogacki on 25/07/2019.
//  Copyright © 2019 Jakub Bogacki. All rights reserved.
//

import UIKit

public class SlimCollectionDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private unowned var collectionView: UICollectionView
    private var creators : [String: CreatorProtocol] = [:]

    public var data: [Any] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    public init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let creator = findCreator(indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: creator.reusableIdentifier, for: indexPath)
        creator.invoke(cell, data[indexPath.row])
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let creator = findCreator(indexPath.row)
        creator.invokeCellClick(data[indexPath.row])
    }

    public func register<V: UICollectionViewCell, T> (_ nibName: String, _ binder: @escaping (V, T) -> Void, onCellClick: @escaping (T) -> Void = {_ in }) -> Self {
        let nib = UINib(nibName: nibName, bundle: nil)
        return register(nib, nibName, binder, onCellClick: onCellClick)
    }

    public func register<V: UICollectionViewCell, T> (_ nib: UINib, _ reusableIdentifier: String, _ binder: @escaping (V, T) -> Void, onCellClick: @escaping (T) -> Void = {_ in }) -> Self {
        let nib = UINib(nibName: reusableIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reusableIdentifier)
        creators[String(describing: T.self)] = CellCreator(reusableIdentifier, binder, onCellClick)
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

private class CellCreator<V: UICollectionViewCell, T>: CreatorProtocol {
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