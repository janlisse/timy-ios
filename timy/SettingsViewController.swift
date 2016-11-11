
import UIKit
import Eureka
import SwiftKeychainWrapper

class SettingsViewController: FormViewController, UITabBarControllerDelegate {
    
    let API_KEY = "apiKey"
    let SERVER_URL = "serverUrl"
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if (!(viewController is SettingsViewController)) {
            let apiKey = form.values()[API_KEY] as! String
            let serverUrl = form.values()[SERVER_URL] as! URL
            _ = KeychainWrapper.standard.set(apiKey, forKey: API_KEY)
            _ = KeychainWrapper.standard.set(serverUrl.absoluteString, forKey: SERVER_URL)
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        form +++ Section("Settings")
            <<< TextRow(API_KEY){ row in
                row.textFieldPercentage = 0.6
                row.title = "API-Key:"
                row.placeholder = "foo"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                if let apiKey = KeychainWrapper.standard.string(forKey: API_KEY) {
                    row.value = apiKey
                }
            }
            .cellUpdate { cell, row in
                cell.textField.textAlignment = .left
                if !row.isValid {
                    cell.backgroundColor = .red
                } else {
                    cell.backgroundColor = .white
                }
            }
            <<< URLRow(SERVER_URL){
                $0.textFieldPercentage = 0.6
                $0.title = "Timy Server:"
                $0.placeholder = "https://example.com"
                if let serverUrl = KeychainWrapper.standard.string(forKey: SERVER_URL) {
                    $0.value = URL(string: serverUrl)
                }
            }
            .cellUpdate { cell, row in
                cell.textField.textAlignment = .left
            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
