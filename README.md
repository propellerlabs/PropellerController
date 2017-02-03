![Travis](https://api.travis-ci.org/propellerlabs/PropellerController.svg?branch=master)
![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)
![Swift](https://img.shields.io/badge/language-swift-orange.svg)
![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)
![MIT License](https://img.shields.io/badge/license-MIT-000000.svg)

#Propeller Controller


The goal of this framework is to allow you to move as much of your table/collection controller content off into a static var elsewhere, to remove clutter, reduce state, and increase code clairity.


## Installation


### Carthage

```
github "propellerlabs/PropellerController"
```

### CocoaPods

Cocoapods will come soon, faster if there is a demand for it.

### Swift Package Manager 

Unfortunately because of this library's dependency on `UIKit` it is currently impossible to support SPM.


##Usage


### 1. Create a static var somewhere to configure your controller
```Swift
struct TableController {
    
    static var nameSelection: (UITableView) -> GeneralTableController<NameCell, NameData> = { table in
        let controller = GeneralTableController<NameCell, NameData>()
        controller.tableView = table
       
        controller.willDisplayCell = { cell, data, iPath in
            cell.name = data.first
            cell.image.asyncSetImage(data.imagePath)
            cell.location = "row:" + iPath.row
        }
        
        return controller
    }
```
### 2. Define it in your view controller!

```Swift
final class PeopleViewController: UIViewController {
    @IBOutlet tableView: UITableView!
    var dataSource: [NameData]()
    
    lazy var tableController: GeneralTableController<NameCell, NameData> = {
        let controller = TableController.nameSelection(self.tableView)

        //ADD VC LINKED CONFIFGURATION!
        controller.setDataSource(self.dataSource)
        tableController.didSelectCell = { [weak self] _, _, path in 
            self?.selected(indexPath: path)
        }
    }()
    
    func selected(indexPath: IndexPath) {
        print("row \(indexPath.row) was selected!"
    }
}
```
### 3. Link to view controller methods or parameters where necessary

Define VC specific `didSelectCell` function
```Swift
tableController.didSelectCell = { [weak self] _, _, path in 
    self?.selected(indexPath: path)
}
```
Set the controller data source with `setDataSource(dataSource)` which takes in an `Array<DataType>` or `Array<Array<DataType>>`.

```Swift
var sectionedDataSource: [[DataType]]
controller.setDataSource(sectionedDataSource)

var dataSource = [DataType]
controller.setDataSource(dataSource)
```


For **UICollectionView** we have you covered, just use `GeneralCollectionController` instead.


### 4. Want to handle multiple selections? 

We got you covered with **GeneralMultiSelectionTableController**

- We configure it the same way:
```Swift
struct TableController {
    
    static let sampleData = ["Item one", "Item two"]
    
    ....
    
    static var nameMultiSelection: (UITableView) -> GeneralMultiSelectionTableController<NameCell, String> = { table in
        let controller = GeneralMultiSelectionTableController<NameCell, String>()
        controller.tableView = table
        controller.setDataSource(sampleData)
        return controller
    }
```
- Except now we can get a `Set` of all of the selected `Hashable` DataType for selected cells:
```Swift
    let seletedNames = TableNameController.selectionSource
    
    for name in selectedNames {
        print("\(name) was selected!")
    }
```
