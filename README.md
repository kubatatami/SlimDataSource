# SlimDataSource

```swift
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
            })
            .updateData(["iOS", "has","own", "slim", "adapter", 1, 2, 3])
    }
}

```
