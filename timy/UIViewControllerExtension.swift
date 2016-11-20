

import UIKit

public extension UIViewController {
    
    func showError(_ e: Error) -> Void {
        let errorMsg = e.localizedDescription
        let alertController: UIAlertController = UIAlertController(title: "Alert", message: errorMsg, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
