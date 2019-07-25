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
    
    private var source: SlimTableDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        source = SlimTableDataSource(tableView)
            .register("StringViewCell", { (cell: StringViewCell, item: String) in
                cell.labelView.text = item
            }, onCellClick: { item in print("clicked \(item)") })
            .register("IntViewCell", { [unowned self] (cell: IntViewCell, item: Int) in
                cell.label.text = "Int: \(item)"
                cell.button.addTarget(self, action: #selector(ViewController.buttonClicked), for: .touchDown)
            })
            .updateData(["iOS", "has","own", "slim", "adapter", 1, 2, 3])
    }
    
    @objc func buttonClicked() {
        print("button clicked")
    }
}
