
import UIKit
import Eureka

class SettingsViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("Settings")
            <<< TextRow(){ row in
                row.textFieldPercentage = 0.6
                row.title = "API-Key:"
                row.placeholder = "foo"
            }
            .cellUpdate { cell, row in
                    cell.textField.textAlignment = .left
            }
            <<< URLRow(){
                $0.textFieldPercentage = 0.6
                $0.title = "Timy Server:"
                $0.placeholder = "https://example.com"
            }
            .cellUpdate { cell, row in
                cell.textField.textAlignment = .left
            }
            +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Test connection"
                }
                .onCellSelection { [weak self] (cell, row) in
                    print("do something")
            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
