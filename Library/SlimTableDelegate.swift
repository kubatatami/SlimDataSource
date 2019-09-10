//
// Created by Jacek Stasiński on 10/09/2019.
// Copyright (c) 2019 Jakub Bogacki. All rights reserved.
//
import UIKit

public class SlimTableDelegate: NSObject, UITableViewDelegate {

    private let slimTableDataSource: SlimTableDataSource
    private var waiting = false
    private var hasMorePage = true
    private var onNextPageLoad: (()->())?
    private var onClickActions: [String: OnClickProtocol] = [:]

    public init(_ slimTableDataSource: SlimTableDataSource, _ tableView: UITableView) {
        self.slimTableDataSource = slimTableDataSource
        super.init()
        tableView.delegate = self
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = slimTableDataSource.data[indexPath.row]
        let itemType = type(of: item)
        return onClickActions[String(describing: itemType)]!.invokeCellClick(item)
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == slimTableDataSource.data.count - 1 && !waiting  && hasMorePage {
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

class OnItemClickCreator<T>: OnClickProtocol {
    var onCellClick: (T) -> Void

    init(_ onCellClick: @escaping (T) -> Void) {
        self.onCellClick = onCellClick
    }

    func invokeCellClick(_ item: Any) {
        onCellClick(item as! T)
    }
}

protocol OnClickProtocol {
    func invokeCellClick(_ item: Any)
}

