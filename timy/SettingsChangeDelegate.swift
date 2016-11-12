import Foundation


protocol SettingsChangeDelegate {
    func apiKeyChanged(_ apiKey: String)
    func serverUrlChanged(_ serverUrl: URL)
}
