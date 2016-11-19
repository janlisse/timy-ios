
import UIKit
import Eureka
import SwiftKeychainWrapper

class SettingsViewController: FormViewController, UITabBarControllerDelegate {
    
    let settingsChangeDelegate: SettingsChangeDelegate = TimyData.shared
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if (!(viewController is SettingsViewController)) {
            if let apiKey = form.values()[TimyData.API_KEY] as? String {
                settingsChangeDelegate.apiKeyChanged(apiKey)
            }
            if let serverUrl = form.values()[TimyData.SERVER_URL] as? URL {
                        settingsChangeDelegate.serverUrlChanged(serverUrl)
            }
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        form +++ Section("Settings")
            <<< TextRow(TimyData.API_KEY){ row in
                row.textFieldPercentage = 0.6
                row.title = "API-Key:"
                row.add(rule: RuleRequired())
                if let apiKey = TimyData.shared.loadApiKey() {
                    row.value = apiKey
                }
            }
            <<< URLRow(TimyData.SERVER_URL){
                $0.textFieldPercentage = 0.6
                $0.title = "Timy Server:"
                $0.placeholder = "https://example.com"
                if let serverUrl = TimyData.shared.loadServerUrl() {
                    $0.value = serverUrl
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
