
import Foundation
import SwiftKeychainWrapper

struct TimyData : SettingsChangeDelegate {
    
    static let API_KEY = "apiKey"
    static let SERVER_URL = "serverUrl"
    static var shared = TimyData()
    
    var projects: [Project]
    init() {
        projects = []
    }
    
    
    func apiKeyChanged(_ apiKey: String) {
        saveApiKey(apiKey)
    }
    
    func serverUrlChanged(_ serverUrl: URL) {
        saveServerUrl(serverUrl)
    }
    
    func loadApiKey() -> String? {
        return KeychainWrapper.standard.string(forKey: TimyData.API_KEY)
    }
    
    func loadServerUrl() -> URL? {
        if let serverUrl = KeychainWrapper.standard.string(forKey: TimyData.SERVER_URL) {
            return URL(string: serverUrl)
        }
        else {
            return nil
        }
    }
    
    func saveApiKey(_ apiKey: String) -> Void {
        KeychainWrapper.standard.set(apiKey, forKey: TimyData.API_KEY)
    }
    
    func saveServerUrl(_ serverUrl: URL) -> Void {
        KeychainWrapper.standard.set(serverUrl.absoluteString, forKey: TimyData.SERVER_URL)
    }
}
