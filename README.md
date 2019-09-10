# SlimDataSource

## Example

```swift
class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private var tableSource: SlimTableDataSource!
    private var tableDelegate: SlimTableDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableSource = SlimTableDataSource(tableView)
                .register("StringViewCell", { (cell: StringViewCell, item: String) in
                    cell.labelView.text = item
                })
                .register("IntViewCell", { [unowned self] (cell: IntViewCell, item: Int) in
                    cell.label.text = "Int: \(item)"
                    cell.button.addTarget(self, action: #selector(ViewController.buttonClicked), for: .touchDown)
                })
        tableDelegate = SlimTableDelegate(tableSource, tableView).onClick({ (item: String) in print("clicked \(item)") })
        tableSource.updateData(["iOS", "has", "own", "slim", "adapter", 1, 2, 3])
    }
}
```

## Pod

```
pod 'SlimDataSource'
```
