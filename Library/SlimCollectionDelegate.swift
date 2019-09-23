//
// Created by Jacek Stasiński on 10/09/2019.
// Copyright (c) 2019 Jakub Bogacki. All rights reserved.
//

import UIKit

open class SlimCollectionDelegate: NSObject, UICollectionViewDelegate {

    private let slimCollectionDataSource: SlimCollectionDataSource
    private var waiting = true
    private var hasMorePage = true
    private var onNextPageLoad: (()->())?
    private var onClickActions: [String: OnClickProtocol] = [:]

    public init(_ slimCollectionDataSource: SlimCollectionDataSource, _ collectionView: UICollectionView) {
        self.slimCollectionDataSource = slimCollectionDataSource
        super.init()
        collectionView.delegate = self
    }

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = slimCollectionDataSource.data[indexPath.row]
        let itemType = type(of: item)
        if let action = onClickActions[String(describing: itemType)] {
            action.invokeCellClick(item)
        } else {
            print("Type \(String(describing: itemType)) is not registered")
        }
    }

    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == slimCollectionDataSource.data.count - 1 && !waiting  && hasMorePage {
            waiting = true
            onNextPageLoad?()
        }
    }

    @discardableResult
    public func onClick<T>(_ action: @escaping (T) -> Void) -> Self {
        onClickActions[String(describing: T.self)] = OnItemClickCreator(action)
        return self
    }

    public func nextPageLoaded() {
        waiting = false
    }

    public func allPagesDownloaded() {
        hasMorePage = false
    }

    public func onNextPageLoad(_ action: @escaping ()->()) -> Self {
        onNextPageLoad = action
        return self
    }
}