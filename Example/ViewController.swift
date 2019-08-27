//
//  ViewController.swift
//  SlimDataSource
//
//  Created by Jakub Bogacki on 25/07/2019.
//  Copyright © 2019 Jakub Bogacki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var collectionView: UICollectionView!

    private var tableSource: SlimTableDataSource!
    private var collectionSource: SlimCollectionDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableSource = SlimTableDataSource(tableView)
            .register("StringViewCell", { (cell: StringViewCell, item: String) in
                cell.labelView.text = item
            }, onCellClick: { item in print("clicked \(item)") })
            .register("IntViewCell", { [unowned self] (cell: IntViewCell, item: Int) in
                cell.label.text = "Int: \(item)"
                cell.button.addTarget(self, action: #selector(ViewController.buttonClicked), for: .touchDown)
            })
            .updateData(["iOS", "has","own", "slim", "adapter", 1, 2, 3])
        collectionSource = SlimCollectionDataSource(collectionView)
            .register("StringCollectionViewCell", { (cell: StringCollectionViewCell, item: String) in
                cell.lableView.text = item
            }, onCellClick: { item in print("clicked \(item)") })
            .register("IntCollectionViewCell", { [unowned self] (cell: IntCollectionViewCell, item: Int) in
                cell.buttonView.setTitle("Int: \(item)", for: .normal)
                cell.buttonView.addTarget(self, action: #selector(ViewController.buttonClicked), for: .touchDown)
            })
            .updateData(["iOS", "has","own", "slim", "adapter", 1, 2, 3])
    }
    
    @objc func buttonClicked() {
        print("button clicked")
    }
}
